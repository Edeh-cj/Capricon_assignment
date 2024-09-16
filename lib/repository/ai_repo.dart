import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const openAIKey = 'AIzaSyBqIwsBoASC3eboSr-kR3yQQOekAQ8Rlg8';
const voiceID = 'george';
const elevenKey = 'eWrnqSuV-2a8CPRTeCrGW_sxW8nE5SKc2HwfhuuPlUA=';
class AIRepository {
  
  static Future<String> getAIStory(String prompt) async{
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$openAIKey'),
      headers: {
        'Content-Type': 'application/json',
        
      },
      body: jsonEncode({
        'contents':[{
          "parts":[{"text": '${prompt}not more than 30 words' }]
        }]
      })
      
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final text = (((body["candidates"] as List).first)["content"] ["parts"] as List).first["text"].toString();
      return text;
    } else{
      throw Exception("${response.statusCode}: story generation did not complete");
    }
  }

  static Future<Uint8List> getAIVoice(String story) async{
    final response = await http.post(
      Uri.parse('https://api.sws.speechify.com/v1/audio/speech'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $elevenKey"
      },
      body: jsonEncode({
        "input": '<speak>$story</speak>',
        "voice_id": voiceID,
        "audio_format": "mp3"
      }      
    ));

    if (response.statusCode == 200 ) {
      String base64mp3 = jsonDecode(response.body)['audio_data'];
      final bytesmp3 = await Isolate.run(()=> base64Decode(base64mp3));
      return bytesmp3;
    } else {
      throw Exception("${response.statusCode}: Voice generation did not complete");
    }
  }

}