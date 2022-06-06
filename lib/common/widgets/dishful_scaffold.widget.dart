import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/dishful_drawer.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishfulScaffold extends ConsumerWidget {
  final String? title;
  final ProviderListenable<AsyncValue<String?>>? dynamicTitle;
  final String? subtitle;
  final ProviderListenable<AsyncValue<String?>>? dynamicSubtitle;
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
    this.dynamicTitle,
    this.subtitle,
    this.dynamicSubtitle,
    this.withDrawer = false,
    required this.body,
    this.leading,
    this.action,
    this.onSave,
    this.onCancel,
  })  : assert(leading != null),
        assert(title != null || dynamicTitle != null),
        super(key: key);

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

    Text renderTitle(String? text) =>
        Text(text ?? '', style: context.titleLarge);

    final _title = title != null
        ? renderTitle(title)
        : Consumer(builder: ((_, ref, __) {
            final _dynamicTitle = ref.watch(dynamicTitle!);

            return _dynamicTitle.when(
              data: renderTitle,
              loading: () => Container(),
              error: (_, __) => Container(),
            );
          }));

    Text renderSubtitle(String? text) => Text(
          text ?? '',
          style: context.bodyMedium!.copyWith(color: Palette.grey),
        );

    final _subtitle = (() {
      if (subtitle != null) return renderSubtitle(subtitle);
      if (dynamicSubtitle != null)
        return Consumer(builder: ((_, ref, __) {
          final _dynamicSubtitle = ref.watch(dynamicSubtitle!);

          return _dynamicSubtitle.when(
            data: renderSubtitle,
            loading: () => Container(),
            error: (_, __) => Container(),
          );
        }));
    })();

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
