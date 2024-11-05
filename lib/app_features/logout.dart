import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterqualitymanagemen_system/authentication/login_screen.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF34E5FD), Color(0x0090A891)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2, // Position image at 20% of screen height
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/water.PNG"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'EyeOnWater',
                      style: TextStyle(
                        color: Colors.black, // Changed to black color
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5, // Position text at 50% of screen height
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Are you sure you want to Logout?',
                  style: TextStyle(
                    color: Colors.black, // Changed to black color
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.3, // Positioned closer to the "Are you sure..." text
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D10BE),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                color: Colors.blue,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 6),
                     const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
