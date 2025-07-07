import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LinearProgress extends StatelessWidget {
  const LinearProgress({Key? key, this.width, this.color}) : super(key: key);

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(width ?? 200, 3)),
            child: LinearProgressIndicator(
                color: color ?? context.theme.primaryColor)));
  }
}
