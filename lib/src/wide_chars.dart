

import 'package:characters/characters.dart';


final RegExp REGEX_EMOJI = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

bool isEmoji(String character){
  return REGEX_EMOJI.hasMatch(character);
}