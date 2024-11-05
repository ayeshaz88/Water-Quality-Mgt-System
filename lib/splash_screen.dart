import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for using Timer

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay using Timer to navigate to the main screen after a certain duration
    Timer(Duration(seconds: 2), () {
      // Replace '/screen' with the route name of your main screen
      Navigator.pushReplacementNamed(context, '/screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF34E5FD), Color(0x0090A891)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/water.PNG',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 10), // Adjusted spacing
              Text(
                'EyeOnWater',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'SeoulHangang',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10), // Adjusted spacing
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
