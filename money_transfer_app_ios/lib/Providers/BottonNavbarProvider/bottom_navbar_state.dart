import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class BottomNavbarState extends Equatable {
  final int type; // 0: init, 1: progressing, 2: success, 3: failed

  BottomNavbarState({
    @required this.type,
  });

  factory BottomNavbarState.init() {
    return BottomNavbarState(
      type: 1,
    );
  }

  BottomNavbarState copyWith({
    int type,
  }) {
    return BottomNavbarState(
      type: type ?? this.type,
    );
  }

  BottomNavbarState update({
    int type,
  }) {
    return copyWith(
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
    };
  }

  @override
  List<Object> get props => [
        type,
      ];

  @override
  bool get stringify => true;
}
