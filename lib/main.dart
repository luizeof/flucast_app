import 'package:flutter/material.dart';
import 'package:flucast_app/home.dart';
import 'package:flucast_app/global.dart';
import 'package:dart_pod/dart_pod.dart';

Future<Podcast> loadPodcast() async {
  print("Carregando...");
  Podcast p = await Podcast.newFromURL(feed_url);
  print("carregado.");
  return p;
}

void main() async {
  myPodcast = await loadPodcast();
  runApp(FluCastApp());
}

class FluCastApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluCast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => new MyHomePage(),
        '/detail': (context) => new MyHomePage(),
      },
    );
  }
}
