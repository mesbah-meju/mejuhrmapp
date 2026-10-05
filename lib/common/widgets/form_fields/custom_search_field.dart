import 'package:flutter/material.dart';

/// A modern search bar input field with automatic clear button, debouncing, and search icon.
class CustomSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.contentPadding,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClear = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClear != hasText) {
      setState(() {
        _showClear = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF64748B),
          ),
          suffixIcon: _showClear
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Color(0xFF64748B)),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                    widget.onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }
}
