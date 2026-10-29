class EmergencyModel {
  const EmergencyModel({required this.department, required this.phoneNumber});
  final String department;
  final String phoneNumber;
  factory EmergencyModel.fromJson(Map<String, dynamic> json) => EmergencyModel(department: _s(json['department']), phoneNumber: _s(json['phone_number']));
  Map<String, dynamic> toJson() => {'department': department, 'phone_number': phoneNumber};
  static String _s(dynamic value) => value?.toString().trim() ?? '';
}
