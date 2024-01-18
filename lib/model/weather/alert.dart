class Alert {
  String? senderName;
  String? event;
  int? start;
  int? end;
  String? description;
  List<String>? tags;

  Alert({
    this.senderName,
    this.event,
    this.start,
    this.end,
    this.description,
    this.tags,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        senderName: json['sender_name'] as String?,
        event: json['event'] as String?,
        start: json['start'] as int?,
        end: json['end'] as int?,
        description: json['description'] as String?,
        tags: json['tags'] as List<String>?,
      );

  Map<String, dynamic> toJson() => {
        'sender_name': senderName,
        'event': event,
        'start': start,
        'end': end,
        'description': description,
        'tags': tags,
      };
}
