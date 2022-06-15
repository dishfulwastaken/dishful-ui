import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DishfulModalBottomSheet extends StatelessWidget {
  final Widget Function(Future<void> Function()) child;

  /// [DishfulScaffold] props
  final String? title;
  final AsyncValueListenable<String?>? titleProvider;
  final String? subtitle;
  final AsyncValueListenable<String?>? subtitleProvider;
  final bool withDrawer;
  final Widget Function(bool) body;
  final Widget Function(BuildContext, void Function())? leading;
  final Widget Function(BuildContext, void Function(bool))? action;
  final FutureOr<void> Function()? onSave;
  final FutureOr<void> Function()? onCancel;

  const DishfulModalBottomSheet({
    Key? key,
    required this.child,
    this.title,
    this.titleProvider,
    this.subtitle,
    this.subtitleProvider,
    this.withDrawer = false,
    required this.body,
    this.leading,
    this.action,
    this.onSave,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///  todo: set up routing + transitions (see modal docs)
    /// todo: once thats done mabye then we can use context.pop instead
    /// of navigator but idkkk
    final openModalBottomSheet = () => showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: context.height - 22,
              child: DishfulScaffold(
                title: title,
                titleProvider: titleProvider,
                subtitle: subtitle,
                subtitleProvider: subtitleProvider,
                withDrawer: withDrawer,
                leading: leading != null
                    ? (context) =>
                        leading!(context, () => Navigator.pop(context))
                    : null,
                action: action,
                onSave: onSave,
                onCancel: onCancel,
                body: body,
              ),
            );
          },
        );

    return child(openModalBottomSheet);
  }
}
