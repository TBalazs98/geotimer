import 'package:flutter/material.dart';
import 'package:geotimer/pages/map_page.dart';
import 'home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Container(
        color: Colors.blue[800],
        child: ListView(
              children: <Widget>[
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const FaIcon(
                      Icons.alarm_rounded,
                      size: 75,
                      color: Colors.white
                    ),
                  ),
                ),
                const Divider(
                  height: 25,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.house,
                      size: 25,
                      color: Colors.white,
                    ),
                    title: const Text("Home", style: TextStyle(color: Colors.white)),
                    onTap: () => navigateTo(context, 0),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.house,
                      size: 25,
                      color: Colors.white,
                    ),
                    title: const Text("Map", style: TextStyle(color: Colors.white)),
                    onTap: () => navigateTo(context, 1),
                  ),
                ),
              ],
        ),
      ),
    );
  }


  void navigateTo(BuildContext context, int index){
    switch(index){
        case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
        break;

        case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage(isEditable: true)));
        break;
    }

  }


}