class Movie {

  int? id = -1;
  String? name = "";
  String? director = "";
  String? poster = "";

  Movie({this.id, this.name, this.director, this.poster}) : super();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'director': director,
    'poster': poster
  };

  Movie.fromMap(dynamic obj) {
    this.name = obj["name"];
    this.director = obj["director"];
    this.poster = obj["poster"];
  }

}