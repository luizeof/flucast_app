//  main.dart
//
//  This file is a part of the dart_pod project.
//
//  FluCast is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This porogram is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
import 'package:flucast_app/home.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(FluCastApp());
}

class FluCastApp extends StatefulWidget {
  @override
  FluCastAppState createState() => FluCastAppState();
}

class FluCastAppState extends State<FluCastApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordCast',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          textTheme: TextTheme(
            body1: TextStyle(
              color: Colors.black,
            ),
            body2: TextStyle(
              color: Colors.white,
            ),
          ),
          primaryColor: Colors.blue,
          primaryColorDark: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.blue,
          )),
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
