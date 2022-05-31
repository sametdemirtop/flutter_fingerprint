import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_mysql/screens/home_screen.dart';
import 'package:login_mysql/screens/login_screen.dart';

Future login(String? email, String? password, BuildContext? contextm,
    double? longi, double? lati) async {
  var url = "http://192.168.1.105/login/login.php";
  var response = await http.post(Uri.parse(url), body: {
    "email": email,
    "password": password!,
  });
  var data = json.decode(response.body.toString());

  if (data == "Success") {
    Fluttertoast.showToast(
      msg: 'Login Successful',
      backgroundColor: Colors.amber[100],
      textColor: Colors.orange,
      fontSize: 16,
    );
    return Navigator.push(
      contextm!,
      MaterialPageRoute(
        builder: (contextm) => HomePage(
          longi: longi,
          lati: lati,
          email: email,
          password: password,
        ),
      ),
    );
  } else {
    Fluttertoast.showToast(
      msg: 'E-mail and Password Invalid',
      backgroundColor: Colors.amber[100],
      textColor: Colors.orange,
      fontSize: 16,
    );
  }
}

Future register(
  String? name,
  String? email,
  String? password,
  String? accessrole,
  String? location,
  BuildContext? contextreg,
  double? longi,
  double? lati,
) async {
  var url = "http://192.168.1.105/login/register.php";
  var response = await http.post(Uri.parse(url), body: {
    "name": name!,
    "email": email!,
    "password": password!,
    "accessrole": accessrole!,
    "location": location!,
  });
  var data = json.decode(response.body.toString());
  debugPrint("Response Body : " + response.body.toString());
  debugPrint("Data Body : " + data.toString());
  if (data == "Error") {
    Fluttertoast.showToast(
      msg: 'User Already Exist!',
      backgroundColor: Colors.amber[100],
      textColor: Colors.orange,
      fontSize: 16,
    );
  } else {
    Fluttertoast.showToast(
      msg: 'Registration Successful',
      backgroundColor: Colors.amber[100],
      textColor: Colors.orange,
      fontSize: 16,
    );
    return Navigator.push(
      contextreg!,
      MaterialPageRoute(
        builder: (contextreg) => LoginScreen(longi: longi, lati: lati),
      ),
    );
  }
}
