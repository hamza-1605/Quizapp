class Category {
  const Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.color,
  });

  final int id;
  final String name;
  final String? imageUrl;

  /// Hex code such as "#2E86DE". The UI turns it into a Color.
  final String? color;
}