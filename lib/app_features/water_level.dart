import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WaterLevelPage(),
    );
  }
}

class WaterLevelPage extends StatefulWidget {
  @override
  _WaterLevelPageState createState() => _WaterLevelPageState();
}

class _WaterLevelPageState extends State<WaterLevelPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? _latestNode;
  bool isPumpOn = false;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    _listenToDatabase();
  }

  void triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Water Level Alert',
        body: 'The water level is zero. Please check the tank.',
      ),
    );
  }

  void _listenToDatabase() {
    _databaseReference.limitToLast(1).onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      print('Data received: $data');
      if (data != null) {
        setState(() {
          _latestNode = data.map((key, value) => MapEntry(key.toString(), value));

          // Fetching the "Pump" value from the "Control" node
          isPumpOn = _latestNode?['Control']['Pump'] ?? false;
        });

        if (_latestNode?['WaterLevel'] == 0) {
          triggerNotification();
        }
      }
    }, onError: (error) {
      print('Error occurred while listening to the database: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    double waterLevel = (_latestNode?['WaterLevel'] ?? 0).toDouble() / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Water Level',
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
            SizedBox(height: 10),
            Image.asset('assets/images/water.PNG'),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                triggerNotification();
              },
              child: Text(
                'EyeOnWater',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Water level Monitoring',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: waterLevel,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(_latestNode?['WaterLevel'] ?? 'N/A')}%',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tank Filled',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              progressColor: Colors.blue,
            ),
            SizedBox(height: 30),
            Container(
              width: 342,
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pump Status:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isPumpOn ? 'ON' : 'OFF',
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
