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
                      debugPrint(dataBaseConnectionProviderNotifier
                          .books[index].title);
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
