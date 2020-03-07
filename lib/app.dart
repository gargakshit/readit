import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readit/pages/ui.dart';
import 'package:readit/stores/articleStore.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ArticleStore>(context).getSavedArticles();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'readit',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        accentColor: Color(0xffF25F5C),
      ),
      home: UIPage(),
    );
  }
}
