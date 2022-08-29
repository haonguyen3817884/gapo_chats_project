class MessageBody {
  String? text;

  MessageBody({this.text});

  MessageBody.fromJson(Map<String, dynamic> json) {
    text = json["text"] ?? "";
  }

  Map<String, dynamic> toJson() => {"text": text};
}
