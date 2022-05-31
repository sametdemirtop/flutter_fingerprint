import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_mysql/screens/register_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  final double? lati;
  final double? longi;
  const OnBoardingScreen({Key? key, this.lati, this.longi}) : super(key: key);

  @override
  _OnBoardingScreenState createState() =>
      _OnBoardingScreenState(lati: lati, longi: longi);
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  int? currentPageCount = 0;

  double? lati;
  double? longi;

  _OnBoardingScreenState({this.lati, this.longi});

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  ///list of strings containing onBoarding titles
  final List<String> _titlesList = [
    'Flutter OnBoarding',
    'MySQL Auth',
    'Current Location',
    'FingerPrint',
  ];

  /// list of strings containing onBoarding subtitles, the small text under the
  /// title
  final List<String> _subtitlesList = [
    'Build your on-boarding flow in seconds.',
    'Use PhpMyAdmin for user managements.',
    'Location to get from user easily.',
    'Get more security with fingerprints',
  ];

  /// list containing image paths or IconData representing the image of each page

  final List<dynamic> _imageList = [
    Icons.developer_mode,
    Icons.layers,
    Icons.map_sharp,
    Icons.fingerprint
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFF9A23),
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) => getPage(_imageList[index],
                _titlesList[index], _subtitlesList[index], context),
            controller: pageController,
            itemCount: _titlesList.length,
            onPageChanged: (int index) {
              setState(() {
                currentPageCount = index;
              });
            },
          ),
          Visibility(
            visible: currentPageCount! + 1 == _titlesList.length,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegisterScreen(longi: longi, lati: lati)));
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: const StadiumBorder()),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: pageController,
                count: _titlesList.length,
                effect: ScrollingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.grey.shade400,
                    dotWidth: 8,
                    dotHeight: 8,
                    fixedCenter: true),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getPage(
      dynamic image, String title, String subTitle, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image is String
            ? Image.asset(
                image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Icon(
                image as IconData,
                color: Colors.white,
                size: 150,
              ),
        const SizedBox(height: 40),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            subTitle,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
