class PharmacyModel {
  const PharmacyModel({required this.time, required this.name, required this.address});
  final String time;
  final String name;
  final String address;
  factory PharmacyModel.fromJson(Map<String, dynamic> json) => PharmacyModel(time: _s(json['time']), name: _s(json['name']), address: _s(json['address']));
  Map<String, dynamic> toJson() => {'time': time, 'name': name, 'address': address};
  static String _s(dynamic value) => value?.toString().trim() ?? '';
}
