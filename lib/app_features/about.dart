import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // Removed the fixed height
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF34E5FD), Color(0x0090A891)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                child: Center(
                  child: Text(
                    'About Eye on Water',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Text(
                    '"Eye on Water" is a revolutionary mobile application designed to empower users with remote control over water management systems. Leveraging cutting-edge technology, this app serves as a comprehensive platform for monitoring and controlling water usage from anywhere, anytime. With its intuitive interface and real-time data visualization capabilities, users can gain insights into their water consumption patterns, detect leaks, and optimize usage efficiently.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                child: Center(
                  child: Text(
                    'Privacy and Security',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Text(
                    '"We understand the importance of your data privacy and security. Your data is never shared without your explicit consent and we are fully compliant with relevant data protection regulations."',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                child: Center(
                  child: Text(
                    'Join us in the water-saving revolution',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Text(
                    '"We invite you to join our journey in creating a more sustainable future for our planet. Download “Eye On Water” now and become part of growing community dedicated to preserving one of our most precious resource - water. Together, let’s keep a watchful eye on water!"',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
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
