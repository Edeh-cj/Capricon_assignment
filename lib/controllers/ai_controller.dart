import 'package:flutter/foundation.dart';
import 'package:speakprompt/repository/ai_repo.dart';

class AIcontroller extends ChangeNotifier {

  bool isLoading = false;
  String story = '';

  Uint8List? voiceBytes ;

  Future getVoiceFromPrompt(String prompt) async{
    isLoading = true;
    notifyListeners();
    try {
      story = await AIRepository.getAIStory(prompt);
      voiceBytes = await AIRepository.getAIVoice(story);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }    
    
  }

}