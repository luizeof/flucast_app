import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class YoutubeVideo {
  var id, title, description, pubDate, live;
  YoutubeVideo({
    this.id,
    this.title,
    this.description,
    this.pubDate,
    this.live,
  });

  String getUrl() {
    return "https://www.youtube.com/watch?v=" + this.id.toString();
  }

  String getCover() {
    return "https://i.ytimg.com/vi/" + this.id.toString() + "/mqdefault.jpg";
  }

  Future<Widget> getPlayer(
      {bool autoplay = false, bool fullscreen = false}) async {
    var _y = new YoutubeChannel();
    var _str = await _y.getApiUrl();
    return FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: _str.toString(),
        videoUrl: this.getUrl().toString(),
        autoPlay: autoplay, //default falase
        fullScreen: fullscreen //default false
        );
  }

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    return YoutubeVideo(
      id: json['id']['videoId'],
      title: json['snippet']['title'] as String,
      description: json['snippet']['description'] as String,
      pubDate: json['snippet']['publishedAt'] as String,
      live: json['snippet']['thumbnails']['high']['url'] as String,
    );
  }
}

class YoutubeChannel {
  //
  Future<String> getApiUrl() async {
    var _gc = await GlobalConfiguration().loadFromAsset("app_settings");
    var _apikey = _gc.get("youtube_api_android");
    var _channel = _gc.get("youtube_channel_id");
    return "https://www.googleapis.com/youtube/v3/search?key=$_apikey&channelId=$_channel&part=snippet,id&order=date&maxResults=20";
  }

  Future<List<YoutubeVideo>> getVideos() async {
    List<YoutubeVideo> videos = new List<YoutubeVideo>();
    var _response = await http.get(await this.getApiUrl());
    var _body = _response.body;

    var list = jsonDecode(_body);

    for (var item in list["items"]) {
      videos.add(YoutubeVideo.fromJson(item));
    }

    return videos;
  }
}
