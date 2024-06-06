import 'package:flutter/material.dart';

drawer(context) {
  return Drawer(
    child: Column(
      children: [
        Container(
          color: const Color.fromRGBO(122, 190, 176, 1),
          height: MediaQuery.of(context).size.height * 0.2,
          child: const Center(
            child: Text(
              "Mari Selvan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.person),
          title: Text("Change Profile"),
        ),
        const ListTile(
          leading: Icon(Icons.list),
          title: Text("Change Subject"),
        ),
        const ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
        ),
        const ListTile(
          leading: Icon(Icons.logout),
          title: Text("Logout"),
        )
      ],
    ),
  );
}
