import 'package:flutter/material.dart';
import 'package:flucast_app/global.dart';
import 'package:dart_pod/dart_pod.dart';
import 'package:audioplayer/audioplayer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;

  AudioPlayer audioPlayer;

  Widget _buildEpisodeTitle(Episode __episode) {
    if (currentEpisode.title == __episode.title) {
      return Text(
        __episode.title,
        softWrap: true,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        __episode.title,
        softWrap: true,
      );
    }
  }

  IconData _getEpisodeIcon() {
    if (_isPlaying == true) {
      return Icons.stop;
    } else {
      return Icons.play_circle_outline;
    }
  }

  Widget _buildEpisodeRow(Podcast __podcast, Episode __episode) {
    if (__podcast.episodes.isNotEmpty) {
      if (currentEpisode.title == __episode.title) {
        return Card(
            child: Column(children: [
          ListTile(
              leading: Image(
                  image: NetworkImage(__podcast.logoUrl), fit: BoxFit.cover),
              title: _buildEpisodeTitle(__episode),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    __episode.pubDate.toString(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
              trailing: Icon(_getEpisodeIcon()),
              onTap: () {
                setState(() {
                  currentEpisode = __episode;
                  if (_isPlaying == true) {
                    audioPlayer.stop();
                    _isPlaying = false;
                  } else {
                    audioPlayer.play(__episode.url.toString());
                    _isPlaying = true;
                  }
                });
              }),
        ]));
      } else {
        return Card(
            child: Column(children: [
          ListTile(
              leading: Image(
                  image: NetworkImage(__podcast.logoUrl), fit: BoxFit.cover),
              title: _buildEpisodeTitle(__episode),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    __episode.pubDate.toString(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
              trailing: Icon(Icons.play_circle_outline),
              onTap: () {
                setState(() {
                  currentEpisode = __episode;
                  if (_isPlaying == true) {
                    audioPlayer.stop();
                    _isPlaying = false;
                  } else {
                    audioPlayer.play(__episode.url.toString());
                    _isPlaying = true;
                  }
                });
              }),
        ]));
      }
    } else {
      return Center(child: Text("Nenhum episódio encontrado."));
    }
  }

  Widget _podcastDetails() {
    return Column(
      children: [Image.network(myPodcast.logoUrl)],
    );
  }

  Widget _podcatEpisodesList() {
    return Column(
      children: <Widget>[
        new Expanded(
            child: new ListView.builder(
                itemCount: myPodcast.episodes.length,
                itemBuilder: (BuildContext ctxt, int i) {
                  return _buildEpisodeRow(myPodcast, myPodcast.episodes[i]);
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer = new AudioPlayer();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(myPodcast.title),
            bottom: TabBar(
              tabs: <Tab>[
                Tab(text: 'Sobre'),
                Tab(text: 'Episódios'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _podcastDetails(),
              _podcatEpisodesList(),
            ].toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                myPodcast = myPodcast;
              });
            },
            tooltip: 'Update Feed',
            child: Icon(Icons.refresh),
          ),
        ));
  }
}
