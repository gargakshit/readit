import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:readit/models/article.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatefulWidget {
  final ArticleModel article;
  final String imgTag;

  ArticleScreen({
    @required this.article,
    @required this.imgTag,
  });

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool dark = false;
  Color color = Colors.black;

  @override
  void initState() {
    super.initState();

    initPrefs();
  }

  initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool d = prefs.getBool("articleDark") ?? false;

    setState(() {
      dark = d;

      color = !dark ? Colors.black : Color(0xffF8F8F8).withOpacity(0.9);
    });
  }

  toggleDarkMode() async {
    setState(() {
      dark = !dark;

      color = !dark ? Colors.black : Color(0xffF8F8F8).withOpacity(0.9);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("articleDark", dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Ionicons.ios_arrow_round_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.white.withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.article.data.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(!dark ? Feather.moon : Feather.sun),
                        onPressed: () {
                          toggleDarkMode();
                        },
                        color: Colors.white.withOpacity(0.9),
                      ),
                      IconButton(
                        icon: Icon(Ionicons.ios_share),
                        onPressed: () {
                          Share.share(
                            "${widget.article.data.title}\n\n${widget.article.data.url}\n\nShared using readit.",
                          );
                        },
                        color: Colors.white.withOpacity(0.9),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: AnimatedContainer(
              height: MediaQuery.of(context).size.height -
                  64 -
                  MediaQuery.of(context).padding.bottom,
              color: !dark ? Color(0xffF8F8F8) : Color(0xff212121),
              duration: Duration(milliseconds: 400),
              child: ListView(
                padding: EdgeInsets.all(0),
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  Hero(
                    tag: widget.imgTag,
                    child: CachedNetworkImage(
                      imageUrl: widget.article.data.image,
                      fit: BoxFit.cover,
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
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              widget.article.data.author,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: color,
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
                                color: !dark
                                    ? Colors.black
                                    : Color(0xffF8F8F8).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                                width: 0.4,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Html(
                          data: widget.article.data.content,
                          onLinkTap: (url) {
                            launch(url);
                          },
                          defaultTextStyle: TextStyle(
                            color: color,
                          ),
                          linkStyle: TextStyle(
                            color: color,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
