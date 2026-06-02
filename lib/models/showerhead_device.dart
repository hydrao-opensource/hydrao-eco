class ShowerheadDevice {
  final String id;
  final int rssi;
  final bool inDb;
  final bool connecting;
  final String? name;
  final double? autoConnectProgress;
  final String? type;
  final String? thresholds;
  final DateTime? lastSeen;

  ShowerheadDevice({
    required this.id,
    required this.rssi,
    this.name,
    this.inDb = false,
    this.connecting = false,
    this.autoConnectProgress,
    this.type,
    this.thresholds,
    this.lastSeen,
  });

  ShowerheadDevice copyWith({
    String? name,
    bool? inDb,
    bool? connecting,
    double? autoConnectProgress,
    String? type,
    String? thresholds,
    DateTime? lastSeen,
  }) {
    return ShowerheadDevice(
      id: id,
      rssi: rssi,
      name: name ?? this.name,
      inDb: inDb ?? this.inDb,
      connecting: connecting ?? this.connecting,
      autoConnectProgress: autoConnectProgress ?? this.autoConnectProgress,
      type: type ?? this.type,
      thresholds: thresholds ?? this.thresholds,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  String toString() {
    return 'ShowerheadDevice(id: $id, name: $name, rssi: ${rssi}dBm, inDb: $inDb, '
        'connecting: $connecting, progress: ${autoConnectProgress?.toStringAsFixed(2) ?? "N/A"}, '
        'type: $type, thresholds: $thresholds, lastSeen: $lastSeen)';
  }
}
