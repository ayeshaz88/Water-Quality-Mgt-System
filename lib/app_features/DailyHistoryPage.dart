import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DailyHistoryPage extends StatefulWidget {
  @override
  _DailyHistoryPageState createState() => _DailyHistoryPageState();
}

class _DailyHistoryPageState extends State<DailyHistoryPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, List<Map<String, dynamic>>> _dataList = {};
  double _totalConsumption = 0.0;
  String? _latestDate;

  @override
  void initState() {
    super.initState();
    _fetchLatestData();
    _calculateTotalConsumption(_latestDate ?? '');
  }


  void _fetchLatestData() {
    _databaseReference.limitToLast(1).onChildAdded.listen((event) {
      final newData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final dateTimeString = event.snapshot.key;
      if (newData.containsKey('Water_Usage') && dateTimeString != null) {
        final waterUsage = Map<String, dynamic>.from(newData['Water_Usage']);
        final dateTime = DateTime.parse(dateTimeString);

        final date = DateFormat('yyyy-MM-dd').format(dateTime);
        if (!_dataList.containsKey(date)) {
          _dataList[date] = [];
          _latestDate = date; // Set the latest date
        }

        _dataList[date]?.add({
          'time': dateTime,
          'Water_Usage': waterUsage,
        });

        // Calculate total consumption for the day
        _totalConsumption = _calculateTotalConsumption(date);

        setState(() {});
      }
    });
  }

  double _calculateTotalConsumption(String date) {
    if (!_dataList.containsKey(date)) return 0.0;

    final dayData = _dataList[date]!;
    double total = 0.0;

    for (var entry in dayData) {
      final waterUsage = entry['Water_Usage'];
      total += (double.tryParse(waterUsage['Tap1_Flow'].toString()) ?? 0) +
          (double.tryParse(waterUsage['Tap1_mLs'].toString()) ?? 0) +
          (double.tryParse(waterUsage['Tap2_Flow'].toString()) ?? 0) +
          (double.tryParse(waterUsage['Tap2_mLs'].toString()) ?? 0);
    }

    return total;
  }


  List<FlSpot> _getWaterConsumptionData(String date, String tap) {
    if (!_dataList.containsKey(date)) return [];

    final dayData = _dataList[date]!;
    List<FlSpot> spots = [];

    Map<int, double> hourlyConsumption = {};
    for (var entry in dayData) {
      final time = entry['time'] as DateTime;
      final hour = time.hour;
      final waterUsage = entry['Water_Usage'];

      if (!hourlyConsumption.containsKey(hour)) {
        hourlyConsumption[hour] = 0;
      }
      hourlyConsumption[hour] = (hourlyConsumption[hour] ?? 0) + (double.tryParse(waterUsage[tap].toString()) ?? 0);
    }

    for (int i = 0; i < 24; i += 4) {
      double sumConsumption = 0;
      for (int j = 0; j < 4; j++) {
        sumConsumption += hourlyConsumption[i + j] ?? 0;
      }
      spots.add(FlSpot(i.toDouble(), sumConsumption));
    }

    return spots;
  }

  void _showDataAlert(BuildContext context, int hour, double tap1Flow, double tap1Mls, double tap2Flow, double tap2Mls) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Water Consumption Data"),
          content: Text(
              "Time: ${hour}- ${hour + 4}h\n"
                  "Tap1 Flow: ${tap1Flow.toStringAsFixed(2)} mL\n"
                  "Tap1 mLs: ${tap1Mls.toStringAsFixed(2)} mL\n"
                  "Tap2 Flow: ${tap2Flow.toStringAsFixed(2)} mL\n"
                  "Tap2 mLs: ${tap2Mls.toStringAsFixed(2)} mL"
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
    final String date = _latestDate ?? ''; // Use the latest date

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
              height: 100, // Adjust the height of the icon bar
              color: Colors.blue,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 8), // Add some space between the back icon and the text
                  Text(
                    'Daily History',
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
                    'Today’s Water Usage',
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
                    '${_totalConsumption.toStringAsFixed(2)} mL/day',
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
          SizedBox(height: 10,),
          Positioned(
            right: MediaQuery.of(context).size.width / 2 - 60,
            top: 355,
            child: Text(
              'Date: $_latestDate',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10,),
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
                    child: _dataList.isNotEmpty && _latestDate != null
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 24,
                          minY: 0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getWaterConsumptionData(date, 'Tap1_Flow'),
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
                              spots: _getWaterConsumptionData(date, 'Tap1_mLs'),
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.red.withOpacity(0.3),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: _getWaterConsumptionData(date, 'Tap2_Flow'),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.3),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: _getWaterConsumptionData(date, 'Tap2_mLs'),
                              isCurved: true,
                              color: Colors.green,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.3),
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
                                      return Text('0-4h');
                                    case 4:
                                      return Text('4-8h');
                                    case 8:
                                      return Text('8-12h');
                                    case 12:
                                      return Text('12-16h');
                                    case 16:
                                      return Text('16-20h');
                                    case 20:
                                      return Text('20-24h');
                                    default:
                                      return Text('');
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
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
                                    '${touchedSpot.x.toInt()}h: ${touchedSpot.y.toStringAsFixed(2)} mL',
                                    textStyle,
                                  );
                                }).toList();
                              },
                            ),
                            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                              if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
                                final spot = response.lineBarSpots!.first;
                                final hour = spot.x.toInt();
                                final tap1Flow = _getWaterConsumptionData(date, 'Tap1_Flow')
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                final tap1Mls = _getWaterConsumptionData(date, 'Tap1_mLs')
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                final tap2Flow = _getWaterConsumptionData(date, 'Tap2_Flow')
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                final tap2Mls = _getWaterConsumptionData(date, 'Tap2_mLs')
                                    .firstWhere((element) => element.x == spot.x, orElse: () => FlSpot(spot.x, 0))
                                    .y;
                                _showDataAlert(context, hour, tap1Flow, tap1Mls, tap2Flow, tap2Mls);
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
