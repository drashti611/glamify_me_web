import 'package:flutter/material.dart';

class Custom_widget {
  static ResponsiveContainer(
      {required BuildContext context,
      required double totalwidth,
      required double width,
      double? height,
      Widget? child,
      bool? visible,
      Color? color,
      BoxDecoration? decoration,
      double? radious}) {
    return Visibility(
      visible: visible ?? true,
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 1,
        width: totalwidth < 576
            ? width
            : totalwidth >= 576 && totalwidth < 768
                ? width + 25
                : totalwidth >= 768 && totalwidth < 992
                    ? width + 50
                    : totalwidth >= 992 && totalwidth < 1200
                        ? width + 75
                        : totalwidth >= 1200 && totalwidth < 1400
                            ? width + 100
                            : width + 125,
        child: child ?? null,
        decoration: BoxDecoration(
          color: color ?? null,
          borderRadius: BorderRadius.circular(radious ?? 0),
        ),
      ),
    );
  }
}
