class DistanceMatrix {
  final List<Element> elements;

  DistanceMatrix({required this.elements});

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) {
    return DistanceMatrix(
        elements: json['rows'][0]['elements']
            .map<Element>((e) => Element.fromJson(e))
            .toList());
  }
}

class Element {
  final Distance distance;

  Element({required this.distance});

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(distance: Distance.fromJson(json['distance']));
  }
}

class Distance {
  final String text;

  Distance({required this.text});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(text: json['text'] as String);
  }
}
