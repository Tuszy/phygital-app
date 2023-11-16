class LSP4Link {
  LSP4Link({required this.title, required this.url});

  final String title;
  final String url;

  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }
}
