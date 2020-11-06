import 'package:flutter/material.dart';

class Error404Page extends StatefulWidget {
  final String routeName;

  const Error404Page({
    Key key,
    @required this.routeName,
  }) : super(key: key);

  @override
  _Error404PageState createState() => _Error404PageState();
}

class _Error404PageState extends State<Error404Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404 Error'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text('Not found ${widget.routeName.replaceAll("/", "")}'),
        ),
      ),
    );
  }
}
