import 'package:flutter/material.dart';

import '../helpers/size_helper.dart';

class LongTextField extends StatelessWidget {
  const LongTextField(
      {Key? key,
      required this.controller,
      required this.text,
      required this.keyboardType,
      required this.isObscure,
      required this.keyboardAction,
      required this.width,
      required this.onChanged})
      : super(key: key);
  final TextEditingController? controller;
  final String text;
  final TextInputType keyboardType;
  final bool isObscure;
  final TextInputAction keyboardAction;
  final void Function(String)? onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getDynamicHeighth(context, 0.100),
      width: width,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextFormField(
            onChanged: onChanged,
            textInputAction: keyboardAction,
            obscureText: isObscure,
            keyboardType: keyboardType,
            style: const TextStyle(
                color: Color(0xff858585),
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: 'Montserrat.ttf'),
            controller: controller,
            decoration: InputDecoration(
                hintText: text,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xffFF9A23), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xffFF9A23), width: 4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: getDynamicHeighth(context, 0.01),
                  horizontal: getDynamicWidth(context, 0.03),
                )),
          ),
        ],
      ),
    );
  }
}
