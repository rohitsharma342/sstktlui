import '../models/painting.dart';
import '../models/user.dart';

class DataService {
  static List<Painting> getPaintings() {
    return [
      Painting(
        id: '1',
        title: 'Sunset Dreams',
        artist: 'Elena Rodriguez',
        description: 'A breathtaking oil painting capturing the essence of a perfect sunset over rolling hills. The warm golden and orange hues blend seamlessly with deep purples and blues, creating a sense of tranquility and wonder.',
        price: 1250.0,
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        category: 'Landscape',
        isTrending: true,
        artistBio: 'Elena Rodriguez is a contemporary artist known for her vibrant landscape paintings.',
        additionalImages: [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
          'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?w=400',
        ],
      ),
      Painting(
        id: '2',
        title: 'Urban Symphony',
        artist: 'Marcus Chen',
        description: 'An abstract interpretation of city life, featuring bold brushstrokes and a dynamic color palette that represents the energy and movement of urban environments.',
        price: 890.0,
        imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800',
        category: 'Abstract',
        isTrending: true,
        artistBio: 'Marcus Chen specializes in abstract art that captures the essence of modern life.',
      ),
      Painting(
        id: '3',
        title: 'Ocean Depths',
        artist: 'Sarah Williams',
        description: 'A mesmerizing seascape that explores the mysterious depths of the ocean through layers of blue and green, creating a sense of infinite depth and movement.',
        price: 1450.0,
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        category: 'Seascape',
        artistBio: 'Sarah Williams is renowned for her oceanic paintings that capture the power and beauty of the sea.',
      ),
      Painting(
        id: '4',
        title: 'Forest Whispers',
        artist: 'David Thompson',
        description: 'A serene forest scene painted with incredible detail, showcasing the interplay of light and shadow through ancient trees.',
        price: 1100.0,
        imageUrl: 'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?w=800',
        category: 'Landscape',
        isTrending: false,
        artistBio: 'David Thompson focuses on realistic nature paintings with exceptional attention to detail.',
      ),
      Painting(
        id: '5',
        title: 'Portrait of Grace',
        artist: 'Isabella Martinez',
        description: 'A classical portrait demonstrating masterful technique in capturing human emotion and character through oil painting.',
        price: 2100.0,
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        category: 'Portrait',
        artistBio: 'Isabella Martinez is a portrait artist with classical training in European techniques.',
      ),
      Painting(
        id: '6',
        title: 'Mountain Majesty',
        artist: 'Robert Kim',
        description: 'A powerful mountain landscape showcasing snow-capped peaks against a dramatic sky, painted with bold, confident strokes.',
        price: 1350.0,
        imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800',
        category: 'Landscape',
        isTrending: true,
        artistBio: 'Robert Kim specializes in dramatic landscape paintings of natural wonders.',
      ),
    ];
  }
  
  static List<String> getCategories() {
    return ['All', 'Landscape', 'Abstract', 'Portrait', 'Seascape', 'Still Life'];
  }
  
  static User getSampleUser() {
    return User(
      id: 'user1',
      name: 'John Doe',
      email: 'john.doe@email.com',
      shippingAddress: '123 Art Street, Creative City, AC 12345',
      paymentInfo: '**** **** **** 1234',
      orderHistory: [
        Order(
          id: 'order1',
          date: DateTime.now().subtract(Duration(days: 7)),
          totalAmount: 1250.0,
          status: 'Delivered',
          items: ['Sunset Dreams'],
        ),
        Order(
          id: 'order2',
          date: DateTime.now().subtract(Duration(days: 15)),
          totalAmount: 890.0,
          status: 'Shipped',
          items: ['Urban Symphony'],
        ),
      ],
    );
  }
}