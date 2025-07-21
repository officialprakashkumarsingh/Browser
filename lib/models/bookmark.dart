class Bookmark {
  final String id;
  final String title;
  final String url;
  final String? favicon;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.title,
    required this.url,
    this.favicon,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'favicon': favicon,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      favicon: json['favicon'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Bookmark copyWith({
    String? id,
    String? title,
    String? url,
    String? favicon,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      favicon: favicon ?? this.favicon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bookmark && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}