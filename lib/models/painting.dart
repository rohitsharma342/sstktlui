class Painting {
  final String id;
  final String title;
  final String artist;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isTrending;
  final String artistBio;
  final List<String> additionalImages;
  
  Painting({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isTrending = false,
    this.artistBio = '',
    this.additionalImages = const [],
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isTrending': isTrending,
      'artistBio': artistBio,
      'additionalImages': additionalImages,
    };
  }
  
  factory Painting.fromJson(Map<String, dynamic> json) {
    return Painting(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      isTrending: json['isTrending'] ?? false,
      artistBio: json['artistBio'] ?? '',
      additionalImages: List<String>.from(json['additionalImages'] ?? []),
    );
  }
}