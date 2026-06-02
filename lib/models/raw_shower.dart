class RawShower {
  final int id;
  final int volume;
  final int? flow;
  final int? temperature;
  final int soapingTime;

  RawShower({
    required this.id,
    required this.volume,
    this.flow,
    this.temperature,
    required this.soapingTime,
  });
}
