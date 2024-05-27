// Bookテーブル定義
class Book {
  final int? id;
  final String ncode;
  final String title;
  final String author;
  final int novelType;
  bool is_download;
  DateTime novel_create_date;
  DateTime novel_update_date;
  DateTime create_date;
  DateTime update_date;

  Book(
      {this.id,
      required this.ncode,
      required this.title,
      required this.author,
      required this.novelType,
      required this.is_download,
      required this.novel_create_date,
      required this.novel_update_date,
      required this.create_date,
      required this.update_date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ncode': ncode,
      'title': title,
      'author': author,
      'novelType': novelType,
      'is_download': is_download,
      'create_date': create_date,
      'update_date': update_date
    };
  }
}

class Story {}

class Bookmark {}
