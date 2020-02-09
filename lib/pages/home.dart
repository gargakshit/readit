import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readit/models/article.dart';
import 'package:readit/utils/getTextColor.dart';
import 'package:readit/widgets/card.dart';
import 'package:validators/validators.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textEditingController = TextEditingController();
  List<ArticleModel> data = [];

  bool showLoading = true;
  bool showError = false;

  @override
  void initState() {
    super.initState();

    getSavedArticles();
  }

  getSavedArticles() async {
    final db = ObjectDB(
        (await getApplicationDocumentsDirectory()).path + "/articles__01.db");
    db.open();

    data = (await db.find({})).map((e) => ArticleModel.fromJson(e)).toList();

    setState(() {
      showLoading = false;
    });
    await db.close();
  }

  addArticle(BuildContext context) async {
    final text = _textEditingController.text;
    _textEditingController.text = "";

    setState(() {
      showLoading = true;
    });

    if (isURL(text)) {
      final db = ObjectDB(
          (await getApplicationDocumentsDirectory()).path + "/articles__01.db");
      db.open();

      final res = await get(
          "https://us-central1-technews-251304.cloudfunctions.net/article-parser?url=$text");

      if (res.statusCode == 200) {
        print(res.body);
        db.insert(jsonDecode(res.body));

        getSavedArticles();
      } else {
        setState(() {
          showLoading = false;
          showError = true;
        });
      }

      await db.close();
    } else {
      setState(() {
        showLoading = false;
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 32,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "read",
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(
                          MediaQuery.of(context).platformBrightness),
                    ),
                  ),
                  Text(
                    "it.",
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF25F5C),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  showError ? Icon(Feather.alert_circle) : Container(),
                  showLoading
                      ? SizedBox(
                          width: 28,
                        )
                      : Container(),
                  showLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(),
                          width: 28,
                          height: 28,
                        )
                      : Container(),
                  SizedBox(
                    width: 28,
                  ),
                  InkWell(
                    child: GestureDetector(
                      child: Icon(Feather.plus),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              "Add a new article",
                              style: TextStyle(
                                color: getTextColor(
                                    MediaQuery.of(context).platformBrightness),
                              ),
                            ),
                            content: TextField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                hintText: "URL of the article...",
                              ),
                              style: TextStyle(
                                color: getTextColor(
                                  MediaQuery.of(context).platformBrightness,
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Add"),
                                onPressed: () {
                                  addArticle(context);
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: data.length == 0
                    ? !showLoading
                        ? Center(
                            child: Text(
                              "Please add a new article first!",
                              style: TextStyle(
                                color: getTextColor(
                                  MediaQuery.of(context).platformBrightness,
                                ),
                                fontSize: 18.0,
                              ),
                            ),
                          )
                        : Container()
                    : ListView(
                        children: data
                            .map(
                              (e) => CardComponent(
                                article: e,
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
