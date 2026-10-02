import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/utils/constants/colors.dart';

class ManagerTeamScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerTeamScreen({super.key, this.onBack});

  @override
  State<ManagerTeamScreen> createState() => _ManagerTeamScreenState();
}

class _ManagerTeamScreenState extends State<ManagerTeamScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ManagerEmployeeController controller = ManagerEmployeeController.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      controller.selectedTab.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                onPressed: widget.onBack,
              )
            : null,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Employee Directory",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              "Staff Management, Roles & Security",
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            tooltip: "Refresh",
            onPressed: () {
              controller.fetchOptions();
              controller.fetchEmployees();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF2563EB),
          indicatorWeight: 3,
          tabs: [
            Obx(() => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.user_tick, size: 16),
                      const SizedBox(width: 8),
                      Text("Active Staff (${controller.activeEmployees.length})"),
                    ],
                  ),
                )),
            Obx(() => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.user_remove, size: 16),
                      const SizedBox(width: 8),
                      Text("Disabled Staff (${controller.disabledEmployees.length})"),
                    ],
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEmployeeDialog(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Add Staff", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // SEARCH & FILTER BAR
          _buildSearchAndFilters(),

          // TAB BAR VIEW CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmployeeList(isActiveList: true),
                _buildEmployeeList(isActiveList: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SEARCH & FILTER BAR
  // =========================================================================
  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          // Search Input
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search staff by name, email, phone or ID...",
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Iconsax.search_normal, size: 18, color: Color(0xFF64748B)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Color(0xFF64748B)),
                        onPressed: () {
                          _searchController.clear();
                          controller.onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Branch & Department Dropdown Filters
          Obx(() {
            final opts = controller.options.value;
            if (opts == null) return const SizedBox.shrink();

            return Row(
              children: [
                // Branch filter
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: controller.selectedBranchId.value,
                        hint: const Text("All Branches", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text("All Branches", style: TextStyle(fontSize: 12)),
                          ),
                          ...opts.branches.map((b) => DropdownMenuItem<int?>(
                                value: b.id,
                                child: Text(b.name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                              )),
                        ],
                        onChanged: (val) => controller.filterByBranch(val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Department filter
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: controller.selectedDepartmentId.value,
                        hint: const Text("All Depts", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text("All Depts", style: TextStyle(fontSize: 12)),
                          ),
                          ...opts.departments.map((d) => DropdownMenuItem<int?>(
                                value: d.id,
                                child: Text(d.name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                              )),
                        ],
                        onChanged: (val) => controller.filterByDepartment(val),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =========================================================================
  // EMPLOYEE LIST
  // =========================================================================
  Widget _buildEmployeeList({required bool isActiveList}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          ),
        );
      }

      final list = isActiveList ? controller.activeEmployees : controller.disabledEmployees;

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActiveList ? Iconsax.user : Iconsax.user_remove,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                isActiveList ? "No active staff found" : "No disabled staff accounts",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              Text(
                isActiveList
                    ? "Tap '+ Add Staff' to onboard a new employee"
                    : "Disabled staff accounts will appear here",
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchEmployees(),
        color: const Color(0xFF2563EB),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final emp = list[index];
            return _buildEmployeeCard(emp, isActiveList);
          },
        ),
      );
    });
  }

  // =========================================================================
  // INDIVIDUAL EMPLOYEE CARD
  // =========================================================================
  Widget _buildEmployeeCard(ManagerEmployeeModel emp, bool isActiveList) {
    final initials = emp.name.isNotEmpty
        ? emp.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'EM';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActiveList ? const Color(0xFFE2E8F0) : const Color(0xFFFCA5A5).withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: isActiveList ? const Color(0xFFEFF6FF) : const Color(0xFFFEE2E2),
                backgroundImage: emp.avatar != null && emp.avatar!.isNotEmpty ? NetworkImage(emp.avatar!) : null,
                child: emp.avatar == null || emp.avatar!.isEmpty
                    ? Text(
                        initials,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isActiveList ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            emp.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            emp.employeeId,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      emp.designation?.name ?? emp.department?.name ?? "Staff",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(height: 4),

                    // Branch & Email
                    Row(
                      children: [
                        if (emp.branch != null) ...[
                          const Icon(Iconsax.building, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(emp.branch!.name, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const SizedBox(width: 10),
                        ],
                        const Icon(Iconsax.sms, size: 12, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            emp.email,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (emp.mobileNo != null && emp.mobileNo!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Iconsax.call, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(emp.mobileNo!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          if (emp.basicSalary > 0) ...[
                            const SizedBox(width: 10),
                            const Icon(Iconsax.dollar_circle, size: 12, color: Color(0xFF059669)),
                            const SizedBox(width: 4),
                            Text(
                              NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0).format(emp.basicSalary),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          // ACTIONS ROW: ✏️ Edit Profile | 🔑 Reset Password | 🚫 Toggle Status | 🗑️ Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 1. Edit Profile
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Iconsax.edit_2, size: 14, color: Color(0xFF2563EB)),
                label: const Text("Edit", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                onPressed: () => _showEditEmployeeDialog(context, emp),
              ),
              const SizedBox(width: 6),

              // 2. Reset Password
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Iconsax.key, size: 14, color: Color(0xFFD97706)),
                label: const Text("Password", style: TextStyle(fontSize: 11, color: Color(0xFFD97706), fontWeight: FontWeight.bold)),
                onPressed: () => _showResetPasswordDialog(context, emp),
              ),
              const SizedBox(width: 6),

              // 3. Disable / Enable
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  isActiveList ? Iconsax.user_remove : Iconsax.user_tick,
                  size: 14,
                  color: isActiveList ? const Color(0xFFDC2626) : const Color(0xFF059669),
                ),
                label: Text(
                  isActiveList ? "Disable" : "Enable",
                  style: TextStyle(
                    fontSize: 11,
                    color: isActiveList ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => _confirmToggleStatus(context, emp),
              ),
              const SizedBox(width: 6),

              // 4. Delete
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Iconsax.trash, size: 16, color: Color(0xFF94A3B8)),
                tooltip: "Delete Employee",
                onPressed: () => _confirmDelete(context, emp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // RESET PASSWORD DIALOG
  // =========================================================================
  void _showResetPasswordDialog(BuildContext context, ManagerEmployeeModel emp) {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Iconsax.key, color: Color(0xFFD97706), size: 20),
            const SizedBox(width: 8),
            Text("Reset Password for ${emp.name}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Set a new password for this employee account directly without needing their old password.",
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Iconsax.lock, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) => (v == null || v.length < 6) ? "Minimum 6 characters" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Iconsax.lock, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) => v != passCtrl.text ? "Passwords do not match" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final ok = await controller.resetEmployeePassword(emp.id, passCtrl.text, confirmCtrl.text);
                if (ok && ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text("Set Password"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TOGGLE STATUS CONFIRMATION
  // =========================================================================
  void _confirmToggleStatus(BuildContext context, ManagerEmployeeModel emp) {
    final willDisable = !emp.isDisabled;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          willDisable ? "Disable Account Access?" : "Enable Account Access?",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(
          willDisable
              ? "Disabling ${emp.name}'s account will immediately revoke mobile app login access."
              : "Enabling ${emp.name}'s account will restore their login access.",
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: willDisable ? const Color(0xFFDC2626) : const Color(0xFF059669),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.toggleEmployeeStatus(emp);
            },
            child: Text(willDisable ? "Disable Account" : "Enable Account"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // DELETE CONFIRMATION
  // =========================================================================
  void _confirmDelete(BuildContext context, ManagerEmployeeModel emp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Employee Record?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to permanently delete ${emp.name} (${emp.employeeId})? This action cannot be undone.",
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.deleteEmployee(emp.id);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ADD EMPLOYEE MODAL / DIALOG
  // =========================================================================
  void _showAddEmployeeDialog(BuildContext context) {
    final opts = controller.options.value;
    final formKey = GlobalKey<FormState>();

    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController(text: "Password123");
    final phoneCtrl = TextEditingController();
    final empIdCtrl = TextEditingController(text: opts?.generatedEmployeeId ?? "EMP${DateTime.now().year}0001");
    final salaryCtrl = TextEditingController(text: "35000");
    final hoursCtrl = TextEditingController(text: "8");
    final daysCtrl = TextEditingController(text: "6");
    final addressCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: "Dhaka");
    final emergencyNameCtrl = TextEditingController();
    final emergencyPhoneCtrl = TextEditingController();

    int? branchId = opts?.branches.isNotEmpty == true ? opts!.branches.first.id : null;
    int? deptId = opts?.departments.isNotEmpty == true ? opts!.departments.first.id : null;
    int? desigId = opts?.designations.isNotEmpty == true ? opts!.designations.first.id : null;
    int? shiftId = opts?.shifts.isNotEmpty == true ? opts!.shifts.first.id : null;
    String empType = opts?.employmentTypes.isNotEmpty == true ? opts!.employmentTypes.first.id.toString() : 'full_time';
    String gender = opts?.genders.isNotEmpty == true ? opts!.genders.first.id.toString() : 'male';
    String joiningDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String dob = "1998-05-12";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add New Staff Member", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),

              // Form fields
              Expanded(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("ACCOUNT CREDENTIALS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(labelText: "Full Name *", prefixIcon: Icon(Iconsax.user)),
                          validator: (v) => (v == null || v.isEmpty) ? "Name is required" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: "Login Email *", prefixIcon: Icon(Iconsax.sms)),
                          validator: (v) => (v == null || !v.contains('@')) ? "Valid email required" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passCtrl,
                          decoration: const InputDecoration(labelText: "Initial Password *", prefixIcon: Icon(Iconsax.lock)),
                          validator: (v) => (v == null || v.length < 6) ? "Min 6 characters" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: "Mobile Phone", prefixIcon: Icon(Iconsax.call)),
                        ),

                        const SizedBox(height: 20),
                        const Text("ORGANIZATION & PLACEMENT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: empIdCtrl,
                          decoration: const InputDecoration(labelText: "Employee ID Code *", prefixIcon: Icon(Iconsax.card)),
                          validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                        ),
                        const SizedBox(height: 10),

                        // Branch Dropdown
                        if (opts != null && opts.branches.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: branchId,
                            decoration: const InputDecoration(labelText: "Branch *", prefixIcon: Icon(Iconsax.building)),
                            items: opts.branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                            onChanged: (val) => setModalState(() => branchId = val),
                          ),
                        const SizedBox(height: 10),

                        // Department Dropdown
                        if (opts != null && opts.departments.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: deptId,
                            decoration: const InputDecoration(labelText: "Department *", prefixIcon: Icon(Iconsax.hierarchy)),
                            items: opts.departments.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                            onChanged: (val) => setModalState(() => deptId = val),
                          ),
                        const SizedBox(height: 10),

                        // Designation Dropdown
                        if (opts != null && opts.designations.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: desigId,
                            decoration: const InputDecoration(labelText: "Designation *", prefixIcon: Icon(Iconsax.briefcase)),
                            items: opts.designations.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                            onChanged: (val) => setModalState(() => desigId = val),
                          ),
                        const SizedBox(height: 10),

                        // Shift Dropdown
                        if (opts != null && opts.shifts.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: shiftId,
                            decoration: const InputDecoration(labelText: "Shift *", prefixIcon: Icon(Iconsax.clock)),
                            items: opts.shifts.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                            onChanged: (val) => setModalState(() => shiftId = val),
                          ),

                        const SizedBox(height: 20),
                        const Text("COMPENSATION & TERMS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: salaryCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Basic Salary (BDT)", prefixIcon: Icon(Iconsax.dollar_circle)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: hoursCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: "Hours/Day"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: daysCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: "Days/Week"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Text("PERSONAL & EMERGENCY CONTACT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: addressCtrl,
                          decoration: const InputDecoration(labelText: "Address Line", prefixIcon: Icon(Iconsax.location)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: cityCtrl,
                          decoration: const InputDecoration(labelText: "City", prefixIcon: Icon(Iconsax.map)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emergencyNameCtrl,
                          decoration: const InputDecoration(labelText: "Emergency Contact Name", prefixIcon: Icon(Iconsax.user_tag)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emergencyPhoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: "Emergency Contact Phone", prefixIcon: Icon(Iconsax.call)),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final body = {
                        'name': nameCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'password': passCtrl.text,
                        'mobile_no': phoneCtrl.text.trim(),
                        'employee_id': empIdCtrl.text.trim(),
                        if (branchId != null) 'branch_id': branchId,
                        if (deptId != null) 'department_id': deptId,
                        if (desigId != null) 'designation_id': desigId,
                        if (shiftId != null) 'shift_id': shiftId,
                        'employment_type': empType,
                        'gender': gender,
                        'date_of_joining': joiningDate,
                        'date_of_birth': dob,
                        'basic_salary': double.tryParse(salaryCtrl.text) ?? 35000,
                        'hours_per_day': int.tryParse(hoursCtrl.text) ?? 8,
                        'days_per_week': int.tryParse(daysCtrl.text) ?? 6,
                        if (addressCtrl.text.isNotEmpty) 'address_line_1': addressCtrl.text.trim(),
                        if (cityCtrl.text.isNotEmpty) 'city': cityCtrl.text.trim(),
                        if (emergencyNameCtrl.text.isNotEmpty) 'emergency_contact_name': emergencyNameCtrl.text.trim(),
                        if (emergencyPhoneCtrl.text.isNotEmpty) 'emergency_contact_number': emergencyPhoneCtrl.text.trim(),
                      };

                      final ok = await controller.createEmployee(body);
                      if (ok && ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Save & Create Employee Account", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // EDIT EMPLOYEE MODAL / DIALOG
  // =========================================================================
  void _showEditEmployeeDialog(BuildContext context, ManagerEmployeeModel emp) {
    final opts = controller.options.value;
    final formKey = GlobalKey<FormState>();

    final nameCtrl = TextEditingController(text: emp.name);
    final emailCtrl = TextEditingController(text: emp.email);
    final phoneCtrl = TextEditingController(text: emp.mobileNo ?? '');
    final salaryCtrl = TextEditingController(text: emp.basicSalary.toStringAsFixed(0));

    int? branchId = emp.branch?.id ?? (opts?.branches.isNotEmpty == true ? opts!.branches.first.id : null);
    int? deptId = emp.department?.id ?? (opts?.departments.isNotEmpty == true ? opts!.departments.first.id : null);
    int? desigId = emp.designation?.id ?? (opts?.designations.isNotEmpty == true ? opts!.designations.first.id : null);
    int? shiftId = emp.shift?.id ?? (opts?.shifts.isNotEmpty == true ? opts!.shifts.first.id : null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit ${emp.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              Expanded(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(labelText: "Full Name *", prefixIcon: Icon(Iconsax.user)),
                          validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(labelText: "Email *", prefixIcon: Icon(Iconsax.sms)),
                          validator: (v) => (v == null || !v.contains('@')) ? "Valid email required" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneCtrl,
                          decoration: const InputDecoration(labelText: "Mobile Phone", prefixIcon: Icon(Iconsax.call)),
                        ),
                        const SizedBox(height: 10),
                        if (opts != null && opts.branches.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: branchId,
                            decoration: const InputDecoration(labelText: "Branch", prefixIcon: Icon(Iconsax.building)),
                            items: opts.branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                            onChanged: (val) => setModalState(() => branchId = val),
                          ),
                        const SizedBox(height: 10),
                        if (opts != null && opts.departments.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: deptId,
                            decoration: const InputDecoration(labelText: "Department", prefixIcon: Icon(Iconsax.hierarchy)),
                            items: opts.departments.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                            onChanged: (val) => setModalState(() => deptId = val),
                          ),
                        const SizedBox(height: 10),
                        if (opts != null && opts.designations.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: desigId,
                            decoration: const InputDecoration(labelText: "Designation", prefixIcon: Icon(Iconsax.briefcase)),
                            items: opts.designations.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                            onChanged: (val) => setModalState(() => desigId = val),
                          ),
                        const SizedBox(height: 10),
                        if (opts != null && opts.shifts.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: shiftId,
                            decoration: const InputDecoration(labelText: "Shift", prefixIcon: Icon(Iconsax.clock)),
                            items: opts.shifts.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                            onChanged: (val) => setModalState(() => shiftId = val),
                          ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: salaryCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Basic Salary (BDT)", prefixIcon: Icon(Iconsax.dollar_circle)),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final body = {
                        'name': nameCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'mobile_no': phoneCtrl.text.trim(),
                        if (branchId != null) 'branch_id': branchId,
                        if (deptId != null) 'department_id': deptId,
                        if (desigId != null) 'designation_id': desigId,
                        if (shiftId != null) 'shift_id': shiftId,
                        'basic_salary': double.tryParse(salaryCtrl.text) ?? 0,
                      };

                      final ok = await controller.updateEmployee(emp.id, body);
                      if (ok && ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
