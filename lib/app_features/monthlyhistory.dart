import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MonthlyHistoryPage extends StatefulWidget {
  @override
  _MonthlyHistoryPageState createState() => _MonthlyHistoryPageState();
}

class _MonthlyHistoryPageState extends State<MonthlyHistoryPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, double> _dailyConsumption = {};
  double _totalConsumption = 0.0;
  String _currentMonth = '';

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    final snapshot = await _databaseReference.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final dateTimeString = key as String;
        final dateTime = DateTime.parse(dateTimeString);
        final date = DateFormat('yyyy-MM-dd').format(dateTime);
        _currentMonth = DateFormat('MMMM yyyy').format(dateTime);

        if (value is Map && value.containsKey('Water_Usage')) {
          final waterUsage = Map<String, dynamic>.from(value['Water_Usage']);
          final totalConsumption = double.tryParse(waterUsage['Total_Consumption'].toString()) ?? 0.0;

          if (!_dailyConsumption.containsKey(date)) {
            _dailyConsumption[date] = 0.0;
          }
          _dailyConsumption[date] = _dailyConsumption[date]! + totalConsumption;
          _totalConsumption += totalConsumption;
        }
      });

      setState(() {});
    }
  }

  List<FlSpot> _getMonthlyWaterConsumptionData() {
    List<FlSpot> spots = [];
    Map<int, double> dayIndexConsumption = {};

    _dailyConsumption.forEach((date, consumption) {
      int dayIndex = DateTime.parse(date).day - 1;
      dayIndexConsumption[dayIndex] = consumption;
    });

    for (int i = 0; i < 31; i++) {
      spots.add(FlSpot(i.toDouble(), dayIndexConsumption[i] ?? 0.0));
    }

    return spots;
  }

  void _showDataAlert(BuildContext context, int day, double consumption) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Water Consumption Data"),
          content: Text("Day: ${day + 1}\nConsumption: ${consumption.toStringAsFixed(2)} mL"),
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
                    'Monthly History',
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
                    'This Month’s Water Usage',
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
                    '${_totalConsumption.toStringAsFixed(2)} mL/month',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Month: $_currentMonth',
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
                    child: _dailyConsumption.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 30,
                          minY: 0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getMonthlyWaterConsumptionData(),
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
                                  switch (value.toInt()) {
                                    case 0:
                                      return Text('1');
                                    case 4:
                                      return Text('5');
                                    case 9:
                                      return Text('10');
                                    case 14:
                                      return Text('15');
                                    case 19:
                                      return Text('20');
                                    case 24:
                                      return Text('25');
                                    case 29:
                                      return Text('30');
                                    default:
                                      return Text('');
                                  }
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
                                    'Day ${touchedSpot.x.toInt() + 1}: ${touchedSpot.y.toStringAsFixed(2)} mL',
                                    textStyle,
                                  );
                                }).toList();
                              },
                            ),
                            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                              if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
                                final spot = response.lineBarSpots!.first;
                                final day = spot.x.toInt();
                                final consumption = _getMonthlyWaterConsumptionData()
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                _showDataAlert(context, day, consumption);
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
