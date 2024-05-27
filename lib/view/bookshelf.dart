import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookshelfView extends ConsumerWidget {
  BookshelfView({super.key});
  List<Book> book = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    return Scaffold(
      body: FutureBuilder(
          future: dataBaseConnectionProviderNotifier.getBooks(),
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
              itemCount: dataBaseConnectionProviderNotifier.books.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      final Novel novel = Novel(
                          ncode: dataBaseConnectionProviderNotifier
                              .books[index].ncode);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                dataBaseConnectionProviderNotifier
                                            .books[index].novelType ==
                                        1
                                    ? StoryListView(
                                        ncode:
                                            dataBaseConnectionProviderNotifier
                                                .books[index].ncode,
                                        title:
                                            dataBaseConnectionProviderNotifier
                                                .books[index].title)
                                    : StoryView(
                                        novelTitle:
                                            dataBaseConnectionProviderNotifier
                                                .books[index].title,
                                        novel: novel,
                                        index: 0)),
                      );
                    },
                    title: Text(
                      dataBaseConnectionProviderNotifier.books[index].title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${dataBaseConnectionProviderNotifier.books[index].author} 更新日:${DateFormat('yyyy年MM月dd日').format(dataBaseConnectionProviderNotifier.books[index].novel_update_date)}'));
              },
            );
          }),
    );
  }
}
