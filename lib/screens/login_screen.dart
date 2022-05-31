import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_mysql/helpers/space_helper.dart';
import 'package:login_mysql/models/degiskenler.dart' as variables;
import 'package:login_mysql/screens/register_screen.dart';
import 'package:login_mysql/services/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/size_helper.dart';
import '../widgets/long_text_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final double? longi;
  final double? lati;
  const LoginScreen({Key? key, this.lati, this.longi}) : super(key: key);

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(lati: lati, longi: longi);
}

class _LoginScreenState extends State<LoginScreen> {
  double? longi;
  double? lati;
  _LoginScreenState({this.longi, this.lati});

  final LocalAuthentication auth = LocalAuthentication();
  String? _authorized;
  bool? _isAuthenticating = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ayaroku();
  }

  String email = "";
  String password = "";

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(const Duration(seconds: 2), () {
      controller.success();
    });
    ayarkaydet();
    login(txtEmail.text.toString(), txtPassword.text.toString(), context, lati,
        longi);
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
                  Icons.fingerprint,
                  color: Color(0xffFF9A23),
                  size: 150,
                ),
              ),
              verticalSpace(context, 0.02),
              const Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Color(0xffFF9A23),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(context, 0.02),
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
                child:
                    const Text('LOGIN', style: TextStyle(color: Colors.white)),
                controller: _btnController1,
                onPressed: () => _doSomething(_btnController1),
              ),
              verticalSpace(context, 0.02),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(longi: longi, lati: lati)));
                },
                child: const Text(
                  "Forgot Password ? ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(context, 0.05),
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
                  const Text("I need an account! "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterScreen(longi: longi, lati: lati)));
                    },
                    child: const Text(
                      "REGISTER",
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

  ayarkaydet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', txtEmail.text);
    prefs.setString('password', txtPassword.text);

    variables.Degiskenler.email = txtEmail.text;
    variables.Degiskenler.password = txtPassword.text;
  }

  ayaroku() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    password = prefs.getString('password')!;

    variables.Degiskenler.email = "";
    variables.Degiskenler.password = "";

    if (prefs.getString('email').toString().isNotEmpty) {
      variables.Degiskenler.email = prefs.getString('email')!;
    } else {
      variables.Degiskenler.email = "";
    }
    if (prefs.getString('password').toString().isNotEmpty) {
      variables.Degiskenler.password = prefs.getString('password')!;
    } else {
      variables.Degiskenler.password = "";
    }

    if (email != "") txtEmail.text = variables.Degiskenler.email!;
    auth.isDeviceSupported().then((bool isSupported) {
      if (variables.Degiskenler.email != "" &&
          variables.Degiskenler.password != "") {
        setState(() {
          _authenticate();
        });
      }
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      if (authenticated == true) {
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return HomePage(
            email: email,
            password: password,
            lati: lati,
            longi: longi,
          );
        }));
      }
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      debugPrint("Authrized :  " + _authorized!);
    });
  }
}
