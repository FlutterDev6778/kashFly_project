import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatatableHeader {
  final String text;
  final String value;
  final bool sortable;
  final bool editable;
  bool show;
  final TextAlign textAlign;
  final int flex;
  final Widget Function(dynamic value) headerBuilder;
  final Widget Function(dynamic value, Map<String, dynamic> row) sourceBuilder;
  final List<TextInputFormatter> inputFormatters;

  DatatableHeader({
    this.text,
    this.textAlign: TextAlign.center,
    this.sortable,
    this.value,
    this.show: true,
    this.editable: false,
    this.flex,
    this.headerBuilder,
    this.sourceBuilder,
    this.inputFormatters,
  });

  factory DatatableHeader.fromMap(Map<String, dynamic> map) => DatatableHeader(
        text: map['text'],
        value: map['value'],
        sortable: map['sortable'],
        show: map['show'],
        textAlign: map['textAlign'],
        flex: map['flex'],
        headerBuilder: map['headerBuilder'],
        sourceBuilder: map['sourceBuilder'],
        inputFormatters: map['inputFormatters'],
      );
  Map<String, dynamic> toMap() => {
        "text": this.text,
        "value": this.value,
        "sortable": this.sortable,
        "show": this.show,
        "textAlign": this.textAlign,
        "flex": this.flex,
        "headerBuilder": this.headerBuilder,
        "sourceBuilder": this.sourceBuilder,
        "inputFormatters": this.inputFormatters,
      };
}
