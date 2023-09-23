import 'package:flutter/material.dart';
import 'package:slip_readerv2/pages/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SplashScreen(
          seconds: 1,
          photoSize: 25,
          backgroundColor: Colors.white,
          navigateAfterSeconds: new HomePage(),
          loaderColor: Colors.blueGrey,
          loadingText: Text(
            'Please Wait....',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png",
                  width: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.fill),
              SizedBox(height: 20),
              Text(
                'Receipt\nLoud Reader',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45.0,
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        )
      ],
    ));
  }
}
