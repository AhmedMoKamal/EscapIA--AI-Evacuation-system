class EdgeConnection {
  final String from;
  final String to;
  final int weight;
  const EdgeConnection(this.from, this.to, this.weight);
  String get id => '$from-$to';
}
