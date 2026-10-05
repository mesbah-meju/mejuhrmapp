import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/common/widgets/form_fields/form_fields.dart';
import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';

class ManagerAttendanceScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerAttendanceScreen({super.key, this.onBack});

  @override
  State<ManagerAttendanceScreen> createState() => _ManagerAttendanceScreenState();
}

class _ManagerAttendanceScreenState extends State<ManagerAttendanceScreen>
    with SingleTickerProviderStateMixin {
  final ManagerAttendanceController controller = ManagerAttendanceController.instance;
  final ManagerEmployeeController empController = ManagerEmployeeController.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.activeTabIndex.value = _tabController.index;
      }
    });
    controller.fetchOverview();
    controller.fetchAttendances();
    controller.fetchReport();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showManualAttendanceSheet(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.more_time_rounded, color: Colors.white),
        label: const Text("Manual Entry", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: "Team Attendance",
              onBack: widget.onBack ?? () => Navigator.of(context).maybePop(),
              action: AppHeaderActionBadge.refresh(
                onTap: () {
                  controller.fetchOverview();
                  controller.fetchAttendances();
                  controller.fetchReport();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF2563EB),
                  unselectedLabelColor: const Color(0xFF64748B),
                  indicatorColor: const Color(0xFF2563EB),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  tabs: const [
                    Tab(text: "Live Overview", icon: Icon(Iconsax.radar_2, size: 18)),
                    Tab(text: "Attendance Log", icon: Icon(Iconsax.calendar_tick, size: 18)),
                    Tab(text: "Analytics Report", icon: Icon(Iconsax.chart_2, size: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // TAB 1: LIVE TODAY OVERVIEW
                  _buildLiveOverviewTab(),

                  // TAB 2: FILTERABLE ATTENDANCE LOG
                  _buildAttendanceLogTab(),

                  // TAB 3: ANALYTICS & PERIOD REPORT
                  _buildAnalyticsReportTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 1: LIVE TODAY TEAM OVERVIEW (2.1)
  // =========================================================================
  Widget _buildLiveOverviewTab() {
    return Obx(() {
      if (controller.isLoadingOverview.value && controller.overview.value == null) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2563EB)),
        );
      }

      final data = controller.overview.value;
      final summary = data?.summary;
      final roster = data?.roster ?? [];

      return RefreshIndicator(
        onRefresh: controller.fetchOverview,
        color: const Color(0xFF2563EB),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 85),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.calendar_1, size: 18, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Text(
                      "Overview for ${data?.date.isNotEmpty == true ? data!.date : controller.formattedDate}",
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A8A)),
                    ),
                    const Spacer(),
                    if (data?.isHoliday == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFFDE68A), borderRadius: BorderRadius.circular(6)),
                        child: Text(data?.holidayName ?? "Holiday", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // KPI Counters Grid
              Row(
                children: [
                  _buildOverviewKpiCard("Staff", "${summary?.totalEmployees ?? 0}", Iconsax.people, const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
                  const SizedBox(width: 8),
                  _buildOverviewKpiCard("Clocked In", "${summary?.clockedInNow ?? 0}", Iconsax.timer_1, const Color(0xFF059669), const Color(0xFFDCFCE7)),
                  const SizedBox(width: 8),
                  _buildOverviewKpiCard("Present", "${summary?.presentToday ?? 0}", Iconsax.tick_circle, const Color(0xFF0D9488), const Color(0xFFCCFBF1)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildOverviewKpiCard("Late", "${summary?.lateToday ?? 0}", Iconsax.warning_2, const Color(0xFFD97706), const Color(0xFFFEF3C7)),
                  const SizedBox(width: 8),
                  _buildOverviewKpiCard("On Leave", "${summary?.onLeaveToday ?? 0}", Iconsax.note_text, const Color(0xFF7C3AED), const Color(0xFFF5F3FF)),
                  const SizedBox(width: 8),
                  _buildOverviewKpiCard("Absent", "${summary?.absentToday ?? 0}", Iconsax.close_circle, const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
                ],
              ),
              const SizedBox(height: 20),

              // Team Roster Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Live Team Roster", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Text("${roster.length} members", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 10),

              if (roster.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: const Text("No staff members assigned to this branch/department.", style: TextStyle(color: Color(0xFF94A3B8))),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roster.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final member = roster[index];
                    return _buildRosterMemberCard(member);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOverviewKpiCard(String title, String count, IconData icon, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 1),
            Text(title, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.85)), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildRosterMemberCard(ManagerRosterItemModel member) {
    final bool isClockedIn = member.status == 'clocked_in' || (member.clockIn != null && member.clockOut == null);
    final Color badgeColor = isClockedIn
        ? const Color(0xFF059669)
        : member.status == 'on_leave'
            ? const Color(0xFF7C3AED)
            : member.status == 'present'
                ? const Color(0xFF0D9488)
                : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEFF6FF),
            backgroundImage: (member.avatar != null && member.avatar!.startsWith('http'))
                ? NetworkImage(member.avatar!)
                : null,
            child: (member.avatar == null || !member.avatar!.startsWith('http'))
                ? Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB)))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        isClockedIn ? "Clocked In" : member.status.toUpperCase(),
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: badgeColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${member.designation ?? 'Staff'} • ${member.department ?? 'General'}",
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (member.clockIn != null) ...[
                      const Icon(Iconsax.login, size: 12, color: Color(0xFF059669)),
                      const SizedBox(width: 3),
                      Text("In: ${member.clockIn}", style: const TextStyle(fontSize: 10.5, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                    ],
                    if (member.totalHours > 0) ...[
                      const Icon(Iconsax.timer_1, size: 12, color: Color(0xFF2563EB)),
                      const SizedBox(width: 3),
                      Text("${member.totalHours.toStringAsFixed(1)} hrs", style: const TextStyle(fontSize: 10.5, color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCounters() {
    return Obx(() {
      final pagination = controller.pagination.value;
      final total = pagination.total;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Records: $total",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
            if (pagination.lastPage > 1)
              Text(
                "Page ${pagination.currentPage} of ${pagination.lastPage}",
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
          ],
        ),
      );
    });
  }

  // =========================================================================
  // TAB 2: FILTERABLE ATTENDANCE LOG (2.2)
  // =========================================================================
  Widget _buildAttendanceLogTab() {
    return Column(
      children: [
        // SEARCH & FILTER BAR
        _buildFilterBar(),

        // SUMMARY METRIC CHIPS
        _buildSummaryCounters(),

        // ATTENDANCE LIST & PAGINATION
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                ),
              );
            }

            final records = controller.attendances;
            final pagination = controller.pagination.value;

            if (records.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.calendar_remove, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    const Text(
                      "No attendance records found",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tap '+ Manual Entry' to log clock-in/out for a staff member",
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchAttendances(page: controller.currentPage.value),
              color: const Color(0xFF2563EB),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                itemCount: records.length + (pagination.lastPage > 1 ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index < records.length) {
                    final item = records[index];
                    return _buildAttendanceCard(item);
                  }

                  // Pagination Footer
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: pagination.currentPage > 1
                              ? () => controller.fetchAttendances(page: pagination.currentPage - 1)
                              : null,
                        ),
                        Text(
                          "Page ${pagination.currentPage} of ${pagination.lastPage}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: pagination.currentPage < pagination.lastPage
                              ? () => controller.fetchAttendances(page: pagination.currentPage + 1)
                              : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  // =========================================================================
  // FILTER BAR (SEARCH, DATE PICKER & STATUS FILTER)
  // =========================================================================
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          // Search Input
          CustomTextField(
            hintText: "Search employee name, ID or email...",
            prefixIcon: const Icon(Iconsax.search_normal, size: 16, color: Color(0xFF64748B)),
            onChanged: (query) => controller.updateSearch(query),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              // Date Selector using CustomDatePickerField
              Expanded(
                flex: 3,
                child: Obx(() => CustomDatePickerField(
                      selectedDate: controller.selectedDate.value,
                      prefixIcon: const Icon(Iconsax.calendar_1, size: 16, color: Color(0xFF2563EB)),
                      onDateSelected: (picked) => controller.updateDate(picked),
                    )),
              ),

              const SizedBox(width: 10),

              // Status Filter using CustomDropdownField
              Expanded(
                flex: 2,
                child: Obx(() => CustomDropdownField<String>(
                      value: controller.selectedStatus.value,
                      searchable: false,
                      items: const ['all', 'present', 'absent', 'half day'],
                      itemLabelBuilder: (val) {
                        switch (val) {
                          case 'present':
                            return 'Present';
                          case 'absent':
                            return 'Absent';
                          case 'half day':
                            return 'Half Day';
                          case 'all':
                          default:
                            return 'All Status';
                        }
                      },
                      onChanged: (val) {
                        if (val != null) controller.updateStatus(val);
                      },
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ATTENDANCE CARD
  // =========================================================================
  Widget _buildAttendanceCard(ManagerAttendanceModel item) {
    final bool isPresent = item.status.toLowerCase() == 'present';
    final bool isLate = item.isLate;

    final Color statusColor = isLate
        ? const Color(0xFFD97706)
        : isPresent
            ? const Color(0xFF059669)
            : const Color(0xFFDC2626);

    final Color statusBg = isLate
        ? const Color(0xFFFEF3C7)
        : isPresent
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEE2E2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Employee Name, Code & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFEFF6FF),
                    backgroundImage: (item.employeeAvatar != null && item.employeeAvatar!.startsWith('http'))
                        ? NetworkImage(item.employeeAvatar!)
                        : null,
                    child: (item.employeeAvatar == null || !item.employeeAvatar!.startsWith('http'))
                        ? Text(
                            item.employeeName != null && item.employeeName!.isNotEmpty ? item.employeeName![0].toUpperCase() : 'E',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.employeeName ?? 'Staff', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Row(
                        children: [
                          if (item.employeeCode != null && item.employeeCode!.isNotEmpty) ...[
                            Text(item.employeeCode!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                            const Text(" • ", style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 10)),
                          ],
                          Text("${item.designation ?? 'Staff'}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  isLate ? "Late" : item.status.capitalizeFirst ?? 'Present',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Clock In & Clock Out Times
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Clock In", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      item.clockIn ?? '--:--',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                Column(
                  children: [
                    const Text("Clock Out", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      item.clockOut ?? '--:--',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                Column(
                  children: [
                    const Text("Worked", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      "${item.totalHours.toStringAsFixed(2)}h",
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Meta row: Overtime, Break, Location
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (item.overtimeHours > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    "+${item.overtimeHours.toStringAsFixed(2)}h Overtime (\$${item.overtimeAmount.toStringAsFixed(2)})",
                    style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                  ),
                ),
              if (item.breakHours > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    "${item.breakHours.toStringAsFixed(2)}h break",
                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                  ),
                ),
              if (item.checkInLocation != null && item.checkInLocation!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.location, size: 10, color: Color(0xFF2563EB)),
                      const SizedBox(width: 3),
                      Text(
                        item.checkInLocation!,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              if (item.shift != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFFAF5FF), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    item.shift!.name,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF7C3AED), fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),

          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "Note: ${item.notes}",
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
            ),
          ],

          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 4),

          // Action buttons: Edit & Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Iconsax.edit_2, size: 14, color: Color(0xFF2563EB)),
                label: const Text("Edit Record", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                onPressed: () => _showEditAttendanceDialog(context, item),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Iconsax.trash, size: 16, color: Color(0xFF94A3B8)),
                tooltip: "Delete Record",
                onPressed: () => _confirmDeleteAttendance(context, item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MANUAL CLOCK IN/OUT MODAL
  // =========================================================================
  void _showManualAttendanceSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final clockInCtrl = TextEditingController(text: "09:00:00");
    final clockOutCtrl = TextEditingController(text: "18:00:00");
    final notesCtrl = TextEditingController();

    int? selectedEmpId = empController.activeEmployees.isNotEmpty ? empController.activeEmployees.first.id : null;
    String status = "present";
    DateTime date = controller.selectedDate.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Log Manual Attendance", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Employee Dropdown with Radix searchable select
                    Obx(() {
                      final staffList = empController.activeEmployees;
                      return CustomDropdownField<int>(
                        label: "Select Staff Member",
                        value: selectedEmpId,
                        isRequired: true,
                        searchable: true,
                        searchPlaceholder: "Search staff name or ID...",
                        prefixIcon: const Icon(Iconsax.user, size: 18, color: Color(0xFF64748B)),
                        items: staffList.map((e) => e.id).toList(),
                        itemLabelBuilder: (id) => staffList.firstWhere((e) => e.id == id, orElse: () => staffList.first).name,
                        itemSubtitleBuilder: (id) {
                          final match = staffList.firstWhere((e) => e.id == id, orElse: () => staffList.first);
                          return "${match.employeeId} • ${match.designation?.name ?? 'Staff'}";
                        },
                        onChanged: (val) => setSheetState(() => selectedEmpId = val),
                        validator: (v) => v == null ? "Please select staff" : null,
                      );
                    }),
                    const SizedBox(height: 12),

                    // Status Dropdown
                    CustomDropdownField<String>(
                      label: "Attendance Status",
                      value: status,
                      isRequired: true,
                      searchable: false,
                      items: const ['present', 'late', 'absent', 'half_day'],
                      itemLabelBuilder: (val) {
                        switch (val) {
                          case 'late':
                            return 'Late';
                          case 'absent':
                            return 'Absent';
                          case 'half_day':
                            return 'Half Day';
                          case 'present':
                          default:
                            return 'Present';
                        }
                      },
                      onChanged: (val) => setSheetState(() => status = val ?? 'present'),
                    ),
                    const SizedBox(height: 12),

                    // Clock In & Clock Out
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Clock In Time",
                            hintText: "09:00:00",
                            controller: clockInCtrl,
                            prefixIcon: const Icon(Iconsax.clock, size: 16, color: Color(0xFF64748B)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            label: "Clock Out Time",
                            hintText: "18:00:00",
                            controller: clockOutCtrl,
                            prefixIcon: const Icon(Iconsax.clock, size: 16, color: Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      label: "Notes / Late Reason",
                      hintText: "Optional manager note...",
                      controller: notesCtrl,
                      prefixIcon: const Icon(Iconsax.note, size: 18, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    Obx(() => CustomButton(
                          text: "Save Attendance Record",
                          variant: CustomButtonVariant.primary,
                          isLoading: controller.isSubmitting.value,
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final body = {
                                'employee_id': selectedEmpId,
                                'date': DateFormat('yyyy-MM-dd').format(date),
                                'clock_in': clockInCtrl.text.trim(),
                                'clock_out': clockOutCtrl.text.trim(),
                                'status': status,
                                if (notesCtrl.text.isNotEmpty) 'notes': notesCtrl.text.trim(),
                              };

                              final ok = await controller.createAttendance(body);
                              if (ok && ctx.mounted) Navigator.pop(ctx);
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // EDIT ATTENDANCE DIALOG
  // =========================================================================
  void _showEditAttendanceDialog(BuildContext context, ManagerAttendanceModel item) {
    final formKey = GlobalKey<FormState>();
    final clockInCtrl = TextEditingController(text: item.clockIn ?? '');
    final clockOutCtrl = TextEditingController(text: item.clockOut ?? '');
    final notesCtrl = TextEditingController(text: item.notes ?? '');
    final reasonCtrl = TextEditingController(text: item.lateReason ?? '');
    String status = item.status.toLowerCase();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Iconsax.edit, color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Edit (${item.employeeName})",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDropdownField<String>(
                    label: "Status",
                    value: status,
                    searchable: false,
                    items: const ['present', 'late', 'absent', 'half_day'],
                    itemLabelBuilder: (val) {
                      switch (val) {
                        case 'late':
                          return 'Late';
                        case 'absent':
                          return 'Absent';
                        case 'half_day':
                          return 'Half Day';
                        case 'present':
                        default:
                          return 'Present';
                      }
                    },
                    onChanged: (val) => setDialogState(() => status = val ?? 'present'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Clock In (HH:MM:SS)",
                    controller: clockInCtrl,
                    prefixIcon: const Icon(Iconsax.clock, size: 16, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Clock Out (HH:MM:SS)",
                    controller: clockOutCtrl,
                    prefixIcon: const Icon(Iconsax.clock, size: 16, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Late Reason",
                    controller: reasonCtrl,
                    prefixIcon: const Icon(Iconsax.warning_2, size: 16, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Manager Notes",
                    controller: notesCtrl,
                    prefixIcon: const Icon(Iconsax.note, size: 16, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
            ),
            Obx(() => CustomButton(
                  text: "Update Record",
                  fullWidth: false,
                  variant: CustomButtonVariant.primary,
                  isLoading: controller.isSubmitting.value,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final body = {
                        'clock_in': clockInCtrl.text.trim(),
                        'clock_out': clockOutCtrl.text.trim(),
                        'status': status,
                        'late_reason': reasonCtrl.text.trim(),
                        'notes': notesCtrl.text.trim(),
                      };

                      final ok = await controller.updateAttendance(item.id, body);
                      if (ok && ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DELETE ATTENDANCE CONFIRMATION
  // =========================================================================
  void _confirmDeleteAttendance(BuildContext context, ManagerAttendanceModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Attendance Record?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to delete the attendance record for ${item.employeeName} on ${item.date}?",
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
              await controller.deleteAttendance(item.id);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 3: ANALYTICS & PERIOD REPORT (2.3)
  // =========================================================================
  Widget _buildAnalyticsReportTab() {
    return Obx(() {
      if (controller.isLoadingReport.value && controller.reportData.value == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          ),
        );
      }

      final report = controller.reportData.value;
      if (report == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.chart_2, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text("No report generated yet", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => controller.fetchReport(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                child: const Text("Generate Report", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }

      final overview = report.overview;
      final employees = report.employees;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period summary header
            if (report.period != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Period: ${report.period!.startDate} to ${report.period!.endDate}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      "${report.period!.totalDays} Days",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Overview stats grid
            Row(
              children: [
                Expanded(
                  child: _buildReportMetricCard("Total Employees", "${overview.totalEmployees}", const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildReportMetricCard("Attendance Rate", "${overview.overallAttendanceRate.toStringAsFixed(1)}%", const Color(0xFF059669), const Color(0xFFDCFCE7)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildReportMetricCard("Worked Hours", "${overview.totalWorkedHours.toStringAsFixed(0)}h", const Color(0xFF7C3AED), const Color(0xFFEDE9FE)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildReportMetricCard("Overtime Hours", "${overview.totalOvertimeHours.toStringAsFixed(0)}h", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Employee breakdown list
            const Text(
              "Employee Attendance Breakdown",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),

            if (employees.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text("No employee records found in report.", style: TextStyle(color: Color(0xFF64748B))),
                ),
              )
            else
              ...employees.map((emp) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: Text(
                            emp.name.isNotEmpty ? emp.name[0] : "E",
                            style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(emp.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              Text("${emp.department ?? 'General'} • ${emp.presentDays} Present • ${emp.lateCount} Late", style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Text(
                          "${emp.attendanceRate.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: emp.attendanceRate >= 90 ? const Color(0xFF059669) : const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildReportMetricCard(String label, String value, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(Iconsax.chart, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }
}

