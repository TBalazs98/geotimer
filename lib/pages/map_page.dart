
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotimer/pages/navigation_draver.dart';
import 'package:geotimer/providers/alarm_provider.dart';
import 'package:geotimer/services/db_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/alarm.dart';

class MapPage extends StatefulWidget {
  Alarm? alarm;
  bool isEditable;

  MapPage({Key? key, this.alarm, this.isEditable = true }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late Alarm _alarm;
  late double currentFrequencyValue;
  late double currentDistanceValue;

  late CircleMarker circle;
  late MapController controller  = MapController();
  final _save = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.alarm == null){
      _alarm = Alarm();
    }else{
      _alarm = widget.alarm!;
    }
    
    currentFrequencyValue = _alarm.frequency;
    currentDistanceValue = _alarm.r.toDouble();

    circle = CircleMarker(point: LatLng(_alarm.lat, _alarm.lon), radius: _alarm.r*1000, useRadiusInMeter: true, color: Colors.blue.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    var alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    return Scaffold(
      drawer: const MyNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Térkép"), 
        backgroundColor: Colors.black45,
        actions: [
          if(widget.isEditable)
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: ElevatedButton(
              child: const Text("Mentés"), onPressed: () async => {
                await showDialog(
                  context: context, 
                  builder: (BuildContext context) => AlertDialog(
                  title: const Text('Mentés'),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                    return Form(
                      key: _save,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: "Név", 
                            ),
                        
                            validator: (text) {
                              if (text != null && text.isNotEmpty) {
                                return null;
                              }
                                return "Nem maradhat üresen!";
                            }),
                  
                            Container(
                              margin: const EdgeInsets.fromLTRB(0,50,0,0),
                              child: const Text("Frissítések száma egy órán belül."),
                            ),
                  
                            Container(
                              margin: EdgeInsets.zero,
                              child: Row(
                                children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("${currentFrequencyValue.round()}")
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(onPressed: () =>{
                                    setState(() {
                                      if(currentFrequencyValue > 1){
                                        currentFrequencyValue--;
                                      }
                                      else{
                                        currentFrequencyValue = 1;
                                      }
                                    })
                                  }, 
                                  icon: const FaIcon(FontAwesomeIcons.minus))),
                                Expanded(
                                  flex: 6,
                                  child: Slider(
                                    value: currentFrequencyValue,
                                    divisions: 240,
                                    max: 240,
                                    min: 1,
                                    onChanged: (newValue) {
                                    setState(() {
                                      currentFrequencyValue = newValue;
                                    });
                                  }),
                                ),
                                Expanded(
                                  flex: 1, 
                                  child: IconButton(onPressed: () =>{
                                    setState(() {
                                      if(currentFrequencyValue < 240){
                                        currentFrequencyValue++;
                                      }
                                      else{
                                        currentFrequencyValue = 240;
                                      }
                                    })
                                  }, 
                                  icon: const FaIcon(FontAwesomeIcons.plus))),
                                ]),
                            )
                      ]), 
                    );
                    }
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context, 'Cancel'),
                        currentFrequencyValue = _alarm.frequency.toDouble(),
                        nameController.clear(),
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async => {
                        if(_save.currentState!.validate()){
                          _alarm.city = nameController.text,
                          _alarm.frequency = currentFrequencyValue,
                          alarmProvider.addAlarm(_alarm),
                          nameController.clear(),
                          Navigator.pop(context, 'OK'),
                          Navigator.pop(context),
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ]),
                )},
            ),
          )],
      ),
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
            center: LatLng(47.4979, 19.0402),
            zoom: 9.2,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            onTap: (position, latlng) => {
              placeMarker(latlng)
            },
        ),
        layers: [
            TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
              ]),
            CircleLayerOptions(
              circles: [
                circle
              ]
            )
        ],
        nonRotatedChildren: [
          if(widget.isEditable)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 30, 40),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(onPressed: (() {
                showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Táv'),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      margin: EdgeInsets.zero,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                              margin: EdgeInsets.zero,
                              child: Row(
                                children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("${currentDistanceValue.round()}")
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(onPressed: () =>{
                                    setState(() {
                                      if(currentDistanceValue > 1){
                                        currentDistanceValue--;
                                      }
                                      else{
                                        currentDistanceValue = 1;
                                      }
                                    })
                                  }, 
                                  icon: const FaIcon(FontAwesomeIcons.minus))),
                                Expanded(
                                  flex: 6,
                                  child: Slider(
                                    value: currentDistanceValue,
                                    divisions: 50,
                                    max: 50,
                                    min: 1,
                                    onChanged: (newValue) {
                                    setState(() {
                                      currentDistanceValue = newValue;
                                    });
                                  }),
                                ),
                                Expanded(
                                  flex: 1, 
                                  child: IconButton(onPressed: () =>{
                                    setState(() {
                                      if(currentDistanceValue < 240){
                                        currentDistanceValue++;
                                      }
                                      else{
                                        currentDistanceValue = 240;
                                      }
                                    })
                                  }, 
                                  icon: const FaIcon(FontAwesomeIcons.plus))),
                                ]),
                            )
                        ],
                      ),
                    );
                  } ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context, 'Cancel'),
                        currentDistanceValue = _alarm.r.toDouble(),
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async => {
                        _alarm.r = currentDistanceValue.round(),
                        Navigator.pop(context, 'OK'),
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              }),
              child: const Text("Táv"),
              ),
            )
        ],
      ),
    );
  }


  placeMarker(LatLng latLng){
    setState(() {
        _alarm.lat = latLng.latitude;
        _alarm.lon = latLng.longitude;
        circle = CircleMarker(point: latLng, radius: _alarm.r*1000, useRadiusInMeter: true, color: Colors.blue.withOpacity(0.7));
    });
  }
}

