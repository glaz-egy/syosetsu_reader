import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';

class BookList {
  List<BookData> bookData = [];

  Future<void> getBookData(uri) async {
    debugPrint(uri);

    try {
      String ncodeJoin = '';
      dynamic jsonData = await APIUtil.fetchApi(uri);

      jsonData = await APIUtil.fetchApi(
          '${URL.bookUrl}&ncode=${ncodeJoin.toLowerCase()}');
      jsonData.removeAt(0);
      jsonData
          .forEach((json) => bookData.add(BookData.fromJson(json, '', false)));
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
          '${URL.bookUrl}&ncode=${ncodeJoin.toLowerCase()}');
      jsonData.removeAt(0);
      jsonData.forEach((json) => bookData
          .add(BookData.fromJson(json, rankList['${json["ncode"]}']!, true)));
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
          '${URL.bookUrl}&ncode=${ncodeJoin.toLowerCase()}');
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
  List<StoryListData> storyData = [];

  Future<void> getNovelTop(url, int storyLength) async {
    debugPrint(url);

    try {
      storyData = await ScrapUtil.getStoryList(url, storyLength);
    } catch (e) {
      debugPrint('Novel: ${e.toString()}');
      rethrow;
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
