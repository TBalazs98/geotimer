import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotimer/pages/map_page.dart';
import 'package:geotimer/providers/alarm_provider.dart';
import 'package:provider/provider.dart';
import '../models/alarm.dart';
import 'navigation_draver.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Provider.of<AlarmProvider>(context, listen: false).fetchInactiveAlarms(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ?  const Center(child: CircularProgressIndicator())
            : Consumer<AlarmProvider>(
                builder: (ctx, alarms, ch) {
                  if(alarms.inactiveItems.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: alarms.inactiveItems.length,
                      itemBuilder: (ctx, i) =>  
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 6.0,
                            )]),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(alarms.inactiveItems[i].city),
                            subtitle: Text("${alarms.inactiveItems[i].r} km, ${alarms.inactiveItems[i].frequency} ping/h"),
                            leading: IconButton(icon: const FaIcon(FontAwesomeIcons.plus), color: castToBool(alarms.inactiveItems[i].isActive) ? Colors.green : Colors.red ,onPressed: castToBool(alarms.inactiveItems[i].isActive) ? null : () => activateAlarm()),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const FaIcon(Icons.edit), color: Colors.blue, onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage(isEditable: true, alarm: alarms.inactiveItems[i])))),
                                IconButton(icon: Ink(child: const FaIcon(Icons.delete)), color: Colors.red, onPressed: () => deleteAlarm(alarms, alarms.inactiveItems[i])),
                              ]),
                            tileColor: Colors.white,
                          ),
                        ),
                      ));
                  } else{
                    return ElevatedButton(child: const Text("Vegyél fel egy új elemet"), onPressed: () => {});
                  }
            }),
      ),
    );
  }
}

bool castToBool(int x){
  switch(x){
    case 0:
      return false;
    
    case 1:
      return true;

    default:
      return false;
  }
}


void deleteAlarm(AlarmProvider provider, Alarm alarm){
  provider.deleteAlarm(alarm);
}

void tumbleAlarm(AlarmProvider provider, Alarm alarm){
  provider.tumbleAlarm(alarm);
  print("teszt");
}

void activateAlarm(){
  print("print");
}