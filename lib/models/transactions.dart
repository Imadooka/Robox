class Transactions {
  int? keyID;
  final String name;
  final String rating;
  final String developer;
  final DateTime date;
  final String category;
  final String age;
  final String imageUrl; 

  Transactions(
      {this.keyID,
      required this.name,
      required this.rating,
      required this.developer,
      required this.date,
      required this.category,
      required this.age,
      required this.imageUrl});
}
