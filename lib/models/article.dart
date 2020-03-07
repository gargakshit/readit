class ArticleModel {
  int error;
  String message;
  Data data;
  String logo;

  ArticleModel({this.error, this.message, this.data, this.logo});

  ArticleModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    logo = json['logo'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['logo'] = this.logo;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String url;
  String title;
  String description;
  List<String> links;
  String image;
  String content;
  String author;
  String source;
  String published;
  int ttr;

  Data(
      {this.url,
      this.title,
      this.description,
      this.links,
      this.image,
      this.content,
      this.author,
      this.source,
      this.published,
      this.ttr});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    description = json['description'];
    links = json['links'].cast<String>();
    image = json['image'];
    content = json['content'];
    author = json['author'];
    source = json['source'];
    published = json['published'];
    ttr = json['ttr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    data['links'] = this.links;
    data['image'] = this.image;
    data['content'] = this.content;
    data['author'] = this.author;
    data['source'] = this.source;
    data['published'] = this.published;
    data['ttr'] = this.ttr;
    return data;
  }
}
