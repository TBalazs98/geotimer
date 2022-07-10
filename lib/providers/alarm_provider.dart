

import 'package:flutter/foundation.dart';
import 'package:geotimer/models/alarm.dart';
import 'package:geotimer/services/db_service.dart';

class AlarmProvider with ChangeNotifier{
  List<Alarm> _alarms = [];

  List<Alarm> get items {
    return [..._alarms];
  }

  void addAlarm(Alarm data) async {
      await DBService.insert(data.toMap())
      .then((value) => {
          _alarms.add(data),
          notifyListeners(),
      });
      
  }

  void updateAlarm(Alarm data) async {
    await DBService.update(data.toMap())
      .then((value) => {
        _alarms[_alarms.indexWhere((element) => element.id == data.id)] = data,
        notifyListeners(),
      });
  }

  void deleteAlarm(Alarm data) async {
      await DBService.remove(data.toMap()).then((value) => {
      _alarms.removeWhere((element) => element.id == data.id),
      notifyListeners(),
    });
  }

  Future<void> fetchAlarms() async{
    final data = await DBService.getData();

    _alarms = data;
    notifyListeners();
  }



}