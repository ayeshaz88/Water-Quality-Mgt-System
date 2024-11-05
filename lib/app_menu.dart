import 'package:flutter/material.dart';
import 'package:waterqualitymanagemen_system/app_features/Controll.dart';
import 'package:waterqualitymanagemen_system/app_features/water_level.dart';
import 'package:waterqualitymanagemen_system/app_features/water_quality.dart';
import 'package:waterqualitymanagemen_system/app_features/water_usage.dart';
import 'package:waterqualitymanagemen_system/authentication/FadeInAmination.dart';

import '../app_features/about.dart';
import '../app_features/logout.dart';
import '../app_features/monthlyhistory.dart';
import '../app_features/weeklyhistory.dart';
import 'app_features/DailyHistoryPage.dart';
// Import WaterLevelPage

class AppMenuPage extends StatefulWidget {
  @override
  _AppMenuPageState createState() => _AppMenuPageState();
}

class _AppMenuPageState extends State<AppMenuPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 300.0; // Set your desired button width
    return WillPopScope(
      onWillPop: () async {
        return false; // Always return false to prevent app from closing
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: FadeInAnimation(
                    delay: 1.4,
                    child: Text(
                      'EyeOnWater',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              _buildDrawerItem(
                Icons.home,
                'About',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.access_time,
                'Daily History',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DailyHistoryPage()),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.view_week,
                'Weekly History',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeeklyHistoryPage()),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.calendar_month,
                'Monthly History',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonthlyHistoryPage()),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.logout,
                'Logout',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogoutPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF34E5FD), Color(0x0090A891)],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'EyeOnWater',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'SeoulHangang',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ControlPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF3A98B9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: SizedBox(
                          width: buttonWidth,
                          height: 125,
                          child: Row(
                            children: [
                              const Text(
                                "Water Usage",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 20),

                              ),
                              const Spacer(),
                              SizedBox(
                                width: 125,
                                height: 125,
                                child: Image.asset(
                                  'assets/images/WaterUsage.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WaterLevelPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFADC4CE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: SizedBox(
                          width: buttonWidth,
                          height: 125,
                          child: Row(
                            children: [
                              const Text(
                                "Water Level",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 125,
                                height: 125,
                                child: Image.asset(
                                  'assets/images/WaterQuality.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WaterQualityPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF183D3D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: SizedBox(
                          width: buttonWidth,
                          height: 125,
                          child: Row(
                            children: [
                              const Text(
                                "Water Quality",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 125,
                                height: 125,
                                child: Image.asset(
                                  'assets/images/WaterLevel.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDrawerItem(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
