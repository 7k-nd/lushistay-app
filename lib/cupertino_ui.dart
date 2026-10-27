import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:google_fonts/google_fonts.dart';

Route<T> appRoute<T>(Widget page) {
  return CupertinoPageRoute<T>(builder: (_) => page);
}

Future<void> showAppMessage(
  BuildContext context,
  String message, {
  String title = 'Information',
}) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<bool> showAppConfirm(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmer',
  bool isDestructive = false,
}) async {
  final result = await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          isDefaultAction: !isDestructive,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: builder,
  );
}

Future<DateTime?> pickCupertinoDate(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
}) async {
  DateTime selected = initialDate;
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (context) => Container(
      height: 320,
      color: ElxauTheme.white,
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                CupertinoButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate,
              minimumDate: minimumDate,
              maximumDate: maximumDate,
              onDateTimeChanged: (value) => selected = value,
            ),
          ),
        ],
      ),
    ),
  );
}

class AppRange {
  final double start;
  final double end;
  const AppRange(this.start, this.end);
}

class AppScaffold extends StatelessWidget {
  final Widget body;
  final ObstructingPreferredSizeWidget? navigationBar;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.navigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor ?? ElxauTheme.bg,
      navigationBar: navigationBar,
      child: body,
    );
  }
}

class AppNavBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final Widget? middle;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  const AppNavBar({
    super.key,
    this.middle,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: backgroundColor ?? ElxauTheme.bg,
      border: null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      middle: middle,
      leading: leading,
      trailing: trailing,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}

class AppFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double minSize;

  const AppFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.minSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: padding,
      minimumSize: Size(minSize, minSize),
      color: color ?? ElxauTheme.accent,
      borderRadius: borderRadius,
      disabledColor: (color ?? ElxauTheme.accent).withValues(alpha: 0.4),
      child: DefaultTextStyle.merge(
        style: GoogleFonts.outfit(
          color: ElxauTheme.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
        child: IconTheme(
          data: const IconThemeData(color: ElxauTheme.white),
          child: child,
        ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color borderColor;
  final Color? textColor;

  const AppOutlineButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderColor = ElxauTheme.primary,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        alignment: Alignment.center,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: textColor ?? borderColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          child: child,
        ),
      ),
    );
  }
}

class AppFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String placeholder;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool enabled;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? textColor;
  final Color? placeholderColor;
  final Color? borderColor;

  const AppFormField({
    super.key,
    required this.controller,
    this.label,
    required this.placeholder,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
    this.validator,
    this.fillColor,
    this.textColor,
    this.placeholderColor,
    this.borderColor,
  });

  @override
  State<AppFormField> createState() => AppFormFieldState();
}

class AppFormFieldState extends State<AppFormField> {
  String? _error;

  bool validate() {
    final error = widget.validator?.call(widget.controller.text);
    setState(() => _error = error);
    return error == null;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: widget.textColor ?? ElxauTheme.accent,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        CupertinoTextField(
          controller: widget.controller,
          placeholder: widget.placeholder,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          prefix: widget.prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(widget.prefixIcon, color: ElxauTheme.primary, size: 20),
                ),
          suffix: widget.suffix,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          style: TextStyle(
            color: widget.textColor ?? ElxauTheme.accent,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          placeholderStyle: TextStyle(
            color: widget.placeholderColor ??
                ElxauTheme.secondaryText.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          decoration: BoxDecoration(
            color: widget.fillColor ?? ElxauTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError
                  ? ElxauTheme.destructive
                  : (widget.borderColor ?? ElxauTheme.grayLight),
              width: hasError ? 1.5 : 1,
            ),
          ),
          onChanged: (_) {
            if (_error != null) validate();
          },
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            _error!,
            style: const TextStyle(
              color: ElxauTheme.destructive,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class AppAvatar extends StatelessWidget {
  final double radius;
  final Color? backgroundColor;
  final Widget? child;

  const AppAvatar({
    super.key,
    required this.radius,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor ?? ElxauTheme.bg,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class AppDivider extends StatelessWidget {
  final Color? color;
  final double height;
  final double indent;
  final double endIndent;

  const AppDivider({
    super.key,
    this.color,
    this.height = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(left: indent, right: endIndent),
      color: color ?? ElxauTheme.grayLight,
    );
  }
}

class AppRangeSlider extends StatelessWidget {
  final AppRange values;
  final double min;
  final double max;
  final ValueChanged<AppRange> onChanged;

  const AppRangeSlider({
    super.key,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('Min', style: TextStyle(fontSize: 12, color: ElxauTheme.secondaryText)),
            Expanded(
              child: CupertinoSlider(
                value: values.start.clamp(min, values.end),
                min: min,
                max: max,
                activeColor: ElxauTheme.primary,
                onChanged: (start) {
                  onChanged(AppRange(start.clamp(min, values.end), values.end));
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Max', style: TextStyle(fontSize: 12, color: ElxauTheme.secondaryText)),
            Expanded(
              child: CupertinoSlider(
                value: values.end.clamp(values.start, max),
                min: min,
                max: max,
                activeColor: ElxauTheme.primary,
                onChanged: (end) {
                  onChanged(AppRange(values.start, end.clamp(values.start, max)));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

bool validateFields(List<GlobalKey<AppFormFieldState>> keys) {
  var ok = true;
  for (final key in keys) {
    final valid = key.currentState?.validate() ?? false;
    if (!valid) ok = false;
  }
  return ok;
}
