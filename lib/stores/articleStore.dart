import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobx/mobx.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readit/models/article.dart';
import 'package:validators/validators.dart';

part 'articleStore.g.dart';

class ArticleStore = ArticleStoreBase with _$ArticleStore;

abstract class ArticleStoreBase with Store {
  @observable
  List<ArticleModel> data = [];

  @observable
  bool loading = false;

  @observable
  bool error = false;

  @action
  deleteArticle(int index) async {
    var path =
        (await getApplicationDocumentsDirectory()).path + "/articles__02.db";
    final db = ObjectDB(path);
    db.open();

    await db.remove(
      {
        "message": "${data[index].message}",
      },
    );

    getSavedArticles();

    await db.close();
  }

  @action
  getSavedArticles() async {
    final db = ObjectDB(
        (await getApplicationDocumentsDirectory()).path + "/articles__02.db");
    db.open();

    data = (await db.find({}))
        .map((e) => ArticleModel.fromJson(e))
        .toList()
        .reversed
        .toList();

    await db.close();
  }

  @action
  addArticle(String text) async {
    if (isURL(text)) {
      loading = true;
      error = false;

      var path =
          (await getApplicationDocumentsDirectory()).path + "/articles__02.db";
      final db = ObjectDB(path);
      db.open();

      if ((await db.find(
            {"message": "Extracted article from \"$text\""},
          ))
              .length ==
          0) {
        final res = await get(
          "https://readit.paperplane.ml/api/description?url=$text",
        );

        if (res.statusCode == 200) {
          var body = jsonDecode(res.body);
          if (body['error'] == 0) {
            final res = await get(
              "https://v1.nocodeapi.com/akshitgarg/link_preview/jYIYKEPeLtLUVVxU?url=$text",
            );

            if (res.statusCode == 200) {
              body['logo'] = jsonDecode(res.body)['logo'];
            }

            db.insert(body);

            loading = false;
            error = false;
          } else {
            showError();
          }

          getSavedArticles();
        } else {
          showError();
        }
      } else {
        loading = false;
        error = false;
      }

      await db.close();
    } else {
      showError();
    }
  }

  @action
  showError() {
    loading = false;
    error = true;
  }
}
