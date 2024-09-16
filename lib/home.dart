import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart' as players;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:speakprompt/controllers/ai_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _player = AudioPlayer();
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 38, 38, 100),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/light_bulb.png')
          )
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    // maxLines: 1,
                    controller: _controller,
                    enabled: !context.watch<AIcontroller>().isLoading,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    onEditingComplete: (){
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () async{
                          FocusScope.of(context).unfocus();
                          await context.read<AIcontroller>().getVoiceFromPrompt(_controller.text).catchError(
                            (e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.white38,
                                content: Text(e.toString())
                              ));
                            }
                          );
                          
                          
                        },
                        splashColor: Colors.white12,
                        child: const Icon(Icons.send_outlined, color: Colors.white70,)),
                      labelText: 'Enter a story idea...',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(147, 143, 153, 1),
                        ),
            
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(147, 143, 153, 1),
                        ),
            
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(147, 143, 153, 0.623),
                        ),
            
                      ),

                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: context.watch<AIcontroller>().isLoading,
              child: loadingAnimation),
            Visibility(
              visible: _player.playing,
              child: voiceAnimationPlay),
            Visibility(
              visible: context.watch<AIcontroller>().voiceBytes != null && !_player.playing,
              child: playButton(context.read<AIcontroller>().voiceBytes?? Uint8List.fromList([]))
            ),
            Visibility(
              visible: _player.playing,
              child: stopButton(context.read<AIcontroller>().voiceBytes?? Uint8List.fromList([]))
            ),
            
          ],
        ),
      ),
    );
  }

  get loadingAnimation => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitChasingDots(
          color: Colors.white,
        ),
        Text('Generating...')
      ],
    ),
  );

  playButton (Uint8List audioBytes)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async{
            await _player.setAudioSource(AudioSource.uri(Uri.dataFromBytes(audioBytes, mimeType: 'audio/mp3')));
            _player.play();
            setState(() { });
            // Timer.periodic(const Duration(seconds: 1), (timer) { log(_player.playing.toString()); });
            await Future.delayed(const Duration(seconds: 10)).then((value) => _player.stop());
            setState(() { });
          }, 
          icon: const Icon(
            Icons.play_circle_outline,
            size: 100,
            color: Colors.white60,
          ),
        ),
        const Text(
          'Play',
          style: TextStyle(color: Colors.white60),
        )
      ],
    ),
  );

    stopButton (Uint8List audioBytes)=> Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async{
              _player.stop();
              setState(() { });
            }, 
            icon: const Icon(
              Icons.stop_circle_outlined,
              size: 100,
              color: Colors.white60,
            ),
          ),
          const Text(
            'Stop',
            style: TextStyle(color: Colors.white60),
          )
        ],
      ),
    );

    playButton2 (Uint8List audioBytes)=> IconButton(
      onPressed: () async{
        players.AudioPlayer player = players.AudioPlayer();
        final source = players.BytesSource(audioBytes);
        log(audioBytes.toString());
        await player.setSource(source);

        await player.play(source);
      }, 
      icon: const Icon(
        Icons.play_circle_outline,
        size: 100,
        color: Colors.red,
      ),
    );

  get voiceAnimationPlay => Center(
    child: Lottie.asset("assets/lottie_voice_animation.json"),
  ); 
}


