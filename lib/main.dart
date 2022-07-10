import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'providers/alarm_provider.dart';
import 'providers/active_provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AlarmProvider>(create: (context) => AlarmProvider()),
        ChangeNotifierProvider<ActiveProvider>(create: (context) => ActiveProvider()),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    ));
}

