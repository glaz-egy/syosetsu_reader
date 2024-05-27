import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryListView extends ConsumerWidget {
  final String ncode, title;
  late DatabaseConnection dataBaseConnectionProviderNotifier;

  StoryListView({super.key, required this.ncode, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    Novel novelData = Novel(ncode: ncode);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(title),
      ),
      persistentFooterButtons:
          dataBaseConnectionProviderNotifier.ncodeList.contains(ncode)
              ? []
              : [
                  ElevatedButton.icon(
                    label: const Text('本棚に追加'),
                    icon: const Icon(Icons.book),
                    onPressed: () => importBook(ncode),
                  ),
                ],
      body: FutureBuilder(
          future: novelData.getNovelTop(),
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
              itemCount: novelData.storyListData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      debugPrint(novelData.storyListData[index].title);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => StoryView(
                                novelTitle: title,
                                novel: novelData,
                                index: index)),
                      );
                    },
                    title: Text(
                      '${novelData.storyListData[index].storyNumber}: ${novelData.storyListData[index].title}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ));
              },
            );
          }),
    );
  }

  importBook(String ncode) async {
    BookData bookData = await APIUtil.getBookData(
        '${URL.bookUrl}&ncode=${ncode.toLowerCase()}');

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

class StoryView extends ConsumerWidget {
  final String novelTitle;
  final Novel novel;
  final int index;
  late DatabaseConnection dataBaseConnectionProviderNotifier;

  StoryView(
      {super.key,
      required this.novelTitle,
      required this.novel,
      required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    debugPrint('index: $index, storyLength: ${novel.storyLength}');
    List<Widget> bottomButton = [];
    String title = '';
    if (novel.storyLength == 0 || novel.storyLength == 1) {
      title = novelTitle;
    } else {
      title = novel.storyListData[index].title;
    }
    if (novel.storyLength == 0 || novel.storyLength == 1) {
      bottomButton =
          dataBaseConnectionProviderNotifier.ncodeList.contains(novel.ncode)
              ? []
              : [
                  ElevatedButton.icon(
                    label: const Text('本棚に追加'),
                    icon: const Icon(Icons.book),
                    onPressed: () => importBook(novel.ncode),
                  ),
                ];
    } else if (index == 0) {
      bottomButton = [
        ElevatedButton.icon(
          label: const Text('次話へ'),
          icon: const Icon(Icons.arrow_right),
          iconAlignment: IconAlignment.end,
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => StoryView(
                      novelTitle: novelTitle, novel: novel, index: index + 1)),
            ),
          },
        )
      ];
    } else if (novel.storyLength > (index + 1)) {
      bottomButton = [
        ElevatedButton.icon(
            label: const Text('前話へ'),
            icon: const Icon(Icons.arrow_left),
            onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => StoryView(
                              novelTitle: novelTitle,
                              novel: novel,
                              index: index - 1))),
                }),
        ElevatedButton.icon(
          label: const Text('次話へ'),
          icon: const Icon(Icons.arrow_right),
          iconAlignment: IconAlignment.end,
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => StoryView(
                      novelTitle: novelTitle, novel: novel, index: index + 1)),
            ),
          },
        )
      ];
    } else {
      bottomButton = [
        ElevatedButton.icon(
            label: const Text('前話へ'),
            icon: const Icon(Icons.arrow_left),
            onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => StoryView(
                              novelTitle: novelTitle,
                              novel: novel,
                              index: index - 1))),
                })
      ];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(title),
      ),
      persistentFooterButtons: bottomButton,
      body: FutureBuilder(
          future: (novel.storyLength == 0 || novel.storyLength == 1)
              ? novel.getStory('0')
              : novel.getStory('${index + 1}'),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.error != null) {
              return Center(child: Text(ErrorText.defaultError()));
            }

            return InAppWebView(initialData: InAppWebViewInitialData(data: '''
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style type"text/css">
                        body{
                          margin-right: 10%;
                          margin-left: 10%;
                          direction: rtl;
                          overflow-x: scroll;
                          overflow-y:auto;
                        }
                        body *{ font-family: serif; }
                        p{ margin: 0px; line-height: 2em; }
                        .section{ margin-top: 2em; margin-bottom: 2em;}
                        .author{ text-align:right; }

                        .story{
                          writing-mode:tb-rl;
                          direction:ltr;
                        }
                        </style>
                        <body>
                        <div class="story">
                        ${novel.storyData["${(novel.storyLength == 0 || novel.storyLength == 1) ? index : index + 1}"]!}
                        </div>
                        </body>'''));
          }),
    );
  }

  String htmlToURI(String code) {
    return Uri.dataFromString(code,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

  importBook(String ncode) async {
    BookData bookData = await APIUtil.getBookData(
        '${URL.bookUrl}&ncode=${ncode.toLowerCase()}');

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
