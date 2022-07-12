import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MySlider extends StatefulWidget {
  const MySlider({Key? key}) : super(key: key);

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
double _value = 40.0;

@override
Widget build(BuildContext context) {
  return Scaffold(
     appBar: AppBar(
       title: const Text('Syncfusion Flutter Slider'),
     ),
     body: SfSlider(
       min: 0.0,
       max: 100.0,
       value: _value,
       interval: 20,
       showTicks: true,
       showLabels: true,
       enableTooltip: true,
       minorTicksPerInterval: 1,
       onChanged: (dynamic value){
         setState(() {
           _value = value;
         });
       },
     ),
   );
}
}