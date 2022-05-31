import 'package:flutter/material.dart';

double getDynamicWidth(BuildContext context,double value) => (MediaQuery.of(context).size.width * value);

double getDynamicHeighth(BuildContext context,double value) => (MediaQuery.of(context).size.height * value);