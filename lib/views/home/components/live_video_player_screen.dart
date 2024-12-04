import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveYouTubePlayer extends StatefulWidget {
  final String youtubeUrl;


  LiveYouTubePlayer({required this.youtubeUrl,});

  @override
  _LiveYouTubePlayerState createState() => _LiveYouTubePlayerState();
}

class _LiveYouTubePlayerState extends State<LiveYouTubePlayer> {
  late String videoId;
  late Future<List<String>> liveChatFuture;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '';
    liveChatFuture = _fetchLiveChatMessages();
  }

  // Function to fetch live chat messages
  Future<List<String>> _fetchLiveChatMessages() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$videoId&key=AIzaSyA_dBvtao_sFYmHRvqCxlELTMsCsbgvazM'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> chatMessages = [];

      for (var item in data['items']) {
        if (item['snippet'] != null && item['snippet']['displayMessage'] != null) {
          chatMessages.add(item['snippet']['displayMessage']);
        }
      }

      return chatMessages;
    } else {
      throw Exception('Failed to load live chat messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);

    // Check for null videoId
    if (videoId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Text('Invalid YouTube URL'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Live Video')),
      body: Column(
        children: [
          // YouTube Player
          Container(
            height: 300,
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(
                  isLive: true,
                  autoPlay: true,
                ),
              ),
              showVideoProgressIndicator: true,
            ),
          ),

          // Live Chat
          Expanded(
            child: FutureBuilder<List<String>>(
              future: liveChatFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching chat: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No live chat messages.'));
                }

                // Display chat messages
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
