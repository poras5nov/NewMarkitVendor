import 'package:flutter/material.dart';

class DrawerViewScreen extends StatefulWidget {
  @override
  _DrawerViewScreenState createState() => _DrawerViewScreenState();
}

class _DrawerViewScreenState extends State<DrawerViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      child: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width - 80,
                color: Colors.red,
              ),
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container();
                      })),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Logout"),
              )
            ]),
      ),
    );
  }
}
