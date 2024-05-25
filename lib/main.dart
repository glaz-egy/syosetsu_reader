import 'package:flutter/material.dart';
import 'package:syosetsu_reader/importer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小説リーダー',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'NotoSansJP'),
      home: const MainWidget(),
    );
  }
}

class MainWidget extends ConsumerStatefulWidget {
  const MainWidget({super.key});

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends ConsumerState<MainWidget> {
  final _screens = [BookshelfView(), SearchView()];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataBaseConnectionProviderNotifier =
        ref.watch(databaseConnectionProvider.notifier);
    return Scaffold(
        body: FutureBuilder(
            future: dataBaseConnectionProviderNotifier.build(),
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
              return _screens[_selectedIndex];
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.book), label: '本棚'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
