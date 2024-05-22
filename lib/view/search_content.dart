import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syosetsu_reader/infrastracture/database.dart';
import 'package:syosetsu_reader/model/api_model.dart';
import 'package:syosetsu_reader/model/db_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRankingView extends ConsumerWidget {
  final int typeId;
  late DatabaseConnection dataBaseConnectionProviderNotifier;

  SearchRankingView({super.key, required this.typeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    return Scaffold(
      body: FutureBuilder(
          future: BookList.getRanking(getRankingURL()),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.error != null) {
              return const Center(child: Text('エラーがおきました'));
            }

            return ListView.builder(
              itemCount: BookList.bookData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      importBook(BookList.bookData[index]);
                    },
                    title: Text(
                      '${BookList.bookData[index].rank}位 ${BookList.bookData[index].title}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(BookList.bookData[index].author));
              },
            );
          }),
    );
  }

  importBook(BookData bookData) {
    List<String> existNcode = dataBaseConnectionProviderNotifier.ncodeList;
    debugPrint(existNcode.contains(bookData.ncode).toString());
    if (!existNcode.contains(bookData.ncode)) {
      DateTime now = DateTime.now();
      debugPrint(bookData.create_date);
      Book book = Book(
          ncode: bookData.ncode,
          title: bookData.title,
          author: bookData.author,
          is_download: false,
          novel_create_date: DateTime.parse(bookData.create_date),
          novel_update_date: DateTime.parse(bookData.update_date),
          create_date: now,
          update_date: now);
      dataBaseConnectionProviderNotifier.insertBook(book);
    }
  }

  String getRankingURL() {
    String result;
    switch (typeId) {
      case 1:
        result = BookList.dayRankingURL();
        break;
      case 2:
        result = BookList.weekRankingURL();
        break;
      case 3:
        result = BookList.monthRankingURL();
        break;
      case 4:
        result = BookList.quoteRankingURL();
        break;
      case 5:
        result = BookList.dayRankingURL();
        break;
      case 6:
        result = BookList.dayRankingURL();
        break;
      default:
        result = BookList.dayRankingURL();
        break;
    }
    return result;
  }
}

class BookList {
  static const String rankingUrl =
      'https://api.syosetu.com/rank/rankget/?out=json';
  static const String bookUrl =
      'https://api.syosetu.com/novelapi/api/?of=n-t-w-ga-nu-gf&out=json&lim=300';
  static List<BookData> bookData = [];

  static Future<void> getRanking(uri) async {
    debugPrint(uri);
    bookData.clear();
    final rankResponse = await http.get(Uri.parse(uri));
    Map<String, String> rankList = {};

    if (rankResponse.statusCode == 200) {
      final parsed1 = jsonDecode(rankResponse.body);
      String ncodeJoin = parsed1.map((json) => json["ncode"]).join('-');

      parsed1
          .forEach((json) => rankList['${json["ncode"]}'] = '${json["rank"]}');
      final bookResponse = await http
          .get(Uri.parse('$bookUrl&ncode=${ncodeJoin.toLowerCase()}'));

      if (bookResponse.statusCode == 200) {
        final parsed2 = jsonDecode(bookResponse.body);
        parsed2.removeAt(0);
        parsed2.forEach((json) => bookData
            .add(BookData.fromJson(json, rankList['${json["ncode"]}']!)));

        bookData.sort((a, b) => int.parse(a.rank).compareTo(int.parse(b.rank)));
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static String dayRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMMdd').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-d';
  }

  static String weekRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMMdd').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-w';
  }

  static String monthRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMM01').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-m';
  }

  static String quoteRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMM01').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-q';
  }
}
