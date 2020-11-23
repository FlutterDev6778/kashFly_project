import 'package:flutter/material.dart';

class Error404Page extends StatefulWidget {
  const Error404Page({
    Key key,
  }) : super(key: key);

  @override
  _Error404PageState createState() => _Error404PageState();
}

class _Error404PageState extends State<Error404Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "404 Page\nNot found",
            style: TextStyle(fontSize: 30, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
