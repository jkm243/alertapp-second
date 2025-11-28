import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../typography.dart';
import '../spacing.dart';
import '../animations.dart';

/// Champs de saisie avec bordures et focus states
class AppInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final AppInputVariant variant;
  final AppInputSize size;
  final bool isRequired;
  final String? Function(String?)? validator;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.variant = AppInputVariant.default_,
    this.size = AppInputSize.medium,
    this.isRequired = false,
    this.validator,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeOut,
    ));
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle();
    final padding = _getPadding();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          const SizedBox(height: AppSpacing.sm),
        ],
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: _getBorderRadius(),
                border: Border.all(
                  color: _getBorderColor(),
                  width: _getBorderWidth(),
                ),
                boxShadow: _getBoxShadow(),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                obscureText: widget.obscureText,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                onTap: widget.onTap,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: textStyle,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: AppTypography.body.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  contentPadding: padding,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            );
          },
        ),
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildHelperText(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(
          widget.label!,
          style: AppTypography.bodySmall.copyWith(
            color: _isFocused ? AppColors.primary : AppColors.foreground,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (widget.isRequired) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            '*',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.destructive,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHelperText() {
    final hasError = widget.errorText != null;
    return Text(
      hasError ? widget.errorText! : widget.helperText!,
      style: AppTypography.caption.copyWith(
        color: hasError ? AppColors.destructive : AppColors.mutedForeground,
      ),
    );
  }


  TextStyle _getTextStyle() {
    switch (widget.size) {
      case AppInputSize.small:
        return AppTypography.bodySmall;
      case AppInputSize.medium:
        return AppTypography.body;
      case AppInputSize.large:
        return AppTypography.bodyLarge;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case AppInputSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppInputSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppInputSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.size) {
      case AppInputSize.small:
        return AppBorderRadius.smRadius;
      case AppInputSize.medium:
        return AppBorderRadius.mdRadius;
      case AppInputSize.large:
        return AppBorderRadius.lgRadius;
    }
  }

  Color _getBorderColor() {
    if (widget.errorText != null) {
      return AppColors.destructive;
    }
    if (_isFocused) {
      return AppColors.primary;
    }
    return AppColors.border;
  }

  double _getBorderWidth() {
    if (_isFocused || widget.errorText != null) {
      return 2.0;
    }
    return 1.0;
  }

  List<BoxShadow> _getBoxShadow() {
    if (_isFocused) {
      return [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];
    }
    return [];
  }
}

/// Style d'input
class AppInputStyle {
  final Color backgroundColor;
  final Color borderColor;

  const AppInputStyle({
    required this.backgroundColor,
    required this.borderColor,
  });
}

/// Variantes d'input
enum AppInputVariant {
  default_,
  filled,
  outlined,
}

/// Tailles d'input
enum AppInputSize {
  small,
  medium,
  large,
}

/// Champ de recherche
class AppSearchInput extends StatefulWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool enabled;

  const AppSearchInput({
    super.key,
    this.hint,
    this.onChanged,
    this.onClear,
    this.controller,
    this.enabled = true,
  });

  @override
  State<AppSearchInput> createState() => _AppSearchInputState();
}

class _AppSearchInputState extends State<AppSearchInput> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
    widget.onChanged?.call(_controller.text);
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: _controller,
      hint: widget.hint ?? 'Rechercher...',
      enabled: widget.enabled,
      prefixIcon: const Icon(
        Icons.search,
        size: 20,
        color: AppColors.mutedForeground,
      ),
      suffixIcon: _hasText
          ? GestureDetector(
              onTap: _clearText,
              child: const Icon(
                Icons.clear,
                size: 20,
                color: AppColors.mutedForeground,
              ),
            )
          : null,
      onChanged: widget.onChanged,
    );
  }
}

/// Champ de mot de passe
class AppPasswordInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool enabled;
  final bool isRequired;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppPasswordInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.enabled = true,
    this.isRequired = false,
    this.validator,
    this.onChanged,
  });

  @override
  State<AppPasswordInput> createState() => _AppPasswordInputState();
}

class _AppPasswordInputState extends State<AppPasswordInput> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppInput(
      label: widget.label,
      hint: widget.hint,
      helperText: widget.helperText,
      errorText: widget.errorText,
      controller: widget.controller,
      enabled: widget.enabled,
      isRequired: widget.isRequired,
      validator: widget.validator,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      suffixIcon: GestureDetector(
        onTap: _toggleObscureText,
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: 20,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}
