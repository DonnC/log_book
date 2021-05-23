// entry of formbuilderfield
import 'package:flutter/material.dart';
import 'package:log_book/utils/index.dart';
import 'package:relative_scale/relative_scale.dart';

Widget textEntryField({
  String title,
  String initialText,
  double fieldHeight: 50,
}) {
  return RelativeBuilder(
    builder: (context, height, width, sy, sx) {
      const double _radius = 5.0;

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: kStyle(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: fieldHeight,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      initialText ?? 'N/A',
                      style: kStyle(),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
