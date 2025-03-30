import 'package:intl/intl.dart';

class NoteModel {
  int? id;
  String? title;
  String? body;
  String? category;
  String? colors;
  DateTime? dateTime;

  NoteModel({
    this.title,
    this.id,
    this.body,
    this.colors,
    this.category,
    this.dateTime,
  });

  Map<String, dynamic> toMap({bool isAdd = true}) {
    return {
      if (!isAdd) 'id': id,
      'title': title,
      'body': body,
      'category': category,
      'colors': colors,
      'date': DateFormat.yMMMMd().format(DateTime.now())
    };
  }

  NoteModel.fromMap({required Map<String, dynamic> map})
      : id = map['id'],
        body = map['body'],
        title = map['title'],
        category = map['category'],
        colors = map['colors'],
        dateTime = DateFormat.yMMMMd().parse(map['date']);
}
