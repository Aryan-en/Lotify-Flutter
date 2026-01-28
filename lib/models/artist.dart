class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final int followers;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.followers = 0,
  });
}
