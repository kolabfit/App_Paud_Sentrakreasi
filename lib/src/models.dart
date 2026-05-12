part of '../main.dart';

class Challenge {
  Challenge(this.category, this.prompt, this.display, this.image, this.answers);
  final String category;
  final String prompt;
  final String display;
  final String? image;
  final List<String> answers;
}

class LetterGroup {
  const LetterGroup(this.letter, this.objects);
  final String letter;
  final List<LearningObject> objects;
}

class LearningObject {
  const LearningObject(this.name, this.img, [this.category = 'benda']);
  final String name;
  final String img;
  final String category;
}

class NumberItem {
  const NumberItem(this.number, this.name, this.img);
  final String number;
  final String name;
  final String img;
}

class IqraItem {
  const IqraItem(this.char, this.latin);
  final String char;
  final String latin;
}

class SongItem {
  const SongItem(this.id, this.title, this.videoUrl, this.lyrics);
  final String id;
  final String title;
  final String videoUrl;
  final List<LyricLine> lyrics;
}

class LyricLine {
  const LyricLine(this.time, this.text);
  final int time;
  final String text;
}
