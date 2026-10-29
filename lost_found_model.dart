enum LostFoundCategory { lost, found }

class LostFoundModel {
  const LostFoundModel({required this.id, required this.category, required this.title, required this.description, this.location, this.date, this.contact, this.imageUrl, this.createdAt});
  final String id;
  final LostFoundCategory category;
  final String title;
  final String description;
  final String? location;
  final DateTime? date;
  final String? contact;
  final String? imageUrl;
  final DateTime? createdAt;

  factory LostFoundModel.fromJson(Map<String, dynamic> json) {
    final rawCategory = _s(json['category']).toLowerCase();
    return LostFoundModel(
      id: _s(json['id']),
      category: rawCategory == 'found' ? LostFoundCategory.found : LostFoundCategory.lost,
      title: _s(json['title']),
      description: _s(json['description']),
      location: _nullable(json['location']),
      date: DateTime.tryParse(_s(json['date'])),
      contact: _nullable(json['contact']),
      imageUrl: _nullable(json['image_url']),
      createdAt: DateTime.tryParse(_s(json['created_at'])),
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'category': category.name, 'title': title, 'description': description, 'location': location, 'date': date?.toIso8601String(), 'contact': contact, 'image_url': imageUrl, 'created_at': createdAt?.toIso8601String()};
  static String _s(dynamic value) => value?.toString().trim() ?? '';
  static String? _nullable(dynamic value) { final s = _s(value); return s.isEmpty ? null : s; }
}
