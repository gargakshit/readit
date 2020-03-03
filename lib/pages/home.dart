import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readit/models/article.dart';
import 'package:readit/utils/getTextColor.dart';
import 'package:readit/widgets/card.dart';
import 'package:readit/widgets/shimmerCard.dart';
import 'package:shimmer/shimmer.dart';
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

    data = (await db.find({}))
        .map((e) => ArticleModel.fromJson(e))
        .toList()
        .reversed
        .toList();

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
      showError = false;
    });

    if (isURL(text)) {
      var path =
          (await getApplicationDocumentsDirectory()).path + "/articles__01.db";
      final db = ObjectDB(path);
      db.open();

      if ((await db.find(
            {"message": "Extracted article from \"$text\""},
          ))
              .length ==
          0) {
        final res = await get(
            "https://us-central1-technews-251304.cloudfunctions.net/article-parser?url=$text");

        if (res.statusCode == 200) {
          var body = jsonDecode(res.body);
          if (body['error'] == 0) {
            db.insert(body);
          } else {
            setState(() {
              showLoading = false;
              showError = true;
            });
          }

          getSavedArticles();
        } else {
          setState(() {
            showLoading = false;
            showError = true;
          });
        }
      } else {
        setState(() {
          showLoading = false;
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
                                child: Text("Paste"),
                                onPressed: () async {
                                  ClipboardData d =
                                      await Clipboard.getData("text/plain");
                                  _textEditingController.text = d.text;
                                },
                              ),
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _textEditingController.text = "";
                                },
                              ),
                              FlatButton(
                                child: Text("Add"),
                                onPressed: () {
                                  addArticle(context);
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
                    ? showLoading
                        ? Container()
                        : Center(
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
                    : ListView.builder(
                        itemCount: data.length + 1,
                        itemBuilder: (context, index) => index == 0
                            ? showLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[400],
                                    highlightColor: Colors.white,
                                    child: ShimmerCard(),
                                  )
                                : Container()
                            : Dismissible(
                                key: Key(data[index - 1].data.url),
                                onDismissed: (direction) async {
                                  var path =
                                      (await getApplicationDocumentsDirectory())
                                              .path +
                                          "/articles__01.db";
                                  final db = ObjectDB(path);
                                  db.open();

                                  await db.remove(
                                    {
                                      "message": data[index - 1].message,
                                    },
                                  );

                                  getSavedArticles();

                                  await db.close();
                                },
                                child: CardComponent(
                                  article: data[index - 1],
                                ),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
