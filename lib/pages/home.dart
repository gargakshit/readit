import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:readit/pages/article.dart';
import 'package:readit/stores/articleStore.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var baseSize = (MediaQuery.of(context).size.height -
        64 -
        MediaQuery.of(context).padding.bottom);

    ArticleStore articleStore = Provider.of<ArticleStore>(context);

    return Observer(
      builder: (c) {
        return Container(
          child: articleStore.data.length == 0
              ? Center(
                  child: Text(
                    articleStore.loading
                        ? "Adding..."
                        : "Please add an article first!",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xff212121),
                      fontSize: 20,
                    ),
                  ),
                )
              : PageView.builder(
                  itemCount: articleStore.data.length,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (ctx, position) {
                    var date = articleStore.data[position].data.published;
                    var imgTag = Uuid().v4();

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArticleScreen(
                              article: articleStore.data[position],
                              imgTag: imgTag,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: imgTag,
                            child: CachedNetworkImage(
                              imageUrl: articleStore.data[position].data.image,
                              width: MediaQuery.of(context).size.width,
                              height: baseSize / 2.4,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.white,
                                child: Container(
                                  height: baseSize / 2.4,
                                  color: Colors.black,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            height: 48,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "${((articleStore.data[position].data.ttr) / 60).ceil()} min read",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff212121),
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  "${date != "" ? DateFormat('E, dd MMMM').format(DateTime.parse(date)) : ""}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff212121).withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                articleStore.data[position].logo == null
                                    ? Text(
                                        "via ${articleStore.data[position].data.source}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff212121)
                                              .withOpacity(0.6),
                                        ),
                                      )
                                    : Container(
                                        height: 48,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                144,
                                        alignment: Alignment.centerLeft,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              articleStore.data[position].logo,
                                          height: 48,
                                        ),
                                      ),
                                Expanded(
                                  child: Container(),
                                ),
                                IconButton(
                                  icon: Icon(Feather.trash_2),
                                  onPressed: () {
                                    articleStore.deleteArticle(position);
                                  },
                                  color: Color(0xff212121).withOpacity(0.6),
                                  iconSize: 24,
                                ),
                                IconButton(
                                  icon: Icon(Ionicons.ios_share),
                                  onPressed: () {
                                    Share.share(
                                      "${articleStore.data[position].data.title}\n\n${articleStore.data[position].data.url}\n\nShared using readit.",
                                    );
                                  },
                                  color: Color(0xff212121).withOpacity(0.6),
                                  iconSize: 24,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              articleStore.data[position].data.title,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff212121),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              articleStore.data[position].data.description,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff212121).withOpacity(0.6),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Read More",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff212121).withOpacity(0.9),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Icon(
                                  Ionicons.ios_arrow_round_forward,
                                  color: Color(0xff212121).withOpacity(0.9),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
