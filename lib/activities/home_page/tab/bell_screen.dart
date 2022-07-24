import 'package:flutter/material.dart';

class BellScreen extends StatefulWidget {
  @override
  _BellScreenState createState() => _BellScreenState();
}

class _BellScreenState extends State<BellScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(),
    );
  }
}
