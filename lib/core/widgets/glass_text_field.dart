import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? helperText;
  final bool isSuccess;
  final int maxLines;
  final int? maxLength;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.helperText,
    this.isSuccess = false,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  String? _errorText;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      // Trigger validation on focus loss if validator is set
      if (!_focusNode.hasFocus && widget.validator != null) {
        setState(() {
          _errorText = widget.validator!(widget.controller.text);
        });
      }
    });

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_errorText != null && widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isError = _errorText != null;

    // Border and Glow sizing
    Color borderColor;
    List<BoxShadow> glowShadows = [];

    if (isError) {
      borderColor = AppColors.error;
      if (_isFocused) {
        glowShadows = [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.12),
            blurRadius: 4,
            spreadRadius: 4,
          )
        ];
      }
    } else if (widget.isSuccess) {
      borderColor = AppColors.success;
    } else if (_isFocused) {
      borderColor = AppColors.primaryAccent;
      glowShadows = [
        BoxShadow(
          color: AppColors.primaryAccent.withValues(alpha: 0.12),
          blurRadius: 4,
          spreadRadius: 4,
        )
      ];
    } else {
      borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label float animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isError
                  ? AppColors.error
                  : (_isFocused ? AppColors.primaryAccent : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.maxLines > 1 ? null : 54,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceLevel2 : AppColors.lightSurfaceLevel2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: (_isFocused || isError || widget.isSuccess) ? 2.0 : 1.0,
            ),
            boxShadow: glowShadows,
          ),
          child: Row(
            crossAxisAlignment: widget.maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 12.0, top: 2.0),
                  child: Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: isError
                        ? AppColors.error
                        : (_isFocused ? AppColors.primaryAccent : (isDark ? AppColors.textTertiary : AppColors.lightTextSecondary.withValues(alpha: 0.6))),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: widget.prefixIcon != null ? 0.0 : 16.0),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.isPassword ? _obscureText : false,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    onFieldSubmitted: widget.onSubmitted,
                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.textTertiary : AppColors.lightTextSecondary.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: widget.maxLines > 1 ? 16.0 : 0.0,
                      ),
                      counterText: '',
                    ),
                  ),
                ),
              ),
              if (widget.isPassword)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: isDark ? AppColors.textTertiary : AppColors.lightTextSecondary.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              if (widget.maxLength != null && widget.maxLines > 1)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  child: Text(
                    '${widget.controller.text.length}/${widget.maxLength}',
                    style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                  ),
                ),
            ],
          ),
        ),
        // Bottom helper / error text
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 12, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  _errorText!,
                  style: const TextStyle(fontSize: 11, color: AppColors.error),
                ),
              ],
            ),
          )
        else if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Text(
              widget.helperText!,
              style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
            ),
          ),
      ],
    );
  }
}
