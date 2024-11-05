import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import LoginScreen

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF34E5FD), Color(0x0090A891)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Adjusted image size
                Image.asset(
                  'assets/images/water.PNG',
                  width: MediaQuery.of(context).size.width * 0.3, // Adjusted image size
                ),
                SizedBox(height: 20),
                Text(
                  'EyeOnWater',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xD80D0E0E),
                    fontSize: 40,
                    fontFamily: 'SeoulHangang',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Empowering you to monitor, protect, and cherish our most precious resource – water – with a vigilant eye and a touch of technology.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0D0E0E),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register_screen'); // Navigate to RegisterScreen
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3D10BE), // #3D10BE background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 55),
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login_screen'); // Navigate to LoginScreen
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3D10BE), // #3D10BE background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 55),
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
