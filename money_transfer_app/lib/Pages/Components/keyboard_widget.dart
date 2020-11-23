import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class CustomNumberKeyboard extends StatefulWidget {
  final Color backColor;
  final Color foreColor;
  final double fontSize;
  final double iconSize;
  final double keyHorizontalPadding;
  final double keyVerticalPadding;
  final Function(String) onPress;
  final Function() onBackspacePress;
  final int type;
  String initValue;
  Function forgottenFunction;

  CustomNumberKeyboard({
    @required this.backColor,
    @required this.foreColor,
    @required this.fontSize,
    @required this.iconSize,
    @required this.keyHorizontalPadding,
    @required this.keyVerticalPadding,
    this.onPress,
    this.onBackspacePress,
    this.type = 0,
    this.initValue = "",
    this.forgottenFunction,
  });

  @override
  _CustomNumberKeyboardState createState() => _CustomNumberKeyboardState();
}

class _CustomNumberKeyboardState extends State<CustomNumberKeyboard> {
  String value;
  @override
  void initState() {
    super.initState();

    value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initValue != null) {
      value = widget.initValue;
      widget.initValue = null;
    }
    List<Widget> _listWidget = [];

    for (var i = 0; i < 3; i++) {
      List<Widget> rowWidget = [];
      for (var j = 0; j < 3; j++) {
        rowWidget.add(
          Expanded(
            child: GestureDetector(
              onTap: () {
                value += (i * 3 + (j + 1)).toString();
                if (widget.onPress != null) {
                  widget.onPress(value);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widget.keyHorizontalPadding, vertical: widget.keyVerticalPadding),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "${i * 3 + (j + 1)}",
                  style: TextStyle(fontSize: widget.fontSize, color: widget.foreColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      }
      _listWidget.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowWidget,
        ),
      );
    }

    _listWidget.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.type == 0
              ? _forgotButton()
              : widget.type == 1
                  ? _dotButton()
                  : Expanded(child: SizedBox()),
          Expanded(
            child: GestureDetector(
              onTap: () {
                value += "0";
                if (widget.onPress != null) {
                  widget.onPress(value);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widget.keyHorizontalPadding, vertical: widget.keyVerticalPadding),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text("0", style: TextStyle(fontSize: widget.fontSize, color: widget.foreColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: widget.onBackspacePress ??
                  () {
                    if (value.length == 0) return;
                    value = value.substring(0, value.length - 1);
                    if (widget.onPress != null) {
                      widget.onPress(value);
                    }
                  },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SvgPicture.asset(AppAssets.backspaceIcon, width: widget.iconSize, fit: BoxFit.cover, color: widget.foreColor),
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      color: widget.backColor,
      child: Column(
        children: _listWidget,
      ),
    );
  }

  Widget _forgotButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.forgottenFunction();
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text("FORGOT?", style: TextStyle(fontSize: widget.fontSize * 0.7, color: widget.foreColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _dotButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (value.contains('.')) return;
          value += ".";
          if (widget.onPress != null) {
            widget.onPress(value);
          }
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(".", style: TextStyle(fontSize: widget.fontSize, color: widget.foreColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
