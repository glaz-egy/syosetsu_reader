import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultView extends ConsumerWidget {
  final String url;
  late DatabaseConnection dataBaseConnectionProviderNotifier;

  SearchResultView({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    BookList bookList = BookList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('検索結果'),
      ),
      body: FutureBuilder(
          future: bookList.getBookData(url),
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
              itemCount: bookList.bookData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      final Novel novel =
                          Novel(ncode: bookList.bookData[index].ncode);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                bookList.bookData[index].novelType == 1
                                    ? StoryListView(
                                        ncode: bookList.bookData[index].ncode,
                                        title: bookList.bookData[index].title)
                                    : StoryView(
                                        novelTitle:
                                            bookList.bookData[index].title,
                                        novel: novel,
                                        index: 1)),
                      );
                    },
                    title: Text(
                      bookList.bookData[index].outputTitle,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${bookList.bookData[index].author}\n${bookList.bookData[index].end == 0 ? '完結済み' : '連載中'} 全${bookList.bookData[index].storyLength}話'));
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
          novelType: bookData.novelType,
          is_download: false,
          novel_create_date: DateTime.parse(bookData.create_date),
          novel_update_date: DateTime.parse(bookData.update_date),
          create_date: now,
          update_date: now);
      dataBaseConnectionProviderNotifier.insertBook(book);
    }
  }
}
