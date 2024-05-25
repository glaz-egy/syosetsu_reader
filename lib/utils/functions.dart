import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

class GetUrl {
  static String dayRankingURL() {
    return '${URL.scrapingRankingUrl}/daily_total';
  }

  static String weekRankingURL() {
    return '${URL.scrapingRankingUrl}/weekly_total';
  }

  static String monthRankingURL() {
    return '${URL.scrapingRankingUrl}/monthly_total';
  }

  static String quoteRankingURL() {
    return '${URL.scrapingRankingUrl}/quarter_total';
  }

  static String yearRankingURL() {
    return '${URL.scrapingRankingUrl}/yearly_total';
  }

  static String totalRankingURL() {
    return '${URL.scrapingRankingUrl}/total_total';
  }
}

class APIUtil {
  static dynamic fetchApi(String uri) async {
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw HttpException('Failed access', uri: Uri.parse(uri));
    }
  }
}

class ScrapUtil {
  static dynamic getRanking(String url) async {
    try {
      final controller = WindowController();
      const String rankingListItemSelector = 'div.p-ranklist-item__column';
      const String rankNumSelector = 'div.p-ranklist-item__place > span';
      const String ncodeSelector = 'div.p-ranklist-item__title';
      List<RankData> rankList = [];

      for (int i = 1; i <= 6; i++) {
        controller.defaultHttpClient.userAgent =
            'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0';
        await controller.openHttp(uri: Uri.parse('$url/?p=$i'));
        ElementList rankingListItem = controller.window.document
            .querySelectorAll(rankingListItemSelector);
        for (final element in rankingListItem) {
          String? rankNum = element.querySelector(rankNumSelector)!.text;
          String? ncode = element
              .querySelector(ncodeSelector)
              ?.querySelector('> a')
              ?.attributes['href']!
              .replaceAll('https://ncode.syosetu.com/', '')
              .replaceAll('/', '');

          rankList.add(RankData(ncode!, int.parse(rankNum!)));
        }
      }
      return rankList;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static dynamic getStoryList(String url, int storyLength) async {
    try {
      final controller = WindowController();
      const String storyTitle = 'dd.subtitle > a';
      RegExp matchText = RegExp(r'/\d+/');
      List<StoryListData> storyList = [];

      int pageLenght = (storyLength / 100).ceil();
      debugPrint('$storyLength');

      for (int i = 1; i <= pageLenght; i++) {
        controller.defaultHttpClient.userAgent =
            'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0';
        await controller.openHttp(uri: Uri.parse('$url/?p=$i'));
        ElementList storyListItem =
            controller.window.document.querySelectorAll(storyTitle);
        for (final element in storyListItem) {
          String? title = element.text?.trim();
          String? storyNumber = matchText
              .firstMatch(element.attributes['href']!)![0]
              ?.replaceAll('/', '');
          debugPrint(storyNumber);
          storyList.add(StoryListData(title!, storyNumber!));
        }
      }
      return storyList;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}