import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:readit/pages/home.dart';
import 'package:readit/stores/articleStore.dart';

class UIPage extends StatefulWidget {
  @override
  _UIPageState createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  final TextEditingController modalTextController = TextEditingController();

  @override
  void dispose() {
    modalTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArticleStore articleStore = Provider.of<ArticleStore>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Observer(
        builder: (context) {
          return Stack(
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
                            icon: Icon(Feather.menu),
                            onPressed: () {},
                            color: Colors.white.withOpacity(0.9),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Articles",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          articleStore.error
                              ? Icon(Feather.alert_circle)
                              : Container(),
                          articleStore.loading
                              ? SizedBox(
                                  width: 28,
                                )
                              : Container(),
                          articleStore.loading
                              ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 28,
                                  height: 28,
                                )
                              : Container(),
                          SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Ionicons.md_add),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: TextField(
                                      controller: modalTextController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "URL",
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Paste"),
                                        onPressed: () async {
                                          modalTextController.text =
                                              (await Clipboard.getData(
                                                      "text/plain"))
                                                  .text;
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          modalTextController.text = "";
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          articleStore.addArticle(
                                              modalTextController.text);
                                          modalTextController.text = "";
                                        },
                                      ),
                                    ],
                                  );
                                },
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
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      64 -
                      MediaQuery.of(context).padding.bottom,
                  color: Color(0xffF8F8F8),
                  child: HomePage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
