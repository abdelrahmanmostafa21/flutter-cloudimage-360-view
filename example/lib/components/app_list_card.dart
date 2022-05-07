import 'package:example/components/app_list_tile.dart';
import 'package:flutter/material.dart';

class AppListCard extends StatelessWidget {
  const AppListCard({
    Key? key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.border,
    this.color,
    this.onTap,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.multilineTitle = false,
    this.multilineSubtitle = true,
  }) : super(key: key);

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  final Border? border;
  final Color? color;
  final VoidCallback? onTap;

  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;
  final bool multilineTitle;
  final bool multilineSubtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: border,
        color: color ?? Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: AppListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        borderRadius: BorderRadius.circular(8),
        color: color,
        onTap: onTap,
        contentPadding: contentPadding,
        leadingPadding: leadingPadding,
        trailingPadding: trailingPadding,
        multilineTitle: multilineTitle,
        multilineSubtitle: multilineSubtitle,
      ),
    );
  }
}
