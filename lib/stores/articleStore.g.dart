// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articleStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ArticleStore on ArticleStoreBase, Store {
  final _$dataAtom = Atom(name: 'ArticleStoreBase.data');

  @override
  List<ArticleModel> get data {
    _$dataAtom.context.enforceReadPolicy(_$dataAtom);
    _$dataAtom.reportObserved();
    return super.data;
  }

  @override
  set data(List<ArticleModel> value) {
    _$dataAtom.context.conditionallyRunInAction(() {
      super.data = value;
      _$dataAtom.reportChanged();
    }, _$dataAtom, name: '${_$dataAtom.name}_set');
  }

  final _$loadingAtom = Atom(name: 'ArticleStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$errorAtom = Atom(name: 'ArticleStoreBase.error');

  @override
  bool get error {
    _$errorAtom.context.enforceReadPolicy(_$errorAtom);
    _$errorAtom.reportObserved();
    return super.error;
  }

  @override
  set error(bool value) {
    _$errorAtom.context.conditionallyRunInAction(() {
      super.error = value;
      _$errorAtom.reportChanged();
    }, _$errorAtom, name: '${_$errorAtom.name}_set');
  }

  final _$deleteArticleAsyncAction = AsyncAction('deleteArticle');

  @override
  Future deleteArticle(int index) {
    return _$deleteArticleAsyncAction.run(() => super.deleteArticle(index));
  }

  final _$getSavedArticlesAsyncAction = AsyncAction('getSavedArticles');

  @override
  Future getSavedArticles() {
    return _$getSavedArticlesAsyncAction.run(() => super.getSavedArticles());
  }

  final _$addArticleAsyncAction = AsyncAction('addArticle');

  @override
  Future addArticle(String text) {
    return _$addArticleAsyncAction.run(() => super.addArticle(text));
  }

  final _$ArticleStoreBaseActionController =
      ActionController(name: 'ArticleStoreBase');

  @override
  dynamic showError() {
    final _$actionInfo = _$ArticleStoreBaseActionController.startAction();
    try {
      return super.showError();
    } finally {
      _$ArticleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'data: ${data.toString()},loading: ${loading.toString()},error: ${error.toString()}';
    return '{$string}';
  }
}
