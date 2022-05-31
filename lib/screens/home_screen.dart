import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:login_mysql/helpers/size_helper.dart';
import 'package:login_mysql/helpers/space_helper.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/degiskenler.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  final double? longi;
  final String? email;
  final String? password;
  final double? lati;
  const HomePage({Key? key, this.lati, this.longi, this.email, this.password})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(
      lati: lati, longi: longi, password: password, email: email);
}

class _HomePageState extends State<HomePage> {
  final Set<Polygon> _polygons = HashSet<Polygon>();
  Position? position;
  @override
  void initState() {
    debugPrint("Name :  " + email!);
    generateUser();
    _btnController1.stateStream.listen((value) {
      debugPrint(value.toString());
    });
    super.initState();
  }

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Fluttertoast.showToast(
      msg: 'Succesfull Signout',
      backgroundColor: Colors.amber[100],
      textColor: Colors.orange,
      fontSize: 16,
    );
    Timer(const Duration(seconds: 2), () {
      ayarsil();
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return const MyApp();
      }));
    });
  }

  GoogleMapController? mapController;
  double? radius;
  List<Marker> myMarker = [];
  List<User>? userslist;
  List<LatLng> polygonLatLng = [];
  bool isPolygon = true;
  bool markerTapped = false;

  double? longi;
  String? email;
  String? password;
  double? lati;
  _HomePageState({this.longi, this.lati, this.email, this.password});

  _handleTap(LatLng argument) {
    debugPrint(argument.toString());
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            onTap: () {
              setState(() {
                if (markerTapped == false) {
                  markerTapped = true;
                } else {
                  markerTapped = false;
                }
              });
            },
            markerId: MarkerId(argument.toString()),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            position: argument,
            draggable: true,
            onDragEnd: (dragEndPosition) {
              debugPrint(dragEndPosition.toString());
            }),
      );
      if (isPolygon) {
        setState(() {
          polygonLatLng.add(argument);
          // setPolygon();
        });
      }
    });
  }

  ayarsil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', "");
    prefs.setString('password', "");
    Degiskenler.email = email;
    Degiskenler.password = password;
  }

  Future<dynamic> generateUser() async {
    var url = "http://192.168.1.105/login/users.php";
    final response = await http.post(Uri.parse(url), body: {
      "email": email!,
    });
    var list = json.decode(response.body.toString());
    List<User> users =
        await list.map<User>((json) => User.fromJson(json)).toList();
    debugPrint("users : " + users.length.toString());

    setState(() {
      userslist = users;
    });

    return userslist;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              /// Item card
              Align(
                alignment: Alignment.center,
                child: SizedBox.fromSize(
                    size: const Size.fromHeight(172.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        /// Item description inside a material
                        Container(
                          margin: const EdgeInsets.only(top: 24.0),
                          child: Material(
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(12.0),
                            shadowColor: const Color(0x802196F3),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// Title and rating
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(userslist![0].name!,
                                            style: const TextStyle(
                                                color: Colors.blueAccent)),
                                        verticalSpace(context, 0.01),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: const Color(0xffFF9A23),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                                userslist![0].accessrole!,
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(lati.toString() + " - ",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20.0)),
                                        Text(longi.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20.0)),
                                        const Icon(Icons.location_on_rounded,
                                            color: Colors.black, size: 30.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Item image
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(54.0),
                              child: Material(
                                elevation: 20.0,
                                shadowColor: const Color(0x802196F3),
                                shape: const CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: Text(
                                    userslist![0]
                                        .name!
                                        .substring(0, 1)
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.indigo, fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: getDynamicHeighth(context, 0.3)),
                child: Align(
                  alignment: Alignment.center,
                  child: Material(
                    elevation: 12.0,
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffFF9A23), Colors.pinkAccent],
                              end: Alignment.topLeft,
                              begin: Alignment.bottomRight)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              userslist![0].name!.substring(0, 1).toString(),
                              style: const TextStyle(color: Colors.indigo),
                            ),
                          ),
                          title: Text(userslist![0].name!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(userslist![0].location!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle()),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: getDynamicHeighth(context, 0.1),
                ),
                child: Align(
                  child: RoundedLoadingButton(
                    elevation: 10,
                    successIcon: Icons.done_rounded,
                    failedIcon: Icons.sms_failed_outlined,
                    color: const Color(0xffFF9A23),
                    successColor: Colors.greenAccent,
                    child: const Text('SIGN-OUT',
                        style: TextStyle(color: Colors.white)),
                    controller: _btnController1,
                    onPressed: () => _doSomething(_btnController1),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
