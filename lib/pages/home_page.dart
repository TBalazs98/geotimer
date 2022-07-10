import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotimer/providers/alarm_provider.dart';
import 'package:provider/provider.dart';
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
        future: Provider.of<AlarmProvider>(context, listen: false).fetchAlarms(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ?  const Center(child: CircularProgressIndicator())
            : Consumer<AlarmProvider>(
                builder: (ctx, alarms, ch) {
                  if(alarms.items.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: alarms.items.length,
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
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            )]),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(alarms.items[i].city),
                            subtitle: Text("${alarms.items[i].r} km, ${alarms.items[i].frequency} ping/h"),
                            leading: IconButton(icon: const FaIcon(FontAwesomeIcons.plus), color: Colors.green, onPressed: () => {},),
                            trailing: IconButton(icon: const FaIcon(Icons.delete), color: Colors.red, onPressed: () => {},),
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

