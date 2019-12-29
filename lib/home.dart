//  home.dart
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
import 'dart:async';
import 'package:audioplayer/audioplayer.dart';
import 'package:flucast_app/episode.dart';
import 'package:flucast_app/podcast.dart';
import 'package:flucast_app/global.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  void initAudioPlayer() {
    positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(currentEpisode.url.toString());
    setState(() {
      playerState = PlayerState.playing;
    });
    print("play..." + currentEpisode.title.toString());
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
    print("pause...");
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
    print("stop...");
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
    print("mute...");
  }

  Widget _buildEpisodeTitle(Episode __episode) {
    if (currentEpisode != null) {
      if (currentEpisode.title == __episode.title) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text(
            __episode.title,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        );
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



  Widget _buildDefaultEpisode(Podcast __podcast, Episode __episode) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: NetworkImage(__episode.cover),
              fit: BoxFit.cover,
            ),
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
            trailing: 
              episodeIcon(),
            onTap: () {
              setState(
                () {
                  currentEpisode = __episode;
                },
              );
              if (isPlaying) {
                stop();
                play();
                Navigator.pushNamed(context, '/detail');
              } else {
                play();
                Navigator.pushNamed(context, '/detail');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeRow(Podcast __podcast, Episode __episode) {
    Size size = MediaQuery.of(context).size;
    if (__podcast.episodes.isNotEmpty) {
      if (currentEpisode != null) {
        if (currentEpisode.title == __episode.title) {
          return Center(
            child: Card(
              shape: new RoundedRectangleBorder(
                side: new BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 30,
                      bottom: 30,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentEpisode = __episode;
                        });
                        play();
                        Navigator.pushNamed(context, '/detail');
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Image.network(
                                  currentEpisode.cover,
                                  fit: BoxFit.contain,
                                  width: size.width / 4.0,
                                  height: size.width / 4.0,
                                ),
                                Expanded(
                                  child: _buildEpisodeTitle(__episode),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(),
                                Center(
                                  child: Text(
                                    __episode.pubDate.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.play_arrow,
                                      color: Colors.green,
                                      size: 33,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: playerProgress(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        positionText.toString(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        durationText.toString(),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return _buildDefaultEpisode(__podcast, __episode);
        }
      } else {
        return _buildDefaultEpisode(__podcast, __episode);
      }
    } else {
      return Center(
        child: Icon(
          Icons.audiotrack,
          size: 55,
          color: Colors.greenAccent,
        ),
      );
    }
  }

  Widget _podcastDetails() {
    if (myPodcast.runtimeType == Podcast) {
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
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          myPodcast.logoUrl,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Icon(
          Icons.cast,
          color: Colors.grey,
          size: 99,
        ),
      );
    }
  }

  Widget _podcatEpisodesList() {
    int _num =
        (myPodcast.runtimeType == Podcast ? myPodcast.episodes.length : 0);

    if (_num > 0) {
      return Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder(
              itemCount: _num,
              itemBuilder: (
                BuildContext ctxt,
                int i,
              ) {
                return _buildEpisodeRow(
                  myPodcast,
                  myPodcast.episodes[i],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Icon(
          Icons.list,
          color: Colors.grey,
          size: 99,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              (myPodcast.runtimeType == Podcast ? myPodcast.title : "FluCast"),
            ),
          ),
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
      ),
    );
  }
}
