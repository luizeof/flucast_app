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
    if (currentEpisode != null) {
      if (currentEpisode.title == __episode.title) {
        return Center(
            child: Text(
          __episode.title,
          softWrap: true,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ));
      } else {
        return Text(
          __episode.title,
          softWrap: true,
        );
      }
    } else {
      return Text(
        __episode.title,
        softWrap: true,
      );
    }
  }

  Icon _getEpisodeIcon() {
    if (_isPlaying == true) {
      return Icon(
        Icons.stop,
        color: Colors.green,
      );
    } else {
      return Icon(
        Icons.play_circle_outline,
        color: Colors.grey,
      );
    }
  }

  void _play() {
    if (_isPlaying == true) {
      audioPlayer.stop();
      _isPlaying = false;
      print("Stop...");
    } else {
      audioPlayer.play(currentEpisode.url.toString());
      _isPlaying = true;
      print("Play: " + currentEpisode.url.toString());
    }
  }

  Widget _buildDefaultEpisode(Podcast __podcast, Episode __episode) {
    return Card(
        child: Column(children: [
      ListTile(
          leading:
              Image(image: NetworkImage(__podcast.logoUrl), fit: BoxFit.cover),
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
              _play();
            });
          }),
    ]));
  }

  Widget _buildEpisodeRow(Podcast __podcast, Episode __episode) {
    if (__podcast.episodes.isNotEmpty) {
      if (currentEpisode != null) {
        if (currentEpisode.title == __episode.title) {
          return Center(
              child: Card(
                  shape: new RoundedRectangleBorder(
                      side: new BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 30, bottom: 30),
                          child: Column(children: [
                            ListTile(
                                title: _buildEpisodeTitle(__episode),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Text(
                                      __episode.pubDate.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    )),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    currentEpisode = __episode;
                                    _play();
                                  });
                                }),
                          ])))));
        } else {
          return _buildDefaultEpisode(__podcast, __episode);
        }
      } else {
        return _buildDefaultEpisode(__podcast, __episode);
      }
    } else {
      return Center(child: Text("Nenhum episódio encontrado."));
    }
  }

  Widget _podcastDetails() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Image.network(myPodcast.logoUrl, fit: BoxFit.fill),
                  ]),
                ),
                Card(
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            myPodcast.description.toString(),
                            style: TextStyle(fontSize: 17),
                            strutStyle: StrutStyle(
                              fontSize: 34,
                              height: .65,
                            ),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
