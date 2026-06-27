import 'package:flutter/material.dart';

import 'texts.dart';

Widget buildMemberCard(
    {GestureTapCallback? onTap,
    required Widget image,
    required String textTop,
    required String textBottom,
    String? datetime}) {
  return Card(
    elevation: 8,
    margin: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
    child: InkWell(
      onTap: onTap,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              image,
              Flexible(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildNormalText(textTop, maxLines: 1),
                        buildNormalText(datetime ?? '', maxLines: 1),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    buildSmallerText(textBottom, maxLines: 1)
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    ),
  );
}
