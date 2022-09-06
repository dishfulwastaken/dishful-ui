import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/functions.service.dart';
import 'package:dishful/common/services/ingress.service.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:flutter/material.dart';

class IterationsCard extends StatelessWidget {
  final Iteration _iteration;

  IterationsCard(this._iteration);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            _iteration.id,
            textScaleFactor: 1.25,
          ),
          DishfulIconButton(
            onPressed: () async {
              final r = await FunctionsService.fetchHtml(testUrlA);
              print(r);
            },
            icon: Icon(Icons.cloud_rounded),
          ),
        ],
      ),
    );
  }
}
