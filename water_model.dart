class WaterModel {
  const WaterModel({required this.neighborhood, required this.currentStatus, required this.nextStatus, this.nextArrivalAt});
  final String neighborhood;
  final String currentStatus;
  final String nextStatus;
  /// Optional ISO-8601 timestamp. Add `next_arrival_at` to the sheet to enable exact 8-hour notifications.
  final DateTime? nextArrivalAt;

  factory WaterModel.fromJson(Map<String, dynamic> json) => WaterModel(
    neighborhood: _s(json['neighborhood']),
    currentStatus: _s(json['current_status']),
    nextStatus: _s(json['next_status']),
    nextArrivalAt: DateTime.tryParse(_s(json['next_arrival_at'])),
  );
  Map<String, dynamic> toJson() => {'neighborhood': neighborhood, 'current_status': currentStatus, 'next_status': nextStatus, if (nextArrivalAt != null) 'next_arrival_at': nextArrivalAt!.toIso8601String()};
  static String _s(dynamic value) => value?.toString().trim() ?? '';
}
