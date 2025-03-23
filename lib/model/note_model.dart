class NoteModel {
  int? id;
  String? title;
  String? body;

  NoteModel({this.title, this.id, this.body});

  Map<String, dynamic> toMap({bool isAdd = true}) {
    return {
      if (!isAdd) 'id': id,
      'title': title,
      'body': body,
    };
  }

  NoteModel.fronMap({required Map<String, dynamic> map})
      : id = map['id'],
        body = map['body'],
        title = map['title'];
}
