import 'package:flutter/material.dart';

Widget verticalSpace(BuildContext context,double height) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * height,
  );
}
Widget horizontalSpace(BuildContext context,double width) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * width,
  );
}