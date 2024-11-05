import 'package:flutter/material.dart';

class EmailCheckScreen extends StatefulWidget {
  @override
  _EmailCheckScreenState createState() => _EmailCheckScreenState();
}

class _EmailCheckScreenState extends State
 {
@override
Widget build(BuildContext context) {
return Scaffold(
resizeToAvoidBottomInset: true, // Adjust to true to ensure the page fills the entire mobile screen
body: Center(
child: Container(
width: MediaQuery.of(context).size.width, // Full width
height: MediaQuery.of(context).size.height, // Full height
clipBehavior: Clip.antiAlias,
decoration: ShapeDecoration(
gradient: LinearGradient(
begin: Alignment(-0.00, -1.00),
end: Alignment(0, 1),
colors: [Color(0xFFFAFDFD), Color(0x0090A891)],
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(37),
side: BorderSide.none,
),
shadows: [
BoxShadow(
color: Color(0x3F000000),
blurRadius: 4,
offset: Offset(0, 4),
spreadRadius: 0,
),
],
),
child: Stack(
alignment: Alignment.center, // Center align the content of the Stack
children: [
Positioned(
top: MediaQuery.of(context).size.height / 4, // Adjust as needed
child: Container(
width: 150,
height: 150,
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage("assets/images/gmail.png"),
fit: BoxFit.fill,
),
),
),
),
Positioned(
top: MediaQuery.of(context).size.height / 2 - 50,
width: MediaQuery.of(context).size.width,
child: SizedBox(
width: 232,
height: 100,
child: Text(
'Kindly check your E-mail\nto reset your password ',
textAlign: TextAlign.center,
style: TextStyle(
color: Color(0xD80D0E0E),
fontSize: 20,
fontFamily: 'SeoulHangang',
fontWeight: FontWeight.w400,
),
),
),
),
Positioned(
top: MediaQuery.of(context).size.height / 2 + 50, // Adjust as needed
child: ElevatedButton(
onPressed: () {
Navigator.popUntil(context, ModalRoute.withName('/login_screen'));
},
child: Text(
'Back',
style: TextStyle(
color: Color(0xFF151313),
fontSize: 24,
fontFamily: 'Poppins',
fontWeight: FontWeight.w500,
),
),
style: ButtonStyle(
backgroundColor: MaterialStateProperty.all(Color(0xB5666669)),
elevation: MaterialStateProperty.all(0),
shape: MaterialStateProperty.all(
RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30),
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
