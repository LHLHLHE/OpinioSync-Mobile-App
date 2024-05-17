class Review {
  final int id;
  final int title;
  final String text;
  final String author;
  final int score;
  final String pubDate;

  Review(
    this.id,
    this.title,
    this.text,
    this.author,
    this.score,
    this.pubDate
  );

  Review.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        text = json['text'],
        author = json['author'],
        score = json['score'],
        pubDate = json['pub_date'];
  
  Map<String, dynamic> toJson() => 
  {
    "score": score,
    "text": text
  };
}

class CreateReview {
  final String text;
  final int score;

  CreateReview(
    this.text,
    this.score
  );
  
  Map<String, dynamic> toJson() => 
  {
    "score": score,
    "text": text
  };
}
