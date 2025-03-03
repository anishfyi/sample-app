class Rocket {
  final String id;
  final String name;
  final String type;
  final bool active;
  final int stages;
  final int boosters;
  final int costPerLaunch;
  final double successRatePercent;
  final String firstFlight;
  final String country;
  final String company;
  final String description;
  final String? wikipedia;
  final List<String> flickrImages;
  final Height height;
  final Diameter diameter;
  final Mass mass;

  Rocket({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.stages,
    required this.boosters,
    required this.costPerLaunch,
    required this.successRatePercent,
    required this.firstFlight,
    required this.country,
    required this.company,
    required this.description,
    this.wikipedia,
    required this.flickrImages,
    required this.height,
    required this.diameter,
    required this.mass,
  });

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      active: json['active'] ?? false,
      stages: json['stages'] ?? 0,
      boosters: json['boosters'] ?? 0,
      costPerLaunch: json['cost_per_launch'] ?? 0,
      successRatePercent: json['success_rate_pct']?.toDouble() ?? 0.0,
      firstFlight: json['first_flight'] ?? '',
      country: json['country'] ?? '',
      company: json['company'] ?? '',
      description: json['description'] ?? '',
      wikipedia: json['wikipedia'],
      flickrImages: json['flickr_images'] != null
          ? List<String>.from(json['flickr_images'])
          : [],
      height: Height.fromJson(json['height'] ?? {}),
      diameter: Diameter.fromJson(json['diameter'] ?? {}),
      mass: Mass.fromJson(json['mass'] ?? {}),
    );
  }
}

class Height {
  final double meters;
  final double feet;

  Height({
    required this.meters,
    required this.feet,
  });

  factory Height.fromJson(Map<String, dynamic> json) {
    return Height(
      meters: json['meters']?.toDouble() ?? 0.0,
      feet: json['feet']?.toDouble() ?? 0.0,
    );
  }
}

class Diameter {
  final double meters;
  final double feet;

  Diameter({
    required this.meters,
    required this.feet,
  });

  factory Diameter.fromJson(Map<String, dynamic> json) {
    return Diameter(
      meters: json['meters']?.toDouble() ?? 0.0,
      feet: json['feet']?.toDouble() ?? 0.0,
    );
  }
}

class Mass {
  final int kg;
  final int lb;

  Mass({
    required this.kg,
    required this.lb,
  });

  factory Mass.fromJson(Map<String, dynamic> json) {
    return Mass(
      kg: json['kg'] ?? 0,
      lb: json['lb'] ?? 0,
    );
  }
} 