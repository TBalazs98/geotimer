import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geotimer/services/db_service.dart';
import '../models/alarm.dart';

class ActiveProvider with ChangeNotifier{
  List<Alarm> _activeAlarms = [];

  List<Alarm> get items {
    return [..._activeAlarms];
  }

  void activateAlarm(int id) async {
    //await DBService.
  }

  void deactivateAlarm(int id) async {

  }


}