class RawLiveShower {
  final int volume;
  final int flow;
  final int instantFlow; // for live graph
  final int temperature;
  final int instantTemperature; // for live graph

  RawLiveShower({
    required this.volume,
    required this.flow,
    required this.instantFlow,
    required this.temperature,
    required this.instantTemperature,
  });
}
