import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/timeline_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class TimelineScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const TimelineScreen({super.key, this.onBack});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late List<ActivityEvent> _events;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _events = TimelineService.instance.getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Employee Activity Timeline",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh, size: 20, color: Color(0xFF64748B)),
            onPressed: () {
              _loadEvents();
              THelperFunctions.showSnackBar("Timeline updated");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          _buildFilterBar(),

          // Vertical Timeline List
          Expanded(
            child: _events.isEmpty
                ? const Center(
                    child: Text("No activity events recorded yet.", style: TextStyle(color: Color(0xFF94A3B8))),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      final isLast = index == _events.length - 1;
                      return _buildTimelineTile(event, isLast);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['All', 'Attendance', 'Tasks', 'Sales & Targets', 'Approvals'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF2563EB),
                backgroundColor: const Color(0xFFF1F5F9),
                onSelected: (val) {
                  setState(() => _selectedFilter = filter);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimelineTile(ActivityEvent event, bool isLast) {
    final timeStr =
        "${event.eventAt.hour.toString().padLeft(2, '0')}:${event.eventAt.minute.toString().padLeft(2, '0')} ${event.eventAt.hour >= 12 ? 'PM' : 'AM'}";

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  event.isOffline ? 'Offline' : 'Synced',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: event.isOffline ? const Color(0xFFD97706) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Vertical Line & Dot
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: event.color, width: 1.5),
                ),
                child: Icon(event.icon, size: 16, color: event.color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Event Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        if (event.status != 'completed')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: event.status == 'approved'
                                  ? const Color(0xFFDCFCE7)
                                  : event.status == 'pending'
                                      ? const Color(0xFFFEF3C7)
                                      : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: event.status == 'approved'
                                    ? const Color(0xFF15803D)
                                    : event.status == 'pending'
                                        ? const Color(0xFFB45309)
                                        : const Color(0xFFB91C1C),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
