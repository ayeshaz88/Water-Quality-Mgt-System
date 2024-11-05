import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeeklyHistoryPage extends StatefulWidget {
  @override
  _WeeklyHistoryPageState createState() => _WeeklyHistoryPageState();
}

class _WeeklyHistoryPageState extends State<WeeklyHistoryPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, List<Map<String, dynamic>>> _dataList = {};
  double _totalConsumption = 0.0;

  @override
  void initState() {
    super.initState();
    _listenToDatabase();
  }

  void _listenToDatabase() {
    _databaseReference.onChildAdded.listen((event) {
      final newData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final dateTimeString = event.snapshot.key;
      if (newData.containsKey('Water_Usage') && dateTimeString != null) {
        final waterUsage = Map<String, dynamic>.from(newData['Water_Usage']);
        final dateTime = DateTime.parse(dateTimeString);

        final date = DateFormat('yyyy-MM-dd').format(dateTime);
        if (!_dataList.containsKey(date)) {
          _dataList[date] = [];
        }

        _dataList[date]?.add({
          'time': dateTime,
          'Water_Usage': waterUsage,
        });

        // Update total consumption
        double totalForEntry = (double.tryParse(waterUsage['Tap1_Flow'].toString()) ?? 0) +
            (double.tryParse(waterUsage['Tap2_Flow'].toString()) ?? 0);
        _totalConsumption += totalForEntry;

        setState(() {});
      }
    });
  }

  List<FlSpot> _getWeeklyWaterConsumptionData(String tap) {
    List<FlSpot> spots = [];
    Map<int, double> dailyConsumption = {};

    for (var date in _dataList.keys) {
      int dayIndex = DateTime.parse(date).weekday - 1;
      final dayData = _dataList[date]!;

      double dayTotal = 0;
      for (var entry in dayData) {
        final waterUsage = entry['Water_Usage'];
        dayTotal += (double.tryParse(waterUsage[tap].toString()) ?? 0);
      }

      dailyConsumption[dayIndex] = (dailyConsumption[dayIndex] ?? 0) + dayTotal;
    }

    for (int i = 0; i < 7; i++) {
      spots.add(FlSpot(i.toDouble(), dailyConsumption[i] ?? 0));
    }

    return spots;
  }

  void _showDataAlert(BuildContext context, int day, double tap1Consumption, double tap2Consumption) {
    final weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Water Consumption Data"),
          content: Text(
              "Day: ${weekDays[day]}\n"
                  "Tap1 Consumption: ${tap1Consumption.toStringAsFixed(2)} mL\n"
                  "Tap2 Consumption: ${tap2Consumption.toStringAsFixed(2)} mL"
          ),
          actions: [
            TextButton(
              child: Text("OK"),
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
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      String startDateString = DateFormat('yyyy-MM-dd').format(startOfWeek);
      String endDateString = DateFormat('yyyy-MM-dd').format(endOfWeek);

      // Determine the earliest and latest dates present in the fetched data
      String? earliestDate;
      String? latestDate;
      if (_dataList.isNotEmpty) {
        earliestDate = _dataList.keys.reduce((a, b) => a.compareTo(b) < 0 ? a : b);
        latestDate = _dataList.keys.reduce((a, b) => a.compareTo(b) > 0 ? a : b);
      }

      // If earliest and latest dates are available, use them for displaying the week
      if (earliestDate != null && latestDate != null) {
        startOfWeek = DateTime.parse(earliestDate);
        endOfWeek = DateTime.parse(latestDate);
        startDateString = DateFormat('yyyy-MM-dd').format(startOfWeek);
        endDateString = DateFormat('yyyy-MM-dd').format(endOfWeek);
      }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF34E5FD), Color(0x0090A891)],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.blue,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Weekly History',
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
          Positioned(
            left: 28,
            top: 105,
            child: Container(
              width: 333,
              height: 240,
              decoration: ShapeDecoration(
                color: Color(0xFFFFF5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This Week’s Water Usage',
                    style: TextStyle(
                      color: Color(0xFF4DD3E5),
                      fontSize: 20,
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    "assets/images/water.PNG",
                    width: 69,
                    height: 82,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${_totalConsumption.toStringAsFixed(2)} mL/week',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      Positioned(
        right: MediaQuery.of(context).size.width / 2 - 60,
        top: 355,// Adjust the position as needed
          child: Text(
            '$startDateString - $endDateString',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

      ),
          Positioned(
            left: 28,
            top: 388,
            child: Container(
              width: 333,
              height: 371,
              decoration: ShapeDecoration(
                color: Color(0xFFFFF5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Graphical Representation',
                      style: TextStyle(
                        color: Color(0xFF4DD3E5),
                        fontSize: 20,
                        fontFamily: 'SeoulHangang',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _dataList.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getWeeklyWaterConsumptionData('Tap1_Flow'),
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.orange.withOpacity(0.3),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: _getWeeklyWaterConsumptionData('Tap2_Flow'),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.3),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                                  return Text(weekDays[value.toInt()]);
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((LineBarSpot touchedSpot) {
                                  final textStyle = TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  );
                                  return LineTooltipItem(
                                    '${DateFormat.E().format(DateTime.now().subtract(Duration(days: 6 - touchedSpot.x.toInt())))}: ${touchedSpot.y.toStringAsFixed(2)} mL',
                                    textStyle,
                                  );
                                }).toList();
                              },
                            ),
                            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                              if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
                                final spot = response.lineBarSpots!.first;
                                final day = spot.x.toInt();
                                final tap1Consumption = _getWeeklyWaterConsumptionData('Tap1_Flow')
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                final tap2Consumption = _getWeeklyWaterConsumptionData('Tap2_Flow')
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                _showDataAlert(context, day, tap1Consumption, tap2Consumption);
                              }
                            },
                          ),
                        ),
                      ),
                    )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
