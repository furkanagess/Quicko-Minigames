import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class BaseDialog extends StatefulWidget {
  final Widget child;
  final bool barrierDismissible;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final EdgeInsets? margin;
  final double? maxWidth;
  final double? maxHeight;

  const BaseDialog({
    super.key,
    required this.child,
    this.barrierDismissible = true,
    this.animationDuration,
    this.animationCurve,
    this.margin,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  State<BaseDialog> createState() => _BaseDialogState();
}

class _BaseDialogState extends State<BaseDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: widget.margin ?? const EdgeInsets.all(24),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: widget.maxWidth ?? 400,
                  maxHeight: widget.maxHeight ?? 600,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 48,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BaseDialogHeader extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final double? iconSize;
  final double? titleSize;
  final double? subtitleSize;

  const BaseDialogHeader({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.iconSize,
    this.titleSize,
    this.subtitleSize,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconColor ?? defaultColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (iconColor ?? defaultColor).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconTheme(
                data: IconThemeData(color: Colors.white, size: iconSize ?? 28),
                child: icon!,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: TextStyle(
              color: titleColor ?? defaultColor,
              fontWeight: FontWeight.bold,
              fontSize: titleSize ?? 20,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                color: (subtitleColor ?? titleColor ?? defaultColor).withValues(
                  alpha: 0.8,
                ),
                fontWeight: FontWeight.w500,
                fontSize: subtitleSize ?? 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class BaseDialogContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  const BaseDialogContent({
    super.key,
    required this.child,
    this.padding,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [Flexible(child: child)],
      ),
    );
  }
}

class BaseDialogActions extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;

  const BaseDialogActions({
    super.key,
    required this.children,
    this.mainAxisAlignment,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}

class BaseDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isPrimary;
  final bool isDestructive;
  final IconData? icon;
  final double? width;
  final double? height;

  const BaseDialogButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isPrimary = false,
    this.isDestructive = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor =
        isDestructive
            ? AppTheme.darkError
            : (isPrimary
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline);

    final buttonColor = backgroundColor ?? defaultColor;
    final textColorFinal =
        textColor ?? (isPrimary || isDestructive ? Colors.white : defaultColor);

    // Check if this is a transparent/outlined button (cancel button)
    final isOutlined = backgroundColor == Theme.of(context).colorScheme.surface;

    return Container(
      width: width ?? 120,
      height: height ?? 48,
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : buttonColor,
        borderRadius: BorderRadius.circular(16),
        border:
            isOutlined
                ? Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                  width: 1.5,
                )
                : null,
        boxShadow:
            isOutlined
                ? null
                : [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor:
              isOutlined
                  ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
          highlightColor:
              isOutlined
                  ? Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColorFinal, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColorFinal,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
