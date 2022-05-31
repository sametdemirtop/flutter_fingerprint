import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:login_mysql/helpers/space_helper.dart';
import 'package:login_mysql/services/Services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../helpers/size_helper.dart';
import '../widgets/long_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final double? longi;
  final double? lati;

  const RegisterScreen({Key? key, this.lati, this.longi}) : super(key: key);

  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState(lati: lati, longi: longi);
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    debugPrint("lati : " + widget.lati.toString());
    debugPrint("longti : " + widget.longi.toString());
    getAddressFromLatLong(widget.lati!, widget.longi!);
    _btnController1.stateStream.listen((value) {
      debugPrint(value.toString());
    });
    super.initState();
  }

  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  double? lati;
  final ScrollController _controller = ScrollController();
  Placemark? place;
  String? address;
  double? longi;

  _RegisterScreenState({this.lati, this.longi});

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(const Duration(seconds: 2), () {
      controller.success();
      register(txtFullName.text, txtEmail.text, txtPassword.text, "Member",
          address, context, lati, longi);
    });
  }

  Future<void> getAddressFromLatLong(double lati, double longti) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lati, longti);
    place = placemarks[0];
    setState(() {
      address = '${place!.street}' +
          " " +
          'Mah.' +
          ' ${place!.thoroughfare}' +
          ' ' +
          'No:' +
          '${place!.name}' +
          ' ${place!.subAdministrativeArea}'
              '/' +
          ' ${place!.administrativeArea}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.developer_mode,
                  color: Color(0xffFF9A23),
                  size: 150,
                ),
              ),
              verticalSpace(context, 0.03),
              const Center(
                child: Text(
                  'Create new Account',
                  style: TextStyle(
                      color: Color(0xffFF9A23),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(context, 0.02),
              Center(
                child: LongTextField(
                  controller: txtFullName,
                  text: "Name",
                  keyboardType: TextInputType.emailAddress,
                  isObscure: false,
                  keyboardAction: TextInputAction.next,
                  onChanged: (text) {},
                  width: getDynamicWidth(context, 0.8),
                ),
              ),
              Center(
                child: LongTextField(
                  controller: txtEmail,
                  text: "E-mail",
                  keyboardType: TextInputType.emailAddress,
                  isObscure: false,
                  keyboardAction: TextInputAction.next,
                  onChanged: (text) {},
                  width: getDynamicWidth(context, 0.8),
                ),
              ),
              Center(
                child: LongTextField(
                  controller: txtPassword,
                  text: "Password",
                  keyboardType: TextInputType.emailAddress,
                  isObscure: true,
                  keyboardAction: TextInputAction.next,
                  onChanged: (text) {},
                  width: getDynamicWidth(context, 0.8),
                ),
              ),
              verticalSpace(context, 0.05),
              RoundedLoadingButton(
                elevation: 10,
                successIcon: Icons.done_rounded,
                failedIcon: Icons.sms_failed_outlined,
                color: const Color(0xffFF9A23),
                successColor: Colors.greenAccent,
                child: const Text('REGISTER',
                    style: TextStyle(color: Colors.white)),
                controller: _btnController1,
                onPressed: () => _doSomething(_btnController1),
              ),
              verticalSpace(context, 0.03),
              const Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(context, 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("I have already an account! "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen(longi: longi, lati: lati)));
                    },
                    child: const Text(
                      "LOGIN ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
