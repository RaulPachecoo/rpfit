import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MotivationScreen extends StatefulWidget {
  @override
  _MotivationScreenState createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final _videoURL1 = "https://youtube.com/shorts/L_jLOqRC-n4?si=e2lGs165F9cam422";
  final _videoURL2 = "https://youtube.com/shorts/Teh-2lhGRTA?si=67RKpu7l3HvqDJkz"; 
  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;

  @override
  void initState() {
    
    
    final videoID1 = YoutubePlayer.convertUrlToId(_videoURL1);
    _controller1 = YoutubePlayerController(
      initialVideoId: videoID1!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    
    final videoID2 = YoutubePlayer.convertUrlToId(_videoURL2);
    _controller2 = YoutubePlayerController(
      initialVideoId: videoID2!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    
    super.initState();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/Arnold.jpg', // Reemplaza con la ruta de tu imagen
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '“Puedes tener resultados o excusas. No las dos cosas” – Arnold Schwarzenegger',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            YoutubePlayer(
              controller: _controller1,
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/Madelman.jpg', // Reemplaza con la ruta de tu imagen
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '“Tu entrena y que ladren los perros” – Madelman',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            YoutubePlayer(
              controller: _controller2,
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/brandon.jpg', // Reemplaza con la ruta de tu imagen
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '“La vida es tuya. La vida es lo que tu haces de ella. Si pasas tu vida deseando, en lugar de haciendo, siempre estarás inventando excusas de por qué no estás en el mismo nivel que otros.” – Brandon Lilly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ), 
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/gym.png', // Reemplaza con la ruta de tu imagen de portada
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gym',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Haz clic en el botón de play para escuchar la playlist',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.play_circle_fill, color: Colors.green, size: 50),
                    onPressed: () => _launchURL('https://open.spotify.com/playlist/1sOpDBfL10S6Q2wKl96zZK?si=9bda495e88b4491d'), // Reemplaza con tu enlace de Spotify
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
