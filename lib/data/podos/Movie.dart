class Movie {

  String? name = "";
  String? director = "";
  String? poster = "";

  Movie({this.name, this.director, this.poster}) : super();

  Map<String, dynamic> toJson() => {
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