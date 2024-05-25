class BookData {
  final String rank;
  final String ncode;
  final String title;
  final String author;
  final String story;
  final int novelType;
  final int end;
  final String create_date;
  final String update_date;
  final String outputTitle;
  final int storyLength;

  BookData(
      {required this.rank,
      required this.ncode,
      required this.title,
      required this.author,
      required this.story,
      required this.novelType,
      required this.end,
      required this.create_date,
      required this.update_date,
      required this.outputTitle,
      required this.storyLength});

  factory BookData.fromJson(
      Map<String, dynamic> json, String rank, bool isRanking) {
    return BookData(
        ncode: json['ncode'].toLowerCase() as String,
        author: json['writer'] as String,
        title: json['title'] as String,
        story: json['story'] as String,
        novelType: json['noveltype'] as int,
        end: json['end'] as int,
        create_date: json['general_firstup'],
        update_date: json['novelupdated_at'],
        storyLength: json['general_all_no'] as int,
        outputTitle: isRanking ? '$rank位 ${json['title']}' : json['title'],
        rank: rank);
  }
}
