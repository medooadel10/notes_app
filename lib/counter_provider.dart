import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int counter = 1;
  void incrementCounter() {
    counter++;
    notifyListeners();
  }
}
