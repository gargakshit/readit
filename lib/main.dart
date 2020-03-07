import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readit/app.dart' as Readit;
import 'package:readit/stores/articleStore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ArticleStore>(create: (_) => ArticleStore()),
      ],
      child: Readit.App(),
    );
  }
}
