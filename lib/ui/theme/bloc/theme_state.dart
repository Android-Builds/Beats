import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState({
    @required this.themeMode,
  }) : super();

  @override
  List<Object> get props => [themeMode];
}
