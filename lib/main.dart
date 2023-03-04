import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

// MyApp 関数を実行する
void main() {
  runApp(MyApp());
}

// StatelessWidget classによって拡張される
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          // アプリ全体で使用する色
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// 状態を定義する ChangeNotifier classを継承する
class MyAppState extends ChangeNotifier {
  // ランダムな単語のペアを持つ変数 current
  var current = WordPair.random();
  // お気に入り単語をListで保存する
  var favotites = <WordPair>[];

  // getter関数を定義してみる
  void getNext() {
    current = WordPair.random();
    // 監視している全ての人に通知されるように notifyListeners methodも読んでおく
    notifyListeners();
  }

  // お気に入りに追加する or 削除する
  void toggleFavorite(){
    if(favotites.contains(current)){
      favotites.remove(current);
    }else{
      favotites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        // 未完成部分を表すのに必要なオブジェクト Placeholder
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // 水平方向に配置する safeArea Expanded
          body: Row(
            children: [
              // その子の要素が、status barなどで隠れることを防ぐ
              SafeArea(
                child: NavigationRail(
                  // trueにするとlabelがアイコン横に表示される
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  // navigation railが一つを選択したときに走る
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              // expandedを指定することで残り全部のスペースを覆い尽くす
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  // ウィジェットが最新の状態になるように更新する
  Widget build(BuildContext context) {
    // watcgを用いて、現在のアプリの変更を追跡する
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if(appState.favotites.contains(pair)){
      icon = Icons.favorite;
    }else{
      icon = Icons.favorite_border;
    }
    // buildメソッドは ウィジェットまたは、ウィジェットにネストされたツリーを返す必要がある
    // Scaffoldはトップレベルのウィジェット
    
      // Columnは レイアウトウィジェットの一つ　列は視覚的にその子を一番上に配置する
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // appStateのcurrentにアクセスしている
            BigCard(pair: pair),
            SizedBox(height: 10),
            // 末尾に, を多用しているが　必要ないものもまああったほうがいい
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(onPressed: (){
                  appState.toggleFavorite();
                },
                icon: Icon(icon), 
                label: Text('Like') 
                ),
                SizedBox(width: 10,),

                ElevatedButton(onPressed: (){
                  appState.getNext();
                },
                child: Text('Next'),
                ),
              ],
            )
          ],
        ),
      );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // 現在のthemeをリクエストする
    var theme = Theme.of(context);

    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.w600
    );
    // card widgetでwrapする
    return Card(
      elevation: 10,
      color: theme.colorScheme.secondary,
      // padding widgetでwrapする
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asPascalCase, style: style,),
      ),
    );
  }
}
