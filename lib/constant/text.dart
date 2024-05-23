class InfomationText {
  static const String searchWord = '検索単語';
  static const String exclusionWord = '検索除外単語';
  static const String searchBiggenre = '大ジャンル指定';
  static const String searchGenre = 'ジャンル指定';
}

class Biggenre {
  static const Map<String, String> love = {'name': '恋愛', 'code': '1'};
  static const Map<String, String> fantasy = {'name': 'ファンタジー', 'code': '2'};
  static const Map<String, String> literature = {'name': '文芸', 'code': '3'};
  static const Map<String, String> sciencefantasy = {'name': 'SF', 'code': '4'};
  static const Map<String, String> other = {'name': 'その他', 'code': '99'};
  static const Map<String, String> nongenre = {'name': 'ノンジャンル', 'code': '98'};
}

class Genre {
  static const Map<String, String> loveAnotherWorld = {
    'name': '異世界〔恋愛〕',
    'code': '101'
  };
  static const Map<String, String> loveRealWorld = {
    'name': '現実世界〔恋愛〕',
    'code': '102'
  };
  static const Map<String, String> fantasyHighfantasy = {
    'name': 'ハイファンタジー〔ファンタジー〕',
    'code': '201'
  };
  static const Map<String, String> fantasyLowfantasy = {
    'name': 'ローファンタジー〔ファンタジー〕',
    'code': '202'
  };
  static const Map<String, String> literaturePureliterature = {
    'name': '純文学〔文芸〕',
    'code': '301'
  };
  static const Map<String, String> literatureHumandrama = {
    'name': 'ヒューマンドラマ〔文芸〕',
    'code': '302'
  };
  static const Map<String, String> literatureHistory = {
    'name': '歴史〔文芸〕',
    'code': '303'
  };
  static const Map<String, String> literatureMistery = {
    'name': '推理〔文芸〕',
    'code': '304'
  };
  static const Map<String, String> literatureHorror = {
    'name': 'ホラー〔文芸〕',
    'code': '305'
  };
  static const Map<String, String> literatureAction = {
    'name': 'アクション〔文芸〕',
    'code': '306'
  };
  static const Map<String, String> literatureComedy = {
    'name': 'コメディー〔文芸〕',
    'code': '307'
  };
  static const Map<String, String> sfVrgame = {
    'name': 'VRゲーム〔SF〕',
    'code': '401'
  };
  static const Map<String, String> sfSpace = {'name': '宇宙〔SF〕', 'code': '402'};
  static const Map<String, String> sfFantasyscience = {
    'name': '空想科学〔SF〕',
    'code': '403'
  };
  static const Map<String, String> sfPanic = {
    'name': 'パニック〔SF〕',
    'code': '404'
  };
  static const Map<String, String> otherFairytale = {
    'name': '童話〔その他〕',
    'code': '9901'
  };
  static const Map<String, String> otherPoem = {
    'name': '詩〔その他〕',
    'code': '9902'
  };
  static const Map<String, String> otherEssay = {
    'name': 'エッセイ〔その他〕',
    'code': '9903'
  };
  static const Map<String, String> otherReplay = {
    'name': 'リプレイ〔その他〕',
    'code': '9904'
  };
  static const Map<String, String> other = {'name': 'その他〔その他〕', 'code': '9999'};
  static const Map<String, String> nongenre = {
    'name': 'ノンジャンル〔ノンジャンル〕',
    'code': '9801'
  };
}

class ErrorText {
  static String defaultError() {
    return 'エラーが発生しました';
  }
}
