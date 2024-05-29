import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookshelfView extends ConsumerWidget {
  BookshelfView({super.key});
  List<Book> book = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbNotifier = ref.watch(databaseConnectionProvider.notifier);
    return Scaffold(
      body: FutureBuilder(
          future: dbNotifier.getBooks(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.error != null) {
              debugPrint(snapshot.error.toString());
              return Center(child: Text(ErrorText.defaultError()));
            }
            return ListView.builder(
              itemCount: dbNotifier.books.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      final Novel novel =
                          Novel(ncode: dbNotifier.books[index].ncode);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                dbNotifier.books[index].novelType == 1
                                    ? StoryListView(
                                        ncode: dbNotifier.books[index].ncode,
                                        title: dbNotifier.books[index].title)
                                    : StoryView(
                                        dbNotifier.books[index].title,
                                        dbNotifier.books[index].novelType,
                                        0,
                                        novel)),
                      );
                    },
                    title: Text(
                      dbNotifier.books[index].title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${dbNotifier.books[index].author} 更新日:${DateFormat('yyyy年MM月dd日').format(dbNotifier.books[index].novel_update_date)}'));
              },
            );
          }),
    );
  }
}
