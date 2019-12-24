import 'package:flutter/material.dart';
import 'package:flucast_app/global.dart';
import 'package:dart_pod/dart_pod.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildEpisodeRow(Podcast __podcast, Episode __episode) {
    if (__podcast.episodes.isNotEmpty) {
      return Card(
          child: ListTile(
              leading: Image(
                  image: NetworkImage(__podcast.logoUrl), fit: BoxFit.cover),
              title: Text(
                __episode.title,
                softWrap: true,
              ),
              subtitle:
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  __episode.pubDate.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ]),
              trailing: Icon(Icons.play_circle_outline),
              onTap: () {}));
    } else {
      return Center(child: Text("Nenhum episódio encontrado."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myPodcast.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.network(myPodcast.logoUrl),
          new Expanded(
              child: new ListView.builder(
                  itemCount: myPodcast.episodes.length,
                  itemBuilder: (BuildContext ctxt, int i) {
                    return _buildEpisodeRow(myPodcast, myPodcast.episodes[i]);
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Update Feed',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
