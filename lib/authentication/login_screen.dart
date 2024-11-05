import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waterqualitymanagemen_system/authentication/FadeInAmination.dart';
import '../app_menu.dart'; // Import the menu page
import 'register.dart';
import 'forget_pass.dart'; // Import the forget password screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    try {
      // Sign in the user with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Navigate to the home screen after successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AppMenuPage()),
      );
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          // If the email is not registered, show a snackbar to inform the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Email is not registered. Please sign up to create an account.'),
              action: SnackBarAction(
                label: 'Sign Up',
                onPressed: () {
                  // Navigate to the sign up page if the user chooses to sign up
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ));
                },
              ),
            ),
          );
        } else if (error.code == 'wrong-password') {
          // If the password is incorrect, show a toast message to inform the user
          Fluttertoast.showToast(
            msg: "Incorrect email or password. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // Show a generic error snackbar for any other exceptions
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message ?? 'An error occurred. Please try again later.'),
            ),
          );
        }
      }
    }
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      return false; // Always return false to prevent app from closing
    },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
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
            const SizedBox(height: 20),
            const Center(
              child: SizedBox(
                width: 229,
                height: 32.10,
                child: Text(
                  'Login into your account',
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
            const SizedBox(height: 20),
                  FadeInAnimation(
                    delay: 1.8,
                    child: TextFormField(
                      controller: _emailController,
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

                const SizedBox(height: 20),
                FadeInAnimation(
                  delay: 0.6,
                  child: TextFormField(
                    obscureText: !_passwordVisible,
                    controller: _passwordController,
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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to the forget password screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: 150,
                  height: 43,
                  decoration: BoxDecoration(
                    color: const Color(0xEF3D10BE),
                    borderRadius: BorderRadius.circular(55),
                    border: Border.all(
                      width: 0.40,
                      color: const Color(0xFFF0D1B5),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the menu page
                      login();
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to the register screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
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
