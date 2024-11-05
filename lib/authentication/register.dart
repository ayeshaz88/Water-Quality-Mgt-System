import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waterqualitymanagemen_system/authentication/login_screen.dart';
import '../app_menu.dart';
import 'FadeInAmination.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late String email, password, name;
  bool isLoader = false;

  bool _passwordVisible = false;

  Future registerUser(String email, String pass) async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passController.text.toString());
    return user;
  }

  final formKey = GlobalKey<FormState>();

  Future saveData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'userID': FirebaseAuth.instance.currentUser!.uid,
      'userEmail ': emailController.text.toString(),
      'userName': nameController.text.toString(),
      'isApproved': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF34E5FD), Color(0x0090A891)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/water.PNG',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 229,
                  height: 32.10,
                  child: Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInAnimation(
                delay: 0.6,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                    ),
                    labelText: 'Username',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a username.";
                    } else if (!RegExp(r'^[A-Z][a-z]*$').hasMatch(value)) {
                      return "Username should start with a capital letter and only contain alphabets.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 10),
              FadeInAnimation(
                delay: 0.6,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                    ),
                    labelText: 'Email',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email address.";
                    } else if (!RegExp(
                        r'^([a-zA-Z0-9.!#$%&+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)$)')
                        .hasMatch(value)) {
                      return "Invalid email format.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 10),
              FadeInAnimation(
                delay: 0.6,
                child: TextFormField(
                  obscureText: !_passwordVisible,
                  controller: passController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    labelText: 'Password',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password.";
                    } else if (value.length < 8 &&
                        value.toString() != 'admin') {
                      return "Password must be at least 8 characters long.";
                    } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
                    )
                        .hasMatch(value)) {
                      return "Password must contain uppercase, lowercase, and digits.";
                    }
                    return null;
                  },
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 10),
              FadeInAnimation(
                delay: 0.6,
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    labelText: 'Confirm Password',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password.";
                    } else if (value != passController.text) {
                      return "Passwords do not match.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 20),
              FadeInAnimation(
                delay: 0.6,
                child: ElevatedButton(
                  onPressed: () async {
                    // Get email and password from controllers
                    try {
                      // Create a new user with email and password
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passController.text.toString(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Account created successfully!'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      // If registration is successful, navigate to HomeScreen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AppMenuPage(),
                        ),
                      );
                    } catch (error) {
                      // Handle registration errors
                      if (error is FirebaseAuthException &&
                          error.code == 'email-already-in-use') {
                        Fluttertoast.showToast(
                          msg: "Email is already registered. Please log in.",
                          timeInSecForIosWeb: 3,
                        );

                        // Navigate to the login page
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      } else {
                        // Handle other registration errors
                        Fluttertoast.showToast(
                          msg: "Registration failed. Please try again.",
                          timeInSecForIosWeb: 3,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xEF3D10BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
// Navigate to the login screen
                  Navigator.pushReplacementNamed(context, '/login_screen');
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an Account? ',
                        style: TextStyle(
                          color: Color(0xFF484848),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xFF484848),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}