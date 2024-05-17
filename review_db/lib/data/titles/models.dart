import 'package:flutter/material.dart';

class Category {
  final String name;
  final String slug;

  Category(this.name, this.slug);

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        slug = json['slug'];
}

class Genre {
  final String name;
  final String slug;

  Genre(this.name, this.slug);

  Genre.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        slug = json['slug'];
}


class Title {
  final int id;
  final String name;
  final String description;
  final int year;
  final String? photo;
  final List<Genre> genres;
  final Category category;
  final int rating;

  Title(
    this.id,
    this.name,
    this.description,
    this.year,
    this.photo,
    this.genres,
    this.category,
    this.rating
  );

  Title.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        year = json['year'],
        photo = json['photo'],
        genres = List<Genre>.from(json['genre'].map((genre)=> Genre.fromJson(genre))),
        category = Category.fromJson(json['category']),
        rating = json['rating'];

  dynamic getImage() {
    if (photo == null){
      return const AssetImage('lib/assets/pics/default_title_poster.png');
    }
    return NetworkImage('$photo');
  }
}
