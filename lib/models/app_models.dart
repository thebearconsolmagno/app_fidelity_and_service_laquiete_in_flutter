
class AppTheme {
  final String primaryColor;
  final String secondaryColor;
  final String logoUrl;
  final String companyName;

  AppTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.logoUrl,
    required this.companyName,
  });

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      primaryColor: json['primaryColor'] ?? '#10b981',
      secondaryColor: json['secondaryColor'] ?? '#1e3a8a',
      logoUrl: json['logoUrl'] ?? '',
      companyName: json['companyName'] ?? 'La Quiete',
    );
  }

  Map<String, dynamic> toJson() => {
    'primaryColor': primaryColor,
    'secondaryColor': secondaryColor,
    'logoUrl': logoUrl,
    'companyName': companyName,
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final String phoneDDI;
  final String phoneNumber;
  final int pointsRistorante;
  final int pointsPizzeria;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneDDI,
    required this.phoneNumber,
    required this.pointsRistorante,
    required this.pointsPizzeria,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phoneDDI: json['phoneDDI'] ?? '+39',
      phoneNumber: json['phoneNumber'] ?? '',
      pointsRistorante: json['pointsRistorante'] ?? 0,
      pointsPizzeria: json['pointsPizzeria'] ?? 0,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> allergens;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.allergens,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'Generale',
      allergens: List<String>.from(json['allergens'] ?? []),
    );
  }
}

class FidelityHistory {
  final String id;
  final DateTime date;
  final String description;
  final int points;
  final String type;
  final String sector;

  FidelityHistory({
    required this.id,
    required this.date,
    required this.description,
    required this.points,
    required this.type,
    required this.sector,
  });

  factory FidelityHistory.fromJson(Map<String, dynamic> json) {
    return FidelityHistory(
      id: json['id'].toString(),
      date: DateTime.parse(json['date']),
      description: json['description'],
      points: json['points'],
      type: json['type'],
      sector: json['sector'],
    );
  }
}

class Reservation {
  final int id;
  final String date;
  final int guests;
  final String period;
  final String eventType;
  final String userName;
  final String userPhone;
  final String status;
  final String createdAt;

  Reservation({
    required this.id,
    required this.date,
    required this.guests,
    required this.period,
    required this.eventType,
    required this.userName,
    required this.userPhone,
    required this.status,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      date: json['date'],
      guests: json['guests'],
      period: json['period'],
      eventType: json['eventType'] ?? '',
      userName: json['userName'],
      userPhone: json['userPhone'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }
}
