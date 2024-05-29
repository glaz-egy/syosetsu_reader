import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryListView extends ConsumerStatefulWidget {
  final String ncode, title;
  StoryListView({super.key, required this.ncode, required this.title});

  @override
  StoryListViewState createState() => StoryListViewState();
}

class StoryListViewState extends ConsumerState<StoryListView> {
  String ncode = '';
  String title = '';
  late DatabaseConnection dbNotifier;

  List<Widget> addBookshelfButton = [];

  @override
  Widget build(BuildContext context) {
    ncode = widget.ncode;
    title = widget.title;
    dbNotifier = ref.watch(databaseConnectionProvider.notifier);
    Novel novelData = Novel(ncode: ncode);
    if (!dbNotifier.isExistNcode(ncode)) {
      setState(() {
        addBookshelfButton = [
          ElevatedButton.icon(
            label: const Text('本棚に追加'),
            icon: const Icon(Icons.book),
            onPressed: () {
              importBook(ncode);
              setState(() {
                addBookshelfButton = [];
              });
            },
          ),
        ];
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(title),
      ),
      persistentFooterButtons: addBookshelfButton,
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
                            builder: (BuildContext context) =>
                                StoryView(title, 1, index, novelData)),
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

    List<String> existNcode = dbNotifier.ncodeList;
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
      dbNotifier.insertBook(book);
    }
  }
}

class StoryView extends ConsumerStatefulWidget {
  final String novelTitle;
  final Novel novel;
  final int novelType;
  final int index;
  StoryView(this.novelTitle, this.novelType, this.index, this.novel,
      {super.key});

  @override
  StoryViewState createState() => StoryViewState();
}

class StoryViewState extends ConsumerState<StoryView> {
  String novelTitle = '';
  late Novel novel;
  int novelType = 0;
  int index = 0;
  String title = '';

  late DatabaseConnection dbNotifier;
  List<Widget> bottomButton = [];

  @override
  Widget build(BuildContext context) {
    novelTitle = widget.novelTitle;
    novel = widget.novel;
    novelType = widget.novelType;
    index = widget.index;

    dbNotifier = ref.watch(databaseConnectionProvider.notifier);
    debugPrint('index: $index, storyLength: ${novel.storyLength}');

    Widget previousStoryButton = ElevatedButton.icon(
        label: const Text('前話へ'),
        icon: const Icon(Icons.arrow_left),
        onPressed: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          StoryView(novelTitle, 2, index - 1, novel)))
            });
    Widget nextStoryButton = ElevatedButton.icon(
        label: const Text('次話へ'),
        icon: const Icon(Icons.arrow_right),
        iconAlignment: IconAlignment.end,
        onPressed: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          StoryView(novelTitle, 2, index + 1, novel)))
            });

    if (novelType == 2) {
      title = novelTitle;
    } else {
      title = novel.storyListData[index].title;
    }
    if (novelType == 2) {
      if (!dbNotifier.isExistNcode(novel.ncode)) {
        setState(() {
          bottomButton = [
            ElevatedButton.icon(
              label: const Text('本棚に追加'),
              icon: const Icon(Icons.book),
              onPressed: () {
                importBook(novel.ncode);
                setState(() {
                  bottomButton = [];
                });
              },
            ),
          ];
        });
      }
    } else {
      setState(() {
        if (index == 0) {
          bottomButton = [nextStoryButton];
        } else if (novel.storyLength > (index + 1)) {
          bottomButton = [previousStoryButton, nextStoryButton];
        } else {
          bottomButton = [previousStoryButton];
        }
      });
    }

    InAppWebViewSettings setting =
        InAppWebViewSettings(disableVerticalScroll: true);
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

            return NotificationListener<OverscrollIndicatorNotification>(
              child: InAppWebView(
                  onWebViewCreated: (InAppWebViewController webViewController) {
                    // JavaScriptハンドラを追加
                    webViewController.addJavaScriptHandler(
                      handlerName: 'getPageLength',
                      callback: _getPageLengthHandler,
                    );
                  },
                  onScrollChanged: (controller, x, y) {
                    debugPrint('(x, y) => ($x, $y)');
                  },
                  initialSettings: setting,
                  initialData: InAppWebViewInitialData(data: '''
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style type"text/css">
                        body{
                          max-height: 100vh;
                          column-count: 1;
                          margin-right: 10%;
                          margin-left: 10%;
                          direction: rtl;
                          overflow-x: scroll;
                          overflow-y: hidden;
                          writing-mode:tb-rl;
                        }
                        body *{ font-family: serif;}
                        p{ margin: 0px; line-height: 2em; }
                        .section{ margin-top: 2em; margin-bottom: 2em;}
                        .author{ text-align:right; }

                        .story{
                          direction:ltr;
                        }
                        </style>
                        <body>
                        <div class="story">
                        ${novel.storyData["${(novel.storyLength == 0 || novel.storyLength == 1) ? index : index + 1}"]!}
                        </div>
                        </body>
                        <script type="text/javascript">
                          const aryMax = function (a, b) {return Math.max(a, b);}
                          function getPageLength(){
                            const pList = document.querySelectorAll('p, div, img, span');
                            console.log(pList.length);
                            const heightArray = [];
                            var count = 0;
                            for (var i = 0; i < pList.length; i++){
                                const elementScrollTop = pList[i].clientWidth;
                                if (elementScrollTop == null) { continue; }

                                if (heightArray.length == 0){
                                    heightArray.push(elementScrollTop);
                                }else if (heightArray[count] != elementScrollTop){
                                    heightArray.push(elementScrollTop);
                                    count++;
                                }
                            }
                            console.log(heightArray);
                            window.scrollTo(700, 0);
                            window.flutter_inappwebview.callHandler("getPageLength", window.innerWidth, Math.max.apply(null, heightArray));
                          }
                          getPageLength();
                        </script>
                        ''')),
              onNotification: (notification) {
                debugPrint('over');
                return true;
              },
            );
          }),
    );
  }

  _getPageLengthHandler(List<dynamic> args) {
    debugPrint('handler json data:${args.toString()}');
  }

  String htmlToURI(String code) {
    return Uri.dataFromString(code,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

  importBook(String ncode) async {
    BookData bookData = await APIUtil.getBookData(
        '${URL.bookUrl}&ncode=${ncode.toLowerCase()}');

    List<String> existNcode = dbNotifier.ncodeList;
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
      dbNotifier.insertBook(book);
    }
  }
}
