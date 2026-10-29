class AdModel {
  const AdModel({required this.advertiserName, required this.phone, required this.imageUrl});
  final String advertiserName;
  final String phone;
  final String imageUrl;
  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(advertiserName: _s(json['advertiser_name']), phone: _s(json['phone']), imageUrl: _s(json['image_url']));
  Map<String, dynamic> toJson() => {'advertiser_name': advertiserName, 'phone': phone, 'image_url': imageUrl};
  static String _s(dynamic value) => value?.toString().trim() ?? '';
}
