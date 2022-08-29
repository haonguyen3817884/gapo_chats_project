class Thread {
  int? id;
  String? name;

  Thread({this.id, this.name});

  Thread.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"] ?? "";
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
