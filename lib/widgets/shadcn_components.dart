import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:elxau/theme.dart';

/// Composants d'inspiration Shadcn UI / Airbnb 2026 adaptés à LushiStay
class ShadcnCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const ShadcnCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? LushiStayTheme.bgCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? LushiStayTheme.cardBorder,
          width: 1,
        ),
        boxShadow: LushiStayTheme.cardShadow,
      ),
      child: child,
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      splashColor: LushiStayTheme.copper.withValues(alpha: 0.1),
      highlightColor: LushiStayTheme.copper.withValues(alpha: 0.05),
      child: card,
    );
  }
}

enum ShadcnButtonVariant { primary, secondary, outline, ghost }

class ShadcnButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ShadcnButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final double? width;

  const ShadcnButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ShadcnButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.height = 52,
    this.borderRadius = 28,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;

    switch (variant) {
      case ShadcnButtonVariant.primary:
        bg = LushiStayTheme.copper;
        fg = LushiStayTheme.white;
        border = null;
        break;
      case ShadcnButtonVariant.secondary:
        bg = LushiStayTheme.inputBg;
        fg = LushiStayTheme.white;
        border = Border.all(color: LushiStayTheme.inputBorder);
        break;
      case ShadcnButtonVariant.outline:
        bg = Colors.transparent;
        fg = LushiStayTheme.white;
        border = Border.all(color: LushiStayTheme.cardBorder);
        break;
      case ShadcnButtonVariant.ghost:
        bg = Colors.transparent;
        fg = LushiStayTheme.textSecondary;
        border = null;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const Gap(10),
                      ],
                      Text(
                        text,
                        style: GoogleFonts.plusJakartaSans(
                          color: fg,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
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

class ShadcnInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const ShadcnInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: LushiStayTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: LushiStayTheme.inputBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LushiStayTheme.inputBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const Gap(12),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: GoogleFonts.plusJakartaSans(
                    color: LushiStayTheme.white,
                    fontSize: 15,
                  ),
                  cursorColor: LushiStayTheme.copper,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: hint,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: LushiStayTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
        ),
      ],
    );
  }
}

class ShadcnPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? activeColor;

  const ShadcnPill({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? LushiStayTheme.copper;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? effectiveActiveColor : LushiStayTheme.bgCard,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? effectiveActiveColor : LushiStayTheme.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? LushiStayTheme.white : LushiStayTheme.textSecondary,
              ),
              const Gap(6),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? LushiStayTheme.white : LushiStayTheme.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
