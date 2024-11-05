import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; // Import the awesome_notifications package

class WaterQualityPage extends StatefulWidget {
  @override
  _WaterQualityPageState createState() => _WaterQualityPageState();
}

class _WaterQualityPageState extends State<WaterQualityPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? _latestNode;

  @override
  void initState() {
    super.initState();
    _listenToDatabase();
  }

  void _listenToDatabase() {
    _databaseReference.limitToLast(1).onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      print('Data received: $data');  // Debugging line
      if (data != null) {
        setState(() {
          _latestNode = data.map((key, value) => MapEntry(key.toString(), value));

          // Check TDS value and show notification if exceeds 550 ppm
          if (_latestNode?['TDS_value'] != null && _latestNode?['TDS_value'] > 550) {
            _showNotification();
          }
        });
      }
    }, onError: (error) {
      print('Error occurred while listening to the database: $error');
    });
  }

  // Method to show the notification
  void _showNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Water Quality Alert',
        body: 'The TDS value of the water exceeds 550 ppm. The water may not be drinkable.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Water Quality',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF34E5FD), Color(0x0090A891)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/images/water.PNG',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),
            Text(
              'EyeOnWater',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Water Quality Parameters',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 342,
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(30),
              decoration: ShapeDecoration(
                color: Color(0xFFFFF5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Temperature:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_latestNode?['Temperature'] ?? 'N/A'}°C',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TDS Value:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_latestNode?['TDS_value'] ?? 'N/A'} ppm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
