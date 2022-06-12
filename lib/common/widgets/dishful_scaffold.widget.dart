import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/widgets/dishful_drawer.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishfulScaffold extends ConsumerWidget {
  final String? title;
  final AsyncValueListenable<String?>? titleProvider;
  final String? subtitle;
  final AsyncValueListenable<String?>? subtitleProvider;
  final bool withDrawer;
  final Widget Function(bool) body;
  final Widget Function(BuildContext)? leading;
  final Widget Function(BuildContext, void Function(bool))? action;
  final FutureOr<void> Function()? onSave;
  final FutureOr<void> Function()? onCancel;

  final isEditingProvider = StateProvider((_) => false);

  DishfulScaffold({
    Key? key,
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
  })  : assert(title != null || titleProvider != null),
        super(key: key);

  Widget buildTitle(BuildContext context) => title != null
      ? Text(title!, style: context.titleLarge)
      : Consumer(builder: ((_, ref, __) {
          final titleValue = ref.watch(titleProvider!);

          return titleValue.toWidget(
            data: (newTitle) => Text(newTitle ?? '', style: context.titleLarge),
          );
        }));

  Widget? buildSubtitle(BuildContext context) {
    if (subtitle != null)
      return Text(
        subtitle!,
        style: context.bodyMedium!.copyWith(color: Palette.grey),
      );
    if (subtitleProvider != null)
      return Consumer(builder: ((_, ref, __) {
        final subtitleValue = ref.watch(subtitleProvider!);

        return subtitleValue.toWidget(
          data: (newSubtitle) => Text(
            newSubtitle ?? '',
            style: context.bodyMedium!.copyWith(color: Palette.grey),
          ),
        );
      }));

    return null;
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider);
    final setIsEditing = (bool to) => ref.set(isEditingProvider, to);

    final saveButton = DishfulIconButton(
      onPressed: () {
        if (onSave != null) onSave!();
        setIsEditing(false);
      },
      icon: Icon(Icons.save),
    );
    final cancelButton = DishfulIconButton(
      onPressed: () async {
        if (onCancel != null) onCancel!();
        setIsEditing(false);
      },
      icon: Icon(Icons.close),
    );

    final _title = buildTitle(context);
    final _subtitle = buildSubtitle(context);

    return Scaffold(
      drawer: withDrawer ? DishfulDrawer() : null,
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isEditing)
                    cancelButton
                  else if (leading != null)
                    leading!(context),
                  if (isEditing)
                    saveButton
                  else if (action != null)
                    action!(context, setIsEditing)
                ],
              ),
              Container(height: 20),
              _title,
              if (_subtitle != null) ...[Container(height: 10), _subtitle],
              Container(height: 16),
              Expanded(child: body(isEditing)),
            ],
          ),
        ),
      ),
    );
  }
}
