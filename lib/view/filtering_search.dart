import 'package:syosetsu_reader/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilteringView extends ConsumerStatefulWidget {
  SearchFilteringView({super.key});

  @override
  SearchFilteringViewState createState() => SearchFilteringViewState();
}

class SearchFilteringViewState extends ConsumerState<SearchFilteringView> {
  final WordContainer wordContainer = WordContainer();

  Map<Biggenre, bool> isSearchBiggenre = {
    for (var bigGenre in Biggenre.values) bigGenre: false
  };
  Map<Genre, bool> isSearchGenre = {
    for (var genre in Genre.values) genre: false
  };
  Map<NarouLavel, bool> isSearchNarouLavel = {
    for (var lavel in NarouLavel.values) lavel: false
  };

  Map<NarouLavel, bool> isExclusionNarouLavel = {
    for (var lavel in NarouLavel.values) lavel: false
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('検索条件'),
        ),
        body: SingleChildScrollView(
            child: (Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(children: [
                  wordContainer,
                  _buildSection(InfomationText.searchBiggenre,
                      _buildCheckboxList(Biggenre.values, isSearchBiggenre)),
                  _buildSection(
                      InfomationText.searchGenre,
                      _buildLinkCheckboxList(
                          isExistLink: true,
                          Genre.values,
                          isSearchGenre,
                          isSearchBiggenre,
                          [false, true])),
                  _buildSection(
                      InfomationText.searchLavel,
                      _buildLinkCheckboxList(
                          NarouLavel.values,
                          isSearchNarouLavel,
                          isExclusionNarouLavel,
                          [true, false])),
                  _buildSection(
                      InfomationText.exclusionLavel,
                      _buildLinkCheckboxList(
                          NarouLavel.values,
                          isExclusionNarouLavel,
                          isSearchNarouLavel,
                          [true, false])),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.tag_faces,
                      color: Colors.black,
                    ),
                    label: const Text('検索'),
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () {
                      String param = createSearchURI();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SearchResultView(url: '${URL.bookUrl}&$param')));
                    },
                  ),
                ])))));
  }

  Widget _buildSection(String titleKey, Widget content) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Text(
          titleKey,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        content,
      ],
    );
  }

  Widget _buildCheckboxList(
      List<dynamic> values, Map<dynamic, bool> selectedValues) {
    return Wrap(
      children: values.map<Widget>((value) {
        return _textCheckbox(value.displayName, selectedValues[value]!,
            (newValue) {
          setState(() {
            selectedValues[value] = newValue!;
          });
        });
      }).toList(),
    );
  }

  Widget _buildLinkCheckboxList(List<dynamic> values,
      Map<dynamic, bool> selectedValues, linkedValues, List<bool> linkState,
      {bool isExistLink = false}) {
    return Wrap(
      children: values.map<Widget>((value) {
        return _textCheckbox(value.displayName, selectedValues[value]!,
            (newValue) {
          setState(() {
            selectedValues[value] = newValue!;
            debugPrint(isExistLink.toString());
            dynamic link = isExistLink ? value.link : value;
            if (linkedValues[link] == linkState[0]) {
              linkedValues[link] = linkState[1];
            }
          });
        });
      }).toList(),
    );
  }

  String createSearchURI() {
    List<String> param = [];
    List<String> biggenreParam = [];
    List<String> genreParam = [];

    if (wordContainer.searchWord != '') {
      param.add('word=${wordContainer.searchWord}');
    }
    if (wordContainer.exclusionWord != '') {
      param.add('notword=${wordContainer.exclusionWord}');
    }
    isSearchBiggenre.forEach((Biggenre biggenre, bool isSearch) {
      if (isSearch) {
        biggenreParam.add(biggenre.genreCode);
      }
    });
    if (biggenreParam.isEmpty) {
      param.add('biggenre=0');
    } else {
      param.add('biggenre=${biggenreParam.join("-")}');
    }
    isSearchGenre.forEach((Genre genre, bool isSearch) {
      if (isSearch) {
        genreParam.add(genre.genreCode);
      }
    });
    if (genreParam.isEmpty) {
      param.add('genre=0');
    } else {
      param.add('genre=${genreParam.join("-")}');
    }
    isSearchNarouLavel.forEach((NarouLavel lavel, bool isSearch) {
      if (isSearch) {
        param.add('is${lavel.paramCode}=1');
      }
    });
    isExclusionNarouLavel.forEach((NarouLavel lavel, bool isSearch) {
      if (isSearch) {
        param.add('not${lavel.paramCode}=1');
      }
    });
    debugPrint(param.join('&'));
    return param.join('&');
  }

  Widget _textCheckbox(
      String text, bool stateVariable, Function(bool?)? chengeFnc) {
    return SizedBox(
        width: 200,
        child: Row(children: [
          Checkbox.adaptive(value: stateVariable, onChanged: chengeFnc),
          Flexible(child: Text(text))
        ]));
  }
}

class WordContainer extends Container {
  @override
  late Widget child;
  String searchWord = '';
  String exclusionWord = '';

  WordContainer({super.key}) {
    child = Column(
      children: [
        const Text(InfomationText.searchWordTitle,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    width: 2.0,
                  ),
                ),
                labelStyle: const TextStyle(
                  fontSize: 12,
                ),
                labelText: InfomationText.searchWord,
                floatingLabelStyle: const TextStyle(fontSize: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.green[100]!,
                    width: 1.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  searchWord = '';
                } else {
                  searchWord = value.trim();
                }
              },
            )),
        Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    width: 2.0,
                  ),
                ),
                labelStyle: const TextStyle(
                  fontSize: 12,
                ),
                labelText: InfomationText.exclusionWord,
                floatingLabelStyle: const TextStyle(fontSize: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.green[100]!,
                    width: 1.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  exclusionWord = '';
                } else {
                  exclusionWord = value.trim();
                }
              },
            )),
      ],
    );
  }
}
