import 'package:example/components/app_list_tile.dart';
import 'package:flutter/material.dart';

class AppSwitchTile extends StatelessWidget {
  const AppSwitchTile({
    required this.value,
    Key? key,
    this.title,
    this.subtitle,
    this.leading,
    this.borderRadius,
    this.onChanged,
    this.enabled = true,
    this.multilineTitle = false,
    this.contentPadding,
  }) : super(key: key);

  final bool value;

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final BorderRadius? borderRadius;

  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final bool multilineTitle;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      contentPadding: contentPadding,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailingPadding: EdgeInsets.zero,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      borderRadius: borderRadius,
      verticalAlignment: CrossAxisAlignment.center,
      enabled: enabled,
      multilineTitle: multilineTitle,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
