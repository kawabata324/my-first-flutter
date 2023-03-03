import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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

  // getter関数を定義してみる
  void getNext() {
    current = WordPair.random();
    // 監視している全ての人に通知されるように notifyListeners methodも読んでおく
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  // ウィジェットが最新の状態になるように更新する
  Widget build(BuildContext context) {
    // watcgを用いて、現在のアプリの変更を追跡する
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // buildメソッドは ウィジェットまたは、ウィジェットにネストされたツリーを返す必要がある
    // Scaffoldはトップレベルのウィジェット
    return Scaffold(
      // Columnは レイアウトウィジェットの一つ　列は視覚的にその子を一番上に配置する
      body: Column(
        children: [
          // Text ウィジェット
          Text('A random AWESOME idea:'),
          // appStateのcurrentにアクセスしている
          BigCard(pair: pair),
          
          // 末尾に, を多用しているが　必要ないものもまああったほうがいい
          ElevatedButton(onPressed: (){
            appState.getNext();
          },
          child: Text('Next'),
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
    // card widgetでwrapする
    return Card(
      // padding widgetでwrapする
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}
