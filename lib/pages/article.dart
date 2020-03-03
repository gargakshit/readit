import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:readit/models/article.dart';
import 'package:readit/utils/getTextColor.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatefulWidget {
  final ArticleModel article;
  final String heroTag;

  ArticleScreen({@required this.article, @required this.heroTag});

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

Future<Widget> _getContent(ArticleScreen widget, BuildContext context) async {
  await Future.delayed(Duration(milliseconds: 0));

  final html = widget.article.data.content;

  return Html(
    data: html,
    onLinkTap: (url) {
      launch(url);
    },
    defaultTextStyle: TextStyle(
      color: getTextColor(
        MediaQuery.of(context).platformBrightness,
      ),
    ),
    linkStyle: TextStyle(
      color: getTextColor(
        MediaQuery.of(context).platformBrightness,
      ),
      decoration: TextDecoration.underline,
    ),
  );
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.all(0),
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 320,
                child: Hero(
                  tag: widget.heroTag,
                  child: SizedBox(
                    height: 320,
                    child: CachedNetworkImage(
                      imageUrl: widget.article.data.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.article.data.title,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: getTextColor(
                          MediaQuery.of(context).platformBrightness,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.article.data.author,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: getTextColor(
                              MediaQuery.of(context).platformBrightness,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          "${(widget.article.data.ttr / 60).ceil()} min read",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.white60
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.white60
                                : Colors.black54,
                            width: 0.4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    FutureBuilder(
                      future: _getContent(widget, context),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 4.0,
                  ),
                  IconButton(
                    icon: Icon(Feather.arrow_left),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
