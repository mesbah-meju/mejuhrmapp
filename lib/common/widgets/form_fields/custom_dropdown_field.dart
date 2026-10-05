import 'package:flutter/material.dart';

/// Item definition for CustomSelect
class SelectOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool disabled;

  const SelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.trailing,
    this.disabled = false,
  });
}

/// A modern, Radix/shadcn-inspired Searchable Select component in Flutter.
///
/// Features:
/// - Sticky search header with real-time text matching & keyboard dismiss
/// - Left checkmark indicator for the active item
/// - Subtitle and custom item builder support
/// - Empty results state
/// - Modal Sheet & Dialog adaptive presentation
/// - Fully compatible with Form validation
class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final T? value;
  final List<T> items;
  final String Function(T)? itemLabelBuilder;
  final String Function(T)? itemSubtitleBuilder;
  final Widget Function(T)? itemBuilder;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isRequired;
  final bool enabled;
  final bool searchable;
  final String searchPlaceholder;
  final String emptyText;
  final int maxResults;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final bool isClearable;

  final String? sheetTitle;

  const CustomDropdownField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.sheetTitle,
    required this.value,
    required this.items,
    this.itemLabelBuilder,
    this.itemSubtitleBuilder,
    this.itemBuilder,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isRequired = false,
    this.enabled = true,
    this.searchable = true,
    this.searchPlaceholder = "Search...",
    this.emptyText = "No results found",
    this.maxResults = 50,
    this.fillColor,
    this.borderRadius,
    this.isClearable = false,
  });

  String _getLabel(T item) {
    if (itemLabelBuilder != null) return itemLabelBuilder!(item);
    return item.toString();
  }

  String? _getSubtitle(T item) {
    if (itemSubtitleBuilder != null) return itemSubtitleBuilder!(item);
    return null;
  }

  void _openSearchableSelect(BuildContext context, FormFieldState<T> state) {
    if (!enabled) return;

    final effectiveVal = value ?? state.value;

    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SelectSearchBottomSheet<T>(
        title: sheetTitle ?? label ?? hintText ?? "Select Option",
        items: items,
        selectedValue: effectiveVal,
        itemLabelBuilder: _getLabel,
        itemSubtitleBuilder: _getSubtitle,
        itemBuilder: itemBuilder,
        searchable: searchable,
        searchPlaceholder: searchPlaceholder,
        emptyText: emptyText,
        maxResults: maxResults,
        isClearable: isClearable,
      ),
    ).then((selected) {
      if (selected != null || (isClearable && selected == null)) {
        state.didChange(selected);
        onChanged?.call(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRad = borderRadius ?? BorderRadius.circular(12);

    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (state) {
        final hasError = state.hasError;
        final effectiveValue = value ?? state.value;
        final selectedItem = items.cast<T?>().firstWhere(
              (item) => item == effectiveValue,
              orElse: () => null,
            );

        final displayText = selectedItem != null ? _getLabel(selectedItem) : '';
        final displaySubtitle = selectedItem != null ? _getSubtitle(selectedItem) : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            if (label != null) ...[
              Row(
                children: [
                  Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  if (isRequired)
                    const Text(
                      ' *',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            // Trigger Button (radix SelectTrigger style)
            InkWell(
              onTap: enabled ? () => _openSearchableSelect(context, state) : null,
              borderRadius: borderRad,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: fillColor ??
                      (enabled ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9)),
                  borderRadius: borderRad,
                  border: Border.all(
                    color: hasError
                        ? const Color(0xFFEF4444)
                        : (state.value != null
                            ? const Color(0xFF2563EB).withValues(alpha: 0.35)
                            : const Color(0xFFE2E8F0)),
                    width: hasError ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (enabled && !hasError)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: displayText.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (displaySubtitle != null && displaySubtitle.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    displaySubtitle,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            )
                          : Text(
                              hintText ?? "Select an option",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                    ),
                    if (isClearable && state.value != null && enabled)
                      GestureDetector(
                        onTap: () {
                          state.didChange(null);
                          onChanged?.call(null);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.close, size: 16, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ),

            // Error or Helper Text
            if (hasError) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
                ),
              ),
            ] else if (helperText != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  helperText!,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Radix-styled BottomSheet Popover containing search and option list
class _SelectSearchBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selectedValue;
  final String Function(T) itemLabelBuilder;
  final String? Function(T)? itemSubtitleBuilder;
  final Widget Function(T)? itemBuilder;
  final bool searchable;
  final String searchPlaceholder;
  final String emptyText;
  final int maxResults;
  final bool isClearable;

  const _SelectSearchBottomSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.itemLabelBuilder,
    this.itemSubtitleBuilder,
    this.itemBuilder,
    required this.searchable,
    required this.searchPlaceholder,
    required this.emptyText,
    required this.maxResults,
    required this.isClearable,
  });

  @override
  State<_SelectSearchBottomSheet<T>> createState() => _SelectSearchBottomSheetState<T>();
}

class _SelectSearchBottomSheetState<T> extends State<_SelectSearchBottomSheet<T>> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<T> get _filteredItems {
    if (_query.trim().isEmpty) {
      return widget.items;
    }
    final q = _query.trim().toLowerCase();
    return widget.items.where((item) {
      final label = widget.itemLabelBuilder(item).toLowerCase();
      final subtitle = widget.itemSubtitleBuilder?.call(item)?.toLowerCase() ?? '';
      return label.contains(q) || subtitle.contains(q);
    }).take(widget.maxResults).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Title & Dismiss
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 12, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Sticky Search Input (Radix / shadcn style)
            if (widget.searchable) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12, right: 8),
                        child: Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          autofocus: false,
                          onChanged: (val) => setState(() => _query = val),
                          style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                          decoration: InputDecoration(
                            hintText: widget.searchPlaceholder,
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: false,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 16, color: Color(0xFF64748B)),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          splashRadius: 16,
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
            ],

            // Options List (Viewport)
            Flexible(
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded, size: 36, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            widget.emptyText,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, indent: 44, endIndent: 16),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final isSelected = item == widget.selectedValue;
                        final label = widget.itemLabelBuilder(item);
                        final subtitle = widget.itemSubtitleBuilder?.call(item);

                        return Material(
                          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context, item),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  // Radix ItemIndicator checkmark on left
                                  Container(
                                    width: 22,
                                    height: 22,
                                    alignment: Alignment.center,
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 18,
                                            color: Color(0xFF2563EB),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 10),

                                  // Label & Subtitle
                                  Expanded(
                                    child: widget.itemBuilder != null
                                        ? widget.itemBuilder!(item)
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                label,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                  color: isSelected
                                                      ? const Color(0xFF1E40AF)
                                                      : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              if (subtitle != null && subtitle.isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  subtitle,
                                                  style: const TextStyle(
                                                    fontSize: 11.5,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
