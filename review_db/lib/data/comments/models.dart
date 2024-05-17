class Comment {
  final int id;
  final String text;
  final String author;
  final String pubDate;

  Comment(
    this.id,
    this.text,
    this.author,
    this.pubDate
  );

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        author = json['author'],
        pubDate = json['pub_date'];
}

class CreateComment {
  final String text;

  CreateComment(this.text);

  Map<String, dynamic> toJson() => {"text": text};
}
