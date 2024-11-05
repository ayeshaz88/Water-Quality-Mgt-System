import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  DatabaseReference? _controlReference;
  Map<dynamic, dynamic>? _latestNode;
  bool tap1SwitchValue = false;
  bool tap2SwitchValue = false;
  bool tap3SwitchValue = false;

  @override
  void initState() {
    super.initState();
    _fetchLatestNode();
    _listenToDatabase();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'water_usage_channel',
          channelName: 'Water Usage Notifications',
          channelDescription: 'Notification channel for water usage alerts',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  void _fetchLatestNode() async {
    try {
      // Fetch the latest node
      final event = await _databaseReference.limitToLast(1).once();
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _latestNode = data;
          // Check if the Control node exists and set the reference accordingly
          if (data.containsKey('Control')) {
            _controlReference = _databaseReference.child('Control');
            // Set the switch values based on the data if keys exist
            tap1SwitchValue = data['Control']?['Tap1'] ?? false;
            tap2SwitchValue = data['Control']?['Tap2'] ?? false;
          } else {
            print('Control node does not exist in the latest data.');
          }
        });
        print('Fetched latest node data: $_latestNode');
      } else {
        print('No data found for the latest node.');
      }
    } catch (error) {
      print('Error occurred while fetching the latest node: $error');
    }
  }

  void _listenToDatabase() {
    _databaseReference.limitToLast(1).onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      final key = event.snapshot.key;
      print('Data received: $data'); // Debugging line
      if (data != null && key != null) {
        final mappedData = data.map((key, value) => MapEntry(key.toString(), value));
        setState(() {
          _latestNode = mappedData;
          _controlReference = _databaseReference.child(key).child('Control');
          // Update the switch values based on the database data if keys exist
          tap1SwitchValue = mappedData['Water_Usage']?['Tap1_Flow'] != null ? mappedData['Water_Usage']['Tap1_Flow'] > 0 : false;
          tap2SwitchValue = mappedData['Water_Usage']?['Tap2_Flow'] != null ? mappedData['Water_Usage']['Tap2_Flow'] > 0 : false;

          // Determine which tap is used more
          int tap1Flow = mappedData['Water_Usage']?['Tap1_Flow'] ?? 0;
          int tap2Flow = mappedData['Water_Usage']?['Tap2_Flow'] ?? 0;

          // Check for water leakage
          if (tap1Flow > 3000) {
            _sendNotification('Water leakage detected at Tap 1');
          } else if (tap2Flow > 3000) {
            _sendNotification('Water leakage detected at Tap 2');
          }

          if (tap1Flow > tap2Flow) {
            _sendNotification('Tap 1 is used more');
          } else if (tap2Flow > tap1Flow) {
            _sendNotification('Tap 2 is used more');
          }
        });
        print('Listening to database, node added with key: $key and data: $mappedData');
      }
    }, onError: (error) {
      print('Error occurred while listening to the database: $error');
    });
  }

  void _updateTapValue(String tapKey, bool value) {
    if (_controlReference != null) {
      _controlReference!.update({tapKey: value}).then((_) {
        print('Control node updated successfully');
      }).catchError((error) {
        print('Failed to update Control node: $error');
      });
    } else {
      print('Control reference is null, update not performed.');
    }
  }

  void _sendNotification(String message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'water_usage_channel',
        title: 'Water Usage',
        body: message,
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Water Usage',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF34E5FD), Color(0x0090A891)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10), // Space for the status bar
              _buildWhiteBox(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/water.PNG',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${_latestNode?['Water_Usage']?['Total_Consumption'] ?? 'N/A'} ml/day',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Space between white boxes
              Center( // Center the text
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Check water usage',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Make it bold
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between white boxes
              _buildCustomWhiteBox(
                'assets/images/tap.png',
                'Tap 1',
                tap1SwitchValue,
                    (value) {
                  setState(() {
                    tap1SwitchValue = value;
                  });
                  _updateTapValue('Tap1', value);
                  if (value) {
                    _showAlertDialog(
                      context,
                      'Tap 1 Usage',
                      'Flow: ${_latestNode?['Water_Usage']?['Tap1_Flow'] ?? 'N/A'}\n'
                          'mLs: ${_latestNode?['Water_Usage']?['Tap1_mLs'] ?? 'N/A'}',
                    );
                  }
                },
              ),
              SizedBox(height: 20), // Space between white boxes
              _buildCustomWhiteBox(
                'assets/images/tap.png',
                'Tap 2',
                tap2SwitchValue,
                    (value) {
                  setState(() {
                    tap2SwitchValue = value;
                  });
                  _updateTapValue('Tap2', value);
                  if (value) {
                    _showAlertDialog(
                      context,
                      'Tap 2 Usage',
                      'Flow: ${_latestNode?['Water_Usage']?['Tap2_Flow'] ?? 'N/A'}\n'
                          'mLs: ${_latestNode?['Water_Usage']?['Tap2_mLs'] ?? 'N/A'}',
                    );
                  }
                },
              ),
              SizedBox(height: 20), // Space between white boxes
              _buildCustomWhiteBox(
                'assets/images/tap.png',
                'Tap 3',
                tap3SwitchValue,
                    (value) {
                  setState(() {
                    tap3SwitchValue = value;
                  });
                  // Assuming Tap3 is part of the backend as well
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteBox({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: 333,
      height: 200, // Reduced height for Tap 1, Tap 2, and Tap 3 boxes
      decoration: BoxDecoration(
        color: Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: child,
      ),
    );
  }

  Widget _buildCustomWhiteBox(
      String imagePath,
      String labelText,
      bool switchValue,
      Function(bool) onChanged,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 26),
      height: 100, // Reduced height for Tap 1, Tap 2, and Tap 3 boxes
      decoration: BoxDecoration(
        color: Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  height: 40,
                  width: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  labelText,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Switch(
            value: switchValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
