import 'package:bloc/bloc.dart';
import 'package:dutch_game_studio_assessment/bootstrap.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}