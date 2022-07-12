

import 'package:flutter/foundation.dart';
import 'package:geotimer/models/alarm.dart';
import 'package:geotimer/services/db_service.dart';

class AlarmProvider with ChangeNotifier{
  List<Alarm> _active = [];
  List<Alarm> _inactive = [];

  List<Alarm> get acticeItems {
    return [..._active];
  }

  List<Alarm> get inactiveItems {
    return [..._inactive];
  }



  void addAlarm(Alarm data) async {
      await DBService.insert(data.toMap())
      .then((value) => {
          _inactive.add(data),
          notifyListeners(),
      });
      
  }

  void updateAlarm(Alarm data) async {
    await DBService.update(data.toMap())
      .then((value) => {
        _inactive[_inactive.indexWhere((element) => element.id == data.id)] = data,
        notifyListeners(),
      });
  }

  void deleteAlarm(Alarm data) async {
      await DBService.remove(data.toMap()).then((value) => {
      _inactive.removeWhere((element) => element.id == data.id),
      notifyListeners(),
    });
  }

  Future<void> fetchActiveAlarms() async{
    final data = await DBService.getByActivity(1);

    _active = data;
    //notifyListeners();
  }

  Future<void> fetchInactiveAlarms() async {
    final data = await DBService.getByActivity(0);

    _inactive = data;
    print("itt");
    //notifyListeners();
  }


  void tumbleAlarm(Alarm data) async {
    await DBService.tumbleAlarm(data)
    .then((value) => {
      notifyListeners(),
    });
  }



}