class InfomationText {
  static const String searchWordTitle = 'ワード指定';
  static const String searchWord = '検索ワード';
  static const String exclusionWord = '除外ワード';
  static const String searchBiggenre = '大ジャンル指定';
  static const String searchGenre = 'ジャンル指定';
  static const String searchLavel = '要素指定';
  static const String exclusionLavel = '要素除外';
}

enum Biggenre {
  love(displayName: '恋愛', genreCode: '1'),
  fantasy(displayName: 'ファンタジー', genreCode: '2'),
  literature(displayName: '文芸', genreCode: '3'),
  sciencefantasy(displayName: 'SF', genreCode: '4'),
  other(displayName: 'その他', genreCode: '99'),
  nongenre(displayName: 'ノンジャンル', genreCode: '98');

  final String displayName;
  final String genreCode;

  const Biggenre({required this.displayName, required this.genreCode});
}

enum Genre {
  loveAnotherWorld(
      displayName: '異世界〔恋愛〕', genreCode: '101', link: Biggenre.love),
  loveRealWorld(displayName: '現実世界〔恋愛〕', genreCode: '102', link: Biggenre.love),
  fantasyHighfantasy(
      displayName: 'ハイファンタジー〔ファンタジー〕',
      genreCode: '201',
      link: Biggenre.fantasy),
  fantasyLowfantasy(
      displayName: 'ローファンタジー〔ファンタジー〕',
      genreCode: '202',
      link: Biggenre.fantasy),
  literaturePureliterature(
      displayName: '純文学〔文芸〕', genreCode: '301', link: Biggenre.literature),
  literatureHumandrama(
      displayName: 'ヒューマンドラマ〔文芸〕', genreCode: '302', link: Biggenre.literature),
  literatureHistory(
      displayName: '歴史〔文芸〕', genreCode: '303', link: Biggenre.literature),
  literatureMistery(
      displayName: '推理〔文芸〕', genreCode: '304', link: Biggenre.literature),
  literatureHorror(
      displayName: 'ホラー〔文芸〕', genreCode: '305', link: Biggenre.literature),
  literatureAction(
      displayName: 'アクション〔文芸〕', genreCode: '306', link: Biggenre.literature),
  literatureComedy(
      displayName: 'コメディー〔文芸〕', genreCode: '307', link: Biggenre.literature),
  sfVrgame(
      displayName: 'VRゲーム〔SF〕',
      genreCode: '401',
      link: Biggenre.sciencefantasy),
  sfSpace(
      displayName: '宇宙〔SF〕', genreCode: '402', link: Biggenre.sciencefantasy),
  sfFantasyscience(
      displayName: '空想科学〔SF〕', genreCode: '403', link: Biggenre.sciencefantasy),
  sfPanic(
      displayName: 'パニック〔SF〕', genreCode: '404', link: Biggenre.sciencefantasy),
  otherFairytale(
      displayName: '童話〔その他〕', genreCode: '9901', link: Biggenre.other),
  otherPoem(displayName: '詩〔その他〕', genreCode: '9902', link: Biggenre.other),
  otherEssay(displayName: 'エッセイ〔その他〕', genreCode: '9903', link: Biggenre.other),
  otherReplay(
      displayName: 'リプレイ〔その他〕', genreCode: '9904', link: Biggenre.other),
  other(displayName: 'その他〔その他〕', genreCode: '9999', link: Biggenre.other),
  nongenre(
      displayName: 'ノンジャンル〔ノンジャンル〕',
      genreCode: '9801',
      link: Biggenre.nongenre);

  final String displayName;
  final String genreCode;
  final Biggenre link;

  const Genre(
      {required this.displayName, required this.genreCode, required this.link});
}

enum NarouLavel {
  r15(displayName: 'R15', paramCode: 'r15'),
  bl(displayName: 'ボーイズラブ', paramCode: 'bl'),
  gl(displayName: 'ガールズラブ', paramCode: 'gl'),
  zankoku(displayName: '残酷な描写あり', paramCode: 'zankoku'),
  tensei(displayName: '異世界転生', paramCode: 'tensei'),
  tenni(displayName: '異世界転移', paramCode: 'tanni'),
  tt(displayName: '異世界(転生|転移)', paramCode: 'tt');

  final String displayName;
  final String paramCode;

  const NarouLavel({required this.displayName, required this.paramCode});
}

class ErrorText {
  static String defaultError() {
    return 'エラーが発生しました';
  }
}
