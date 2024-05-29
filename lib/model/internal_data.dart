import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';

class BookList {
  List<BookData> bookData = [];

  Future<void> getBookData(uri) async {
    debugPrint(uri);

    try {
      bookData = await APIUtil.getBookData(uri);
    } catch (e) {
      rethrow;
    }
  }
}

class BookListAssignedRanking {
  List<BookData> bookData = [];

  Future<void> getRanking(uri) async {
    debugPrint(uri);

    try {
      Map<String, String> rankList = {};
      String ncodeJoin = '';
      dynamic jsonData = await APIUtil.fetchApi(uri);

      ncodeJoin = jsonData.map((json) => json["ncode"]).join('-');
      jsonData
          .forEach((json) => rankList['${json["ncode"]}'] = '${json["rank"]}');

      jsonData = await APIUtil.fetchApi(
          '${URL.bookUrl}&ncode=${ncodeJoin.toLowerCase()}&lim=300');
      jsonData.removeAt(0);
      jsonData.forEach((json) => bookData.add(BookData.fromJson(
          json, rankList['${json["ncode"].toLowerCase()}']!, true)));
      bookData.sort((a, b) => int.parse(a.rank).compareTo(int.parse(b.rank)));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getRankingScraping(url) async {
    debugPrint(url);
    try {
      Map<String, String> rankList = {};
      String ncodeJoin = '';
      dynamic rankData = await ScrapUtil.getRanking(url);

      ncodeJoin = rankData.map((rank) => rank.ncode).join('-');
      rankData.forEach((rank) => rankList['${rank.ncode}'] = '${rank.rank}');

      dynamic jsonData = await APIUtil.fetchApi(
          '${URL.bookUrl}&ncode=${ncodeJoin.toLowerCase()}&lim=300');
      jsonData.removeAt(0);
      jsonData.forEach((json) => bookData.add(BookData.fromJson(
          json, rankList['${json["ncode"].toLowerCase()}']!, true)));
      bookData.sort((a, b) => int.parse(a.rank).compareTo(int.parse(b.rank)));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

class Novel {
  final String ncode;
  List<StoryListData> storyListData = [];
  Novel({required this.ncode});
  Map<String, String> storyData = {};
  int storyLength = 0;

  Future<void> getNovelTop() async {
    debugPrint(ncode);

    try {
      BookData bookData = await APIUtil.getBookData(
          '${URL.bookUrl}&ncode=${ncode.toLowerCase()}');

      storyLength = bookData.storyLength;
      if (storyLength > 1) {
        storyListData = await ScrapUtil.getStoryList(
            '${URL.novelUrl}/${bookData.ncode}', bookData.storyLength);
      }
    } catch (e) {
      debugPrint('Novel: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> getStory(String storyNumber) async {
    debugPrint(storyNumber);

    try {
      if (storyNumber == '0') {
        storyData['0'] = await ScrapUtil.getStory('${URL.novelUrl}/$ncode');
      } else {
        storyData[storyNumber] =
            await ScrapUtil.getStory('${URL.novelUrl}/$ncode/$storyNumber');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class RankData {
  final int rank;
  final String ncode;

  RankData(this.ncode, this.rank);
}

class StoryListData {
  final String title;
  final String storyNumber;
  StoryListData(this.title, this.storyNumber);
}
