import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryListView extends ConsumerWidget {
  final BookData bookData;
  late DatabaseConnection dataBaseConnectionProviderNotifier;

  StoryListView({super.key, required this.bookData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    Novel novelData = Novel();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(bookData.title),
      ),
      body: FutureBuilder(
          future: novelData.getNovelTop(
              '${URL.novelUrl}/${bookData.ncode}', bookData.storyLength),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.error != null) {
              return Center(child: Text(ErrorText.defaultError()));
            }

            return ListView.builder(
              itemCount: novelData.storyData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      debugPrint(novelData.storyData[index].title);
                    },
                    title: Text(
                      '${novelData.storyData[index].storyNumber}: ${novelData.storyData[index].title}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ));
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
      debugPrint(bookData.ncode);
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
}
