import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:readit/models/article.dart';
import 'package:readit/pages/article.dart';
import 'package:readit/utils/getTextColor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class CardComponent extends StatefulWidget {
  final ArticleModel article;

  CardComponent({@required this.article});

  @override
  _CardComponentState createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  String heroTag = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleScreen(
              article: widget.article,
              heroTag: heroTag,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16.0,
        ),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  0.0,
                ),
                child: Hero(
                  tag: heroTag,
                  child: SizedBox(
                    width: 120,
                    height: 90,
                    child: CachedNetworkImage(
                      imageUrl: widget.article.data.image,
                      placeholder: (context, url) => Shimmer.fromColors(
                        child: Container(
                          width: 120,
                          height: 90,
                          color: Colors.black,
                        ),
                        baseColor: Colors.grey[400],
                        highlightColor: Colors.white,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Feather.x_circle),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.article.data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: getTextColor(
                        MediaQuery.of(context).platformBrightness,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.article.data.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: getTextColor(
                        MediaQuery.of(context).platformBrightness,
                      ),
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "${(widget.article.data.ttr / 60).ceil()} min read - via ${widget.article.data.source}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.white60
                          : Colors.black54,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
