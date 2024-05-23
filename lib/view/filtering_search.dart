import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilteringView extends ConsumerStatefulWidget {
  SearchFilteringView({super.key});

  @override
  SearchFilteringViewState createState() => SearchFilteringViewState();
}

class SearchFilteringViewState extends ConsumerState<SearchFilteringView> {
  bool searchLove = false;
  bool searchLoveAnotherWorld = false;
  bool searchLoveRealWorld = false;
  bool searchFantasy = false;
  bool searchFantasyHighfantasy = false;
  bool searchFantasyLowfantasy = false;
  bool searchLiterature = false;
  bool searchLiteraturePureliterature = false;
  bool searchLiteratureHumandrama = false;
  bool searchLiteratureHistory = false;
  bool searchLiteratureMistery = false;
  bool searchLiteratureHorror = false;
  bool searchLiteratureAction = false;
  bool searchLiteratureComedy = false;
  bool searchSciencefantasy = false;
  bool searchSFVrgame = false;
  bool searchSFSpace = false;
  bool searchSFFantasyscience = false;
  bool searchSFPanic = false;
  bool searchOther = false;
  bool searchOtherFairytale = false;
  bool searchOtherPoem = false;
  bool searchOtherEssay = false;
  bool searchOtherReplay = false;
  bool searchOtherOther = false;
  bool searchNongenre = false;
  bool searchR15 = false;
  bool searchBl = false;
  bool searchGl = false;
  bool searchZankoku = false;
  bool searchTensei = false;
  bool searchTenni = false;
  bool searchTt = false;
  bool exclusionR15 = false;
  bool exclusionBl = false;
  bool exclusionGl = false;
  bool exclusionZankoku = false;
  bool exclusionTensei = false;
  bool exclusionTenni = false;
  bool exclusionTt = false;

  @override
  Widget build(BuildContext context) {
    final Container wordContainer = WordContainer();

    return Scaffold(
        body: Column(children: [
      wordContainer,
      Column(
        children: [
          const Text(InfomationText.searchBiggenre,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              _textCheckbox(
                  Biggenre.love['name']!,
                  searchLove,
                  (value) => setState(() {
                        searchLove = value!;
                        searchLoveAnotherWorld = value;
                        searchLoveRealWorld = value;
                      })),
              _textCheckbox(
                  Biggenre.fantasy['name']!,
                  searchFantasy,
                  (value) => setState(() {
                        searchFantasy = value!;
                        searchFantasyHighfantasy = value;
                        searchFantasyLowfantasy = value;
                      })),
              _textCheckbox(
                  Biggenre.literature['name']!,
                  searchLiterature,
                  (value) => setState(() {
                        searchLiterature = value!;
                        searchLiteraturePureliterature = value;
                        searchLiteratureHumandrama = value;
                        searchLiteratureHistory = value;
                        searchLiteratureMistery = value;
                        searchLiteratureHorror = value;
                        searchLiteratureAction = value;
                        searchLiteratureComedy = value;
                      })),
              _textCheckbox(
                  Biggenre.sciencefantasy['name']!,
                  searchSciencefantasy,
                  (value) => setState(() {
                        searchSciencefantasy = value!;
                        searchSFVrgame = value;
                        searchSFSpace = value;
                        searchSFFantasyscience = value;
                        searchSFPanic = value;
                      })),
              _textCheckbox(
                  Biggenre.other['name']!,
                  searchOther,
                  (value) => setState(() {
                        searchOther = value!;
                        searchOtherFairytale = value;
                        searchOtherPoem = value;
                        searchOtherEssay = value;
                        searchOtherReplay = value;
                        searchOtherOther = value;
                      })),
              _textCheckbox(
                  Biggenre.nongenre['name']!,
                  searchNongenre,
                  (value) => setState(() {
                        searchNongenre = value!;
                      })),
            ],
          )
        ],
      ),
      Column(
        children: [
          const Text(InfomationText.searchGenre,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              _textCheckbox(
                  Genre.loveAnotherWorld['name']!,
                  searchLoveAnotherWorld,
                  (value) => setState(() {
                        searchLoveAnotherWorld = value!;
                      })),
              _textCheckbox(
                  Genre.loveRealWorld['name']!,
                  searchLoveRealWorld,
                  (value) => setState(() {
                        searchLoveRealWorld = value!;
                      })),
              _textCheckbox(
                  Genre.fantasyHighfantasy['name']!,
                  searchFantasyHighfantasy,
                  (value) => setState(() {
                        searchFantasyHighfantasy = value!;
                      })),
              _textCheckbox(
                  Genre.fantasyLowfantasy['name']!,
                  searchFantasyLowfantasy,
                  (value) => setState(() {
                        searchFantasyLowfantasy = value!;
                      })),
              _textCheckbox(
                  Genre.literaturePureliterature['name']!,
                  searchLiteraturePureliterature,
                  (value) => setState(() {
                        searchLiteraturePureliterature = value!;
                      })),
              _textCheckbox(
                  Genre.literatureHumandrama['name']!,
                  searchLiteratureHumandrama,
                  (value) => setState(() {
                        searchLiteratureHumandrama = value!;
                      })),
              _textCheckbox(
                  Genre.literatureHistory['name']!,
                  searchLiteratureHistory,
                  (value) => setState(() {
                        searchLiteratureHistory = value!;
                      })),
              _textCheckbox(
                  Genre.literatureMistery['name']!,
                  searchLiteratureMistery,
                  (value) => setState(() {
                        searchLiteratureMistery = value!;
                      })),
              _textCheckbox(
                  Genre.literatureHorror['name']!,
                  searchLiteratureHorror,
                  (value) => setState(() {
                        searchLiteratureHorror = value!;
                      })),
              _textCheckbox(
                  Genre.literatureAction['name']!,
                  searchLiteratureAction,
                  (value) => setState(() {
                        searchLiteratureAction = value!;
                      })),
              _textCheckbox(
                  Genre.literatureComedy['name']!,
                  searchLiteratureComedy,
                  (value) => setState(() {
                        searchLiteratureComedy = value!;
                      })),
              _textCheckbox(
                  Genre.sfVrgame['name']!,
                  searchSFVrgame,
                  (value) => setState(() {
                        searchSFVrgame = value!;
                      })),
              _textCheckbox(
                  Genre.sfSpace['name']!,
                  searchSFSpace,
                  (value) => setState(() {
                        searchSFSpace = value!;
                      })),
              _textCheckbox(
                  Genre.sfFantasyscience['name']!,
                  searchSFFantasyscience,
                  (value) => setState(() {
                        searchSFFantasyscience = value!;
                      })),
              _textCheckbox(
                  Genre.sfPanic['name']!,
                  searchSFPanic,
                  (value) => setState(() {
                        searchSFPanic = value!;
                      })),
              _textCheckbox(
                  Genre.otherFairytale['name']!,
                  searchOtherFairytale,
                  (value) => setState(() {
                        searchOtherFairytale = value!;
                      })),
              _textCheckbox(
                  Genre.otherPoem['name']!,
                  searchOtherPoem,
                  (value) => setState(() {
                        searchOtherPoem = value!;
                      })),
              _textCheckbox(
                  Genre.otherEssay['name']!,
                  searchOtherEssay,
                  (value) => setState(() {
                        searchOtherEssay = value!;
                      })),
              _textCheckbox(
                  Genre.otherReplay['name']!,
                  searchOtherReplay,
                  (value) => setState(() {
                        searchOtherReplay = value!;
                      })),
              _textCheckbox(
                  Genre.other['name']!,
                  searchOtherOther,
                  (value) => setState(() {
                        searchOtherOther = value!;
                      })),
              _textCheckbox(
                  Genre.nongenre['name']!,
                  searchNongenre,
                  (value) => setState(() {
                        searchNongenre = value!;
                      })),
            ],
          )
        ],
      ),
      Column(
        children: [
          const Text(InfomationText.searchLavel,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              _textCheckbox(
                  NovelNarouLavel.r15,
                  searchR15,
                  (value) => setState(() {
                        searchR15 = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.bl,
                  searchBl,
                  (value) => setState(() {
                        searchBl = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.gl,
                  searchGl,
                  (value) => setState(() {
                        searchGl = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.zankoku,
                  searchZankoku,
                  (value) => setState(() {
                        searchZankoku = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.tensei,
                  searchTensei,
                  (value) => setState(() {
                        searchTensei = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.tenni,
                  searchTenni,
                  (value) => setState(() {
                        searchTenni = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.tt,
                  searchTt,
                  (value) => setState(() {
                        searchTt = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
            ],
          )
        ],
      ),
      Column(
        children: [
          const Text(InfomationText.exclusionLavel,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              _textCheckbox(
                  NovelNarouLavel.r15,
                  exclusionR15,
                  (value) => setState(() {
                        exclusionR15 = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.bl,
                  exclusionBl,
                  (value) => setState(() {
                        exclusionBl = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.gl,
                  exclusionGl,
                  (value) => setState(() {
                        exclusionGl = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.zankoku,
                  exclusionZankoku,
                  (value) => setState(() {
                        exclusionZankoku = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.tensei,
                  exclusionTensei,
                  (value) => setState(() {
                        exclusionTensei = value!;
                        if (exclusionR15) {
                          exclusionR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.tenni,
                  exclusionTenni,
                  (value) => setState(() {
                        exclusionTenni = value!;
                        if (searchR15) {
                          searchR15 = false;
                        }
                      })),
              _textCheckbox(
                  NovelNarouLavel.tt,
                  exclusionTt,
                  (value) => setState(() {
                        exclusionTt = value!;
                        if (searchR15) {
                          searchR15 = false;
                        }
                      })),
            ],
          )
        ],
      ),
    ]));
  }

  Widget _textCheckbox(
      String text, bool stateVariable, Function(bool?)? chengeFnc) {
    return SizedBox(
        width: 300,
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
        const Text(InfomationText.searchWord,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        TextFormField(
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
          onSaved: (value) {
            if (value!.isEmpty) {
              searchWord = '';
            } else {
              searchWord = value.trim();
            }
          },
        ),
        TextFormField(
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
          onSaved: (value) {
            if (value!.isEmpty) {
              exclusionWord = '';
            } else {
              exclusionWord = value.trim();
            }
          },
        ),
      ],
    );
  }
}
