import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/common/widgets/form_fields/form_fields.dart';
import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEmployeeDialog(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Add Staff", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: "Employee Directory",
              onBack: widget.onBack ?? () => Navigator.of(context).maybePop(),
              action: AppHeaderActionBadge.refresh(
                onTap: () {
                  controller.fetchOptions();
                  controller.fetchEmployees();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Obx(() => CustomSegmentedTabBar(
                    controller: _tabController,
                    tabs: [
                      SegmentTab(
                        label: "Active Staff",
                        icon: const Icon(Iconsax.user_tick),
                        badgeCount: controller.activeEmployees.length,
                      ),
                      SegmentTab(
                        label: "Disabled Staff",
                        icon: const Icon(Iconsax.user_remove),
                        badgeCount: controller.disabledEmployees.length,
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 6),
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
          // 1. Search Input using CustomSearchField
          CustomSearchField(
            controller: _searchController,
            hintText: "Search staff by name, email, phone or ID...",
            onChanged: controller.onSearchChanged,
            onClear: () => controller.onSearchChanged(''),
          ),

          const SizedBox(height: 10),

          // 2. Branch & Department Searchable Dropdown Filters
          Obx(() {
            final opts = controller.options.value;
            final branchList = [
              BranchOption(id: 0, name: "All Branches"),
              if (opts?.branches != null) ...opts!.branches,
            ];
            final deptList = [
              DepartmentOption(id: 0, name: "All Depts"),
              if (opts?.departments != null) ...opts!.departments,
            ];

            return Row(
              children: [
                // Branch filter
                Expanded(
                  child: CustomDropdownField<int>(
                    value: controller.selectedBranchId.value ?? 0,
                    searchable: true,
                    sheetTitle: "Select Branch",
                    hintText: "All Branches",
                    searchPlaceholder: "Search branches...",
                    prefixIcon: const Icon(Iconsax.building, size: 16, color: Color(0xFF2563EB)),
                    items: branchList.map((b) => b.id).toList(),
                    itemLabelBuilder: (id) => branchList.firstWhere((b) => b.id == id, orElse: () => branchList.first).name,
                    onChanged: (val) => controller.filterByBranch(val == 0 ? null : val),
                  ),
                ),
                const SizedBox(width: 8),

                // Department filter
                Expanded(
                  child: CustomDropdownField<int>(
                    value: controller.selectedDepartmentId.value ?? 0,
                    searchable: true,
                    sheetTitle: "Select Department",
                    hintText: "All Depts",
                    searchPlaceholder: "Search departments...",
                    prefixIcon: const Icon(Iconsax.hierarchy, size: 16, color: Color(0xFF2563EB)),
                    items: deptList.map((d) => d.id).toList(),
                    itemLabelBuilder: (id) => deptList.firstWhere((d) => d.id == id, orElse: () => deptList.first).name,
                    onChanged: (val) => controller.filterByDepartment(val == 0 ? null : val),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showEmployeeDetails(context, emp),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with robust error fallback
                    _buildAvatarWidget(emp.avatar, initials, isActiveList, radius: 22),
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

                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 6),

                // ACTIONS ROW: Scrollable horizontal row to NEVER overflow on small screens
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 1. Edit Profile
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Iconsax.edit_2, size: 13, color: Color(0xFF2563EB)),
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
                        icon: const Icon(Iconsax.key, size: 13, color: Color(0xFFD97706)),
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
                          size: 13,
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
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Iconsax.trash, size: 13, color: Color(0xFFDC2626)),
                        label: const Text("Delete", style: TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                        onPressed: () => _confirmDelete(context, emp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Safe avatar builder handling 404s
  Widget _buildAvatarWidget(String? avatarUrl, String initials, bool isActive, {double radius = 22}) {
    final bgColor = isActive ? const Color(0xFFEFF6FF) : const Color(0xFFFEE2E2);
    final textColor = isActive ? const Color(0xFF2563EB) : const Color(0xFFDC2626);

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: (avatarUrl != null && avatarUrl.isNotEmpty)
            ? Image.network(
                avatarUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: radius * 0.6,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
      ),
    );
  }

  // =========================================================================
  // VIEW FULL EMPLOYEE DETAILS MODAL
  // =========================================================================
  void _showEmployeeDetails(BuildContext context, ManagerEmployeeModel initialEmp) {
    ManagerEmployeeModel emp = initialEmp;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDetailState) {
          if (emp.address == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final full = await controller.fetchEmployeeDetail(emp.id);
              if (full != null && ctx.mounted) {
                setDetailState(() => emp = full);
              }
            });
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.90,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar
                Row(
                  children: [
                    _buildAvatarWidget(emp.avatar, emp.name.isNotEmpty ? emp.name[0].toUpperCase() : 'E', emp.isActive, radius: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            emp.designation?.name ?? emp.department?.name ?? "Staff Member",
                            style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "ID: ${emp.employeeId}",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: emp.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        emp.isActive ? "Active Account" : "Disabled Account",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: emp.isActive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Content Sections
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Employment & Role
                        _buildDetailSectionTitle("1. EMPLOYMENT & ROLE DETAILS", Iconsax.briefcase),
                        _buildDetailGrid([
                          _DetailItem("Branch", emp.branch?.name ?? "—"),
                          _DetailItem("Department", emp.department?.name ?? "—"),
                          _DetailItem("Designation", emp.designation?.name ?? "—"),
                          _DetailItem("Shift Schedule", emp.shift?.name ?? "—"),
                          _DetailItem("Employment Type", emp.employmentType ?? "Full Time"),
                          _DetailItem("Date of Joining", emp.dateOfJoining ?? "—"),
                          _DetailItem("Date of Birth", emp.dateOfBirth ?? "—"),
                          _DetailItem("Gender", emp.gender ?? "—"),
                          _DetailItem("Biometric ID", (emp.biometricEmpId != null && emp.biometricEmpId!.isNotEmpty) ? emp.biometricEmpId! : "—"),
                          _DetailItem("Basic Salary", emp.basicSalary > 0 ? NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0).format(emp.basicSalary) : "—"),
                          _DetailItem("Work Schedule", "${emp.hoursPerDay.toStringAsFixed(0)} hrs/day • ${emp.daysPerWeek} days/wk"),
                        ]),

                        const SizedBox(height: 20),

                        // Section 2: Contact Information & Address
                        _buildDetailSectionTitle("2. CONTACT & ADDRESS", Iconsax.location),
                        _buildDetailGrid([
                          _DetailItem("Email", emp.email),
                          _DetailItem("Mobile Phone", emp.mobileNo ?? "—"),
                          _DetailItem("Address Line 1", emp.address?.addressLine1 ?? emp.address?.displayAddress ?? "—"),
                          _DetailItem("Address Line 2", (emp.address?.addressLine2 != null && emp.address!.addressLine2!.isNotEmpty) ? emp.address!.addressLine2! : "—"),
                          _DetailItem("City / State", [emp.address?.city, emp.address?.state].where((s) => s != null && s.trim().isNotEmpty).isNotEmpty ? [emp.address?.city, emp.address?.state].where((s) => s != null && s.trim().isNotEmpty).join(", ") : "—"),
                          _DetailItem("Country / Postal", [emp.address?.country, emp.address?.postalCode].where((s) => s != null && s.trim().isNotEmpty).isNotEmpty ? [emp.address?.country, emp.address?.postalCode].where((s) => s != null && s.trim().isNotEmpty).join(" - ") : "—"),
                        ]),

                        const SizedBox(height: 20),

                    // Section 3: Emergency Contact
                    _buildDetailSectionTitle("3. EMERGENCY CONTACT", Iconsax.call),
                    _buildDetailGrid([
                      _DetailItem("Contact Name", emp.emergencyContact?.name ?? "—"),
                      _DetailItem("Relationship", emp.emergencyContact?.relationship ?? "—"),
                      _DetailItem("Contact Number", emp.emergencyContact?.number ?? "—"),
                    ]),

                    const SizedBox(height: 20),

                    // Section 4: Bank Details
                    _buildDetailSectionTitle("4. BANKING & PAYROLL", Iconsax.card),
                    _buildDetailGrid([
                      _DetailItem("Bank Name", emp.bankDetails?.bankName ?? "—"),
                      _DetailItem("Account Holder", emp.bankDetails?.accountHolderName ?? "—"),
                      _DetailItem("Account Number", emp.bankDetails?.accountNumber ?? "—"),
                      _DetailItem("Bank Branch", emp.bankDetails?.bankBranch ?? "—"),
                      _DetailItem("SWIFT / BIC", emp.bankDetails?.bankIdentifierCode ?? "—"),
                      _DetailItem("Tax ID / SSN", emp.bankDetails?.taxPayerId ?? "—"),
                    ]),

                    const SizedBox(height: 20),

                    // Section 5: Documents
                    _buildDetailSectionTitle("5. EMPLOYEE DOCUMENTS", Iconsax.document_text),
                    if (emp.documents.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Text(
                          "No documents uploaded for this staff member.",
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      )
                    else
                      Column(
                        children: emp.documents.map((doc) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Iconsax.document, size: 20, color: Color(0xFF2563EB)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.documentName,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                      ),
                                      if (doc.isRequired)
                                        const Text(
                                          "Mandatory Document",
                                          style: TextStyle(fontSize: 10, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.trash, size: 16, color: Color(0xFFDC2626)),
                                  tooltip: "Delete Document",
                                  onPressed: () async {
                                    final ok = await controller.deleteDocument(emp.id, doc.id);
                                    if (ok && ctx.mounted) {
                                      Navigator.pop(ctx);
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Quick Actions
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: const Color(0xFF2563EB).withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Iconsax.edit, size: 16, color: Color(0xFF2563EB)),
                    label: const Text("Edit Staff", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showEditEmployeeDialog(context, emp);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Iconsax.key, size: 16, color: Colors.white),
                    label: const Text("Reset Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showResetPasswordDialog(context, emp);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
);
}

  Widget _buildDetailSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(List<_DetailItem> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: items.map((it) {
          return SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(it.label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  it.value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================================================================
  // RESET PASSWORD DIALOG (Responsive with Expanded title to prevent overflow)
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
            Expanded(
              child: Text(
                "Reset Password for ${emp.name}",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFF64748B).withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel", style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final ok = await controller.resetEmployeePassword(emp.id, passCtrl.text, confirmCtrl.text);
                      if (ok && ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Set Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
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
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFF64748B).withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel", style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: willDisable ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await controller.toggleEmployeeStatus(emp);
                  },
                  child: Text(willDisable ? "Disable" : "Enable", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
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
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFF64748B).withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel", style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await controller.deleteEmployee(emp.id);
                  },
                  child: const Text("Delete", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // UNIFIED EMPLOYEE FORM MODAL (Add & Edit with Cascading & Prefill)
  // =========================================================================
  void _showAddEmployeeDialog(BuildContext context) => _showEmployeeFormModal(context);
  void _showEditEmployeeDialog(BuildContext context, ManagerEmployeeModel emp) => _showEmployeeFormModal(context, employee: emp);

  void _showEmployeeFormModal(BuildContext context, {ManagerEmployeeModel? employee}) {
    if (controller.options.value == null) {
      controller.fetchOptions();
    }

    final isEditing = employee != null;
    final formKey = GlobalKey<FormState>();
    final opts = controller.options.value;

    // Form inputs
    final nameCtrl = TextEditingController(text: employee?.name ?? '');
    final emailCtrl = TextEditingController(text: employee?.email ?? '');
    final passCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: employee?.mobileNo ?? '');
    final empIdCtrl = TextEditingController(text: employee?.employeeId ?? controller.generatedEmployeeId);
    final biometricEmpIdCtrl = TextEditingController(text: employee?.biometricEmpId ?? '');
    final salaryCtrl = TextEditingController(text: (employee != null && employee.basicSalary > 0) ? employee.basicSalary.toStringAsFixed(0) : '');
    final hoursCtrl = TextEditingController(text: (employee?.hoursPerDay ?? 8).toStringAsFixed(0));
    final daysCtrl = TextEditingController(text: (employee?.daysPerWeek ?? 6).toString());
    final ratePerHourCtrl = TextEditingController(text: (employee != null && employee.ratePerHour > 0) ? employee.ratePerHour.toStringAsFixed(0) : '');

    // Address
    final addressLine1Ctrl = TextEditingController(text: employee?.address?.addressLine1 ?? employee?.address?.displayAddress ?? '');
    final addressLine2Ctrl = TextEditingController(text: employee?.address?.addressLine2 ?? '');
    final cityCtrl = TextEditingController(text: employee?.address?.city ?? '');
    final stateCtrl = TextEditingController(text: employee?.address?.state ?? '');
    final countryCtrl = TextEditingController(text: employee?.address?.country ?? '');
    final postalCodeCtrl = TextEditingController(text: employee?.address?.postalCode ?? '');

    // Emergency Contact
    final emergencyNameCtrl = TextEditingController(text: employee?.emergencyContact?.name ?? '');
    final emergencyRelationshipCtrl = TextEditingController(text: employee?.emergencyContact?.relationship ?? '');
    final emergencyPhoneCtrl = TextEditingController(text: employee?.emergencyContact?.number ?? '');

    // Bank Details
    final bankNameCtrl = TextEditingController(text: employee?.bankDetails?.bankName ?? '');
    final accountHolderCtrl = TextEditingController(text: employee?.bankDetails?.accountHolderName ?? '');
    final accountNumberCtrl = TextEditingController(text: employee?.bankDetails?.accountNumber ?? '');
    final bankBranchCtrl = TextEditingController(text: employee?.bankDetails?.bankBranch ?? '');
    final swiftCtrl = TextEditingController(text: employee?.bankDetails?.bankIdentifierCode ?? '');
    final taxIdCtrl = TextEditingController(text: employee?.bankDetails?.taxPayerId ?? '');
    bool isBankDetailsExpanded = isEditing && (bankNameCtrl.text.isNotEmpty || accountNumberCtrl.text.isNotEmpty);

    // Dates
    DateTime joiningDate = employee?.dateOfJoining != null ? (DateTime.tryParse(employee!.dateOfJoining!) ?? DateTime.now()) : DateTime.now();
    DateTime? dob = employee?.dateOfBirth != null ? DateTime.tryParse(employee!.dateOfBirth!) : null;

    // Branches & Cascading Setup
    final branches = opts?.branches ?? (employee?.branch != null ? [employee!.branch!] : []);
    int? branchId = employee?.branch?.id ?? (branches.isNotEmpty ? branches.first.id : null);

    List<DepartmentOption> availableDepartments = controller.getDepartmentsForBranch(branchId);
    if (employee?.department != null && !availableDepartments.any((d) => d.id == employee!.department!.id)) {
      availableDepartments = [employee!.department!, ...availableDepartments];
    }
    int? deptId = employee?.department?.id ?? (availableDepartments.isNotEmpty ? availableDepartments.first.id : null);

    List<DesignationOption> availableDesignations = controller.getDesignationsForDepartment(deptId, branchId: branchId);
    if (employee?.designation != null && !availableDesignations.any((d) => d.id == employee!.designation!.id)) {
      availableDesignations = [employee!.designation!, ...availableDesignations];
    }
    int? desigId = employee?.designation?.id ?? (availableDesignations.isNotEmpty ? availableDesignations.first.id : null);

    final shifts = opts?.shifts ?? (employee?.shift != null ? [employee!.shift!] : []);
    int? shiftId = employee?.shift?.id ?? (shifts.isNotEmpty ? shifts.first.id : null);

    final employmentTypes = opts?.employmentTypes.isNotEmpty == true
        ? opts!.employmentTypes
        : [
            GenericOption(id: 'full_time', name: 'Full Time'),
            GenericOption(id: 'part_time', name: 'Part Time'),
            GenericOption(id: 'contractual', name: 'Contractual'),
            GenericOption(id: 'internship', name: 'Internship'),
          ];
    final empTypeVal = employee?.employmentType;
    String empType = empTypeVal != null
        ? employmentTypes.firstWhere(
            (e) => e.id.toString().toLowerCase() == empTypeVal.toLowerCase() || e.name.toLowerCase() == empTypeVal.toLowerCase(),
            orElse: () => employmentTypes.first,
          ).id.toString()
        : employmentTypes.first.id.toString();

    final genders = opts?.genders.isNotEmpty == true
        ? opts!.genders
        : [
            GenericOption(id: 'male', name: 'Male'),
            GenericOption(id: 'female', name: 'Female'),
            GenericOption(id: 'other', name: 'Other'),
          ];
    final genderVal = employee?.gender;
    String gender = genderVal != null
        ? genders.firstWhere(
            (g) => g.id.toString().toLowerCase() == genderVal.toLowerCase() || g.name.toLowerCase() == genderVal.toLowerCase(),
            orElse: () => genders.first,
          ).id.toString()
        : genders.first.id.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          if (!isEditing && empIdCtrl.text.isEmpty && controller.generatedEmployeeId.isNotEmpty) {
            empIdCtrl.text = controller.generatedEmployeeId;
          }

          if (isEditing && employee.address == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final full = await controller.fetchEmployeeDetail(employee.id);
              if (full != null && ctx.mounted) {
                setModalState(() {
                  if (biometricEmpIdCtrl.text.isEmpty && full.biometricEmpId != null) {
                    biometricEmpIdCtrl.text = full.biometricEmpId!;
                  }
                  if (full.address != null) {
                    if (addressLine1Ctrl.text.isEmpty) addressLine1Ctrl.text = full.address?.addressLine1 ?? full.address?.displayAddress ?? '';
                    if (addressLine2Ctrl.text.isEmpty) addressLine2Ctrl.text = full.address?.addressLine2 ?? '';
                    if (cityCtrl.text.isEmpty) cityCtrl.text = full.address?.city ?? '';
                    if (stateCtrl.text.isEmpty) stateCtrl.text = full.address?.state ?? '';
                    if (countryCtrl.text.isEmpty) countryCtrl.text = full.address?.country ?? '';
                    if (postalCodeCtrl.text.isEmpty) postalCodeCtrl.text = full.address?.postalCode ?? '';
                  }
                  if (full.emergencyContact != null) {
                    if (emergencyNameCtrl.text.isEmpty) emergencyNameCtrl.text = full.emergencyContact?.name ?? '';
                    if (emergencyRelationshipCtrl.text.isEmpty) emergencyRelationshipCtrl.text = full.emergencyContact?.relationship ?? '';
                    if (emergencyPhoneCtrl.text.isEmpty) emergencyPhoneCtrl.text = full.emergencyContact?.number ?? '';
                  }
                  if (full.bankDetails != null) {
                    if (bankNameCtrl.text.isEmpty) bankNameCtrl.text = full.bankDetails?.bankName ?? '';
                    if (accountHolderCtrl.text.isEmpty) accountHolderCtrl.text = full.bankDetails?.accountHolderName ?? '';
                    if (accountNumberCtrl.text.isEmpty) accountNumberCtrl.text = full.bankDetails?.accountNumber ?? '';
                    if (bankBranchCtrl.text.isEmpty) bankBranchCtrl.text = full.bankDetails?.bankBranch ?? '';
                    if (swiftCtrl.text.isEmpty) swiftCtrl.text = full.bankDetails?.bankIdentifierCode ?? '';
                    if (taxIdCtrl.text.isEmpty) taxIdCtrl.text = full.bankDetails?.taxPayerId ?? '';
                  }
                });
              }
            });
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isEditing ? Iconsax.user_edit : Iconsax.user_add,
                        color: const Color(0xFF2563EB),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEditing ? "Edit ${employee.name}" : "Add New Staff Member",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  isEditing ? "Update employee profile and organizational details" : "Enter employee profile and organizational details",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),

                // Scrollable Form Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Account & Identity
                          const Text(
                            "1. BASIC & ACCOUNT DETAILS",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Full Name",
                            hintText: "Enter complete name",
                            controller: nameCtrl,
                            isRequired: true,
                            prefixIcon: const Icon(Iconsax.user, size: 18, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "Email Address (Login)",
                            hintText: "staff@company.com",
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            isRequired: true,
                            prefixIcon: const Icon(Iconsax.sms, size: 18, color: Color(0xFF64748B)),
                          ),
                          if (!isEditing) ...[
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "Login Password",
                              hintText: "Min. 6 characters",
                              controller: passCtrl,
                              isPassword: true,
                              isRequired: true,
                              prefixIcon: const Icon(Iconsax.lock, size: 18, color: Color(0xFF64748B)),
                            ),
                          ],
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "Mobile Number",
                            hintText: "+880 1XXXXXXXXX",
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Iconsax.call, size: 18, color: Color(0xFF64748B)),
                          ),

                          const SizedBox(height: 20),
                          // 2. Organization Placement
                          const Text(
                            "2. ORGANIZATION & PLACEMENT",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Employee ID Code",
                                  hintText: "e.g. #EMP-00101",
                                  controller: empIdCtrl,
                                  readOnly: isEditing,
                                  prefixIcon: const Icon(Iconsax.card, size: 18, color: Color(0xFF64748B)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: "Biometric Punch ID",
                                  hintText: "e.g. 1001 (Optional)",
                                  controller: biometricEmpIdCtrl,
                                  prefixIcon: const Icon(Iconsax.finger_scan, size: 18, color: Color(0xFF64748B)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Cascading Branch Select
                          if (branches.isNotEmpty)
                            CustomDropdownField<int>(
                              label: "Assigned Branch",
                              sheetTitle: "Select Branch",
                              searchPlaceholder: "Search branches...",
                              value: branchId,
                              isRequired: true,
                              prefixIcon: const Icon(Iconsax.building, size: 18, color: Color(0xFF64748B)),
                              items: branches.map((b) => b.id).toList(),
                              itemLabelBuilder: (id) => branches.firstWhere((b) => b.id == id, orElse: () => branches.first).name,
                              onChanged: (val) {
                                setModalState(() {
                                  branchId = val;
                                  availableDepartments = controller.getDepartmentsForBranch(branchId);
                                  deptId = availableDepartments.isNotEmpty ? availableDepartments.first.id : null;
                                  availableDesignations = controller.getDesignationsForDepartment(deptId, branchId: branchId);
                                  desigId = availableDesignations.isNotEmpty ? availableDesignations.first.id : null;
                                });
                              },
                            ),
                          const SizedBox(height: 12),

                          // Cascading Department Select
                          CustomDropdownField<int>(
                            label: "Department",
                            sheetTitle: "Select Department",
                            searchPlaceholder: "Search departments...",
                            value: deptId,
                            isRequired: true,
                            prefixIcon: const Icon(Iconsax.hierarchy, size: 18, color: Color(0xFF64748B)),
                            items: availableDepartments.map((d) => d.id).toList(),
                            itemLabelBuilder: (id) => availableDepartments.firstWhere((d) => d.id == id, orElse: () => DepartmentOption(id: id, name: "Department $id")).name,
                            onChanged: (val) {
                              setModalState(() {
                                deptId = val;
                                availableDesignations = controller.getDesignationsForDepartment(deptId, branchId: branchId);
                                desigId = availableDesignations.isNotEmpty ? availableDesignations.first.id : null;
                              });
                            },
                          ),
                          const SizedBox(height: 12),

                          // Cascading Designation Select
                          CustomDropdownField<int>(
                            label: "Designation / Role",
                            sheetTitle: "Select Designation",
                            searchPlaceholder: "Search designations...",
                            value: desigId,
                            isRequired: true,
                            prefixIcon: const Icon(Iconsax.briefcase, size: 18, color: Color(0xFF64748B)),
                            items: availableDesignations.map((d) => d.id).toList(),
                            itemLabelBuilder: (id) => availableDesignations.firstWhere((d) => d.id == id, orElse: () => DesignationOption(id: id, name: "Designation $id")).name,
                            onChanged: (val) => setModalState(() => desigId = val),
                          ),
                          const SizedBox(height: 12),

                          // Shift Select
                          if (shifts.isNotEmpty)
                            CustomDropdownField<int>(
                              label: "Work Shift Schedule",
                              sheetTitle: "Select Shift",
                              searchPlaceholder: "Search shifts...",
                              value: shiftId,
                              prefixIcon: const Icon(Iconsax.clock, size: 18, color: Color(0xFF64748B)),
                              items: shifts.map((s) => s.id).toList(),
                              itemLabelBuilder: (id) => shifts.firstWhere((s) => s.id == id, orElse: () => shifts.first).name,
                              onChanged: (val) => setModalState(() => shiftId = val),
                            ),

                          const SizedBox(height: 20),
                          // 3. Compensation & Dates
                          const Text(
                            "3. COMPENSATION & DATES",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Monthly Basic Salary (BDT)",
                            hintText: "0.00",
                            controller: salaryCtrl,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Iconsax.dollar_circle, size: 18, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDatePickerField(
                                  label: "Date of Joining",
                                  selectedDate: joiningDate,
                                  onDateSelected: (date) => setModalState(() => joiningDate = date),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDatePickerField(
                                  label: "Date of Birth",
                                  selectedDate: dob,
                                  onDateSelected: (date) => setModalState(() => dob = date),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Hours / Day",
                                  hintText: "8",
                                  controller: hoursCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: "Days / Week",
                                  hintText: "6",
                                  controller: daysCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: "Rate / Hour",
                                  hintText: "0.00",
                                  controller: ratePerHourCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          // Employment Type & Gender
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdownField<String>(
                                  label: "Employment Type",
                                  value: empType,
                                  items: employmentTypes.map((e) => e.id.toString()).toList(),
                                  itemLabelBuilder: (val) => employmentTypes.firstWhere((e) => e.id.toString() == val, orElse: () => employmentTypes.first).name,
                                  onChanged: (val) => setModalState(() => empType = val ?? employmentTypes.first.id.toString()),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDropdownField<String>(
                                  label: "Gender",
                                  value: gender,
                                  isRequired: true,
                                  items: genders.map((e) => e.id.toString()).toList(),
                                  itemLabelBuilder: (val) => genders.firstWhere((e) => e.id.toString() == val, orElse: () => genders.first).name,
                                  onChanged: (val) => setModalState(() => gender = val ?? genders.first.id.toString()),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // 4. Contact & Address
                          const Text(
                            "4. ADDRESS & RESIDENCE",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Address Line 1",
                            hintText: "Street address, house number",
                            controller: addressLine1Ctrl,
                            prefixIcon: const Icon(Iconsax.location, size: 18, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "Address Line 2",
                            hintText: "Apartment, suite, unit (optional)",
                            controller: addressLine2Ctrl,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "City",
                                  hintText: "City name",
                                  controller: cityCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: "State / Province",
                                  hintText: "State",
                                  controller: stateCtrl,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Country",
                                  hintText: "Country name",
                                  controller: countryCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: "Postal Code",
                                  hintText: "ZIP / Postal",
                                  controller: postalCodeCtrl,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // 5. Emergency Contact
                          const Text(
                            "5. EMERGENCY CONTACT",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Emergency Contact Name",
                            hintText: "Contact person full name",
                            controller: emergencyNameCtrl,
                            prefixIcon: const Icon(Iconsax.user_tag, size: 18, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Relationship",
                                  hintText: "e.g. Spouse, Father",
                                  controller: emergencyRelationshipCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: "Contact Phone Number",
                                  hintText: "+880 1XXXXXXXXX",
                                  controller: emergencyPhoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: const Icon(Iconsax.call, size: 18, color: Color(0xFF64748B)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // 6. Banking & Payroll Details (Collapsible)
                          InkWell(
                            onTap: () => setModalState(() => isBankDetailsExpanded = !isBankDetailsExpanded),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "6. BANKING & PAYROLL DETAILS",
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFBFDBFE)),
                                    ),
                                    child: Icon(
                                      isBankDetailsExpanded ? Icons.remove : Icons.add,
                                      size: 14,
                                      color: const Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isBankDetailsExpanded) ...[
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: "Bank Name",
                              hintText: "e.g. BRAC Bank",
                              controller: bankNameCtrl,
                              prefixIcon: const Icon(Iconsax.card, size: 18, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "Account Holder Name",
                                    hintText: "Holder name",
                                    controller: accountHolderCtrl,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    label: "Account Number",
                                    hintText: "Account digits",
                                    controller: accountNumberCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "Bank Branch",
                                    hintText: "Branch name",
                                    controller: bankBranchCtrl,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    label: "SWIFT / BIC Code",
                                    hintText: "SWIFT code",
                                    controller: swiftCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "Tax Payer ID / SSN",
                              hintText: "e.g. TAX-998877",
                              controller: taxIdCtrl,
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),

                // Submit Button
                Obx(() => CustomButton(
                      text: isEditing ? "Save & Update Staff Profile" : "Save & Create Staff Account",
                      variant: CustomButtonVariant.primary,
                      isLoading: controller.isSubmitting.value,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final body = <String, dynamic>{
                            'name': nameCtrl.text.trim(),
                            'email': emailCtrl.text.trim(),
                            if (!isEditing && passCtrl.text.isNotEmpty) 'password': passCtrl.text,
                            if (phoneCtrl.text.isNotEmpty) 'mobile_no': phoneCtrl.text.trim(),
                            if (empIdCtrl.text.isNotEmpty) 'employee_id': empIdCtrl.text.trim(),
                            if (biometricEmpIdCtrl.text.isNotEmpty) 'biometric_emp_id': biometricEmpIdCtrl.text.trim(),
                            if (branchId != null) 'branch_id': branchId,
                            if (deptId != null) 'department_id': deptId,
                            if (desigId != null) 'designation_id': desigId,
                            if (shiftId != null) 'shift_id': shiftId,
                            'employment_type': empType,
                            'gender': gender,
                            'date_of_joining': DateFormat('yyyy-MM-dd').format(joiningDate),
                            if (dob != null) 'date_of_birth': DateFormat('yyyy-MM-dd').format(dob!),
                            if (salaryCtrl.text.isNotEmpty) 'basic_salary': double.tryParse(salaryCtrl.text) ?? 0.0,
                            'hours_per_day': double.tryParse(hoursCtrl.text) ?? 8.0,
                            'days_per_week': int.tryParse(daysCtrl.text) ?? 6,
                            if (ratePerHourCtrl.text.isNotEmpty) 'rate_per_hour': double.tryParse(ratePerHourCtrl.text) ?? 0.0,
                            if (addressLine1Ctrl.text.isNotEmpty) ...{
                              'address_line_1': addressLine1Ctrl.text.trim(),
                              'address': addressLine1Ctrl.text.trim(),
                            },
                            if (addressLine2Ctrl.text.isNotEmpty) 'address_line_2': addressLine2Ctrl.text.trim(),
                            if (cityCtrl.text.isNotEmpty) 'city': cityCtrl.text.trim(),
                            if (stateCtrl.text.isNotEmpty) 'state': stateCtrl.text.trim(),
                            if (countryCtrl.text.isNotEmpty) 'country': countryCtrl.text.trim(),
                            if (postalCodeCtrl.text.isNotEmpty) ...{
                              'postal_code': postalCodeCtrl.text.trim(),
                              'zip_code': postalCodeCtrl.text.trim(),
                            },
                            if (emergencyNameCtrl.text.isNotEmpty) 'emergency_contact_name': emergencyNameCtrl.text.trim(),
                            if (emergencyRelationshipCtrl.text.isNotEmpty) 'emergency_contact_relationship': emergencyRelationshipCtrl.text.trim(),
                            if (emergencyPhoneCtrl.text.isNotEmpty) 'emergency_contact_number': emergencyPhoneCtrl.text.trim(),
                            if (bankNameCtrl.text.isNotEmpty) 'bank_name': bankNameCtrl.text.trim(),
                            if (accountHolderCtrl.text.isNotEmpty) 'account_holder_name': accountHolderCtrl.text.trim(),
                            if (accountNumberCtrl.text.isNotEmpty) 'account_number': accountNumberCtrl.text.trim(),
                            if (bankBranchCtrl.text.isNotEmpty) 'bank_branch': bankBranchCtrl.text.trim(),
                            if (swiftCtrl.text.isNotEmpty) 'bank_identifier_code': swiftCtrl.text.trim(),
                            if (taxIdCtrl.text.isNotEmpty) 'tax_payer_id': taxIdCtrl.text.trim(),
                          };

                          final ok = isEditing
                              ? await controller.updateEmployee(employee.id, body)
                              : await controller.createEmployee(body);
                          if (ok && ctx.mounted) Navigator.pop(ctx);
                        }
                      },
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;
  const _DetailItem(this.label, this.value);
}
