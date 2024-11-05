import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterqualitymanagemen_system/authentication/register.dart';
import 'email_check.dart'; // Import the EmailCheckScreen

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State {
  TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EmailCheckScreen(),
        ),
      );
      // If no exception is thrown, the password reset email has been sent successfully.
      // Show a snackbar to inform the user that the email has been sent.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email has been sent.'),
        ),
      );
    } catch (error) {
      // Check if the error message indicates that the email is not registered
      if (error is FirebaseAuthException && error.code == 'user-not-found') {
        // If the email is not registered, show a snackbar with a message to inform the user
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
      } else {
        // Handle other errors, such as network issues or invalid email format
        print('Error sending password reset email: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error sending password reset email.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Stack(
          children: [
            Container(
              width: 36, // Adjust width according to your preference
              color: Colors.white, // White background color
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: const Text('Forget Password'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFFFAFDFD), Color(0x0090A891)],
            ),
            borderRadius: BorderRadius.circular(37),
            boxShadow: [
              const BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20,
                child: Image.asset(
                  'assets/images/lock.png',
                  width: 200, // Increased image width
                  height: 200, // Increased image height
                ),
              ),
              const Positioned(
                top: 180,
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Color(0xD80D0E0E),
                    fontSize: 36,
                    fontFamily: 'SeoulHangang',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                top: 240,
                left: 20,
                right: 20,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                    hintText: 'Enter your E-mail here...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email address.";
                    } else if (!RegExp(
                      r'^([a-zA-Z0-9.!#$%&+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)$)',
                    ).hasMatch(value)) {
                      return "Invalid email format.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              Positioned(
                top: 330, // Increased position of the Next button
                child: ElevatedButton(
                  onPressed: () {
                    _sendPasswordResetEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xB5666669), // Button background color
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Increased padding
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20, // Increased font size
                        color: Colors.black, // Button text color
                      ),
                    ),
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
