import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_mysql/models/degiskenler.dart' as variables;
import 'package:login_mysql/screens/login_screen.dart';
import 'package:login_mysql/screens/on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

Position? position;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  position = await _getGeoLocationPosition();
  runApp(const MyApp());
}

Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email = "";
  String password = "";
  bool? isEntered;

  @override
  void initState() {
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isEntered == true
          ? LoginScreen(
              lati: position!.latitude,
              longi: position!.longitude,
            )
          : OnBoardingScreen(
              lati: position!.latitude,
              longi: position!.longitude,
            ),
    );
  }

  read() async {
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
    if (variables.Degiskenler.email != "" &&
        variables.Degiskenler.password != "") {
      setState(() {
        isEntered = true;
      });
    }
  }
}
