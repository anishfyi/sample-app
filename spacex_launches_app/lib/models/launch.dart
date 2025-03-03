import 'package:intl/intl.dart';

class Launch {
  final String id;
  final String name;
  final DateTime? dateUtc;
  final DateTime? datePrecision;
  final bool upcoming;
  final bool success;
  final String? details;
  final String? patchSmall;
  final String? patchLarge;
  final String? webcast;
  final String? article;
  final String? wikipedia;
  final String rocketId;
  final String launchpadId;
  final List<Payload> payloads;
  final Links links;

  Launch({
    required this.id,
    required this.name,
    this.dateUtc,
    this.datePrecision,
    required this.upcoming,
    this.success,
    this.details,
    this.patchSmall,
    this.patchLarge,
    this.webcast,
    this.article,
    this.wikipedia,
    required this.rocketId,
    required this.launchpadId,
    required this.payloads,
    required this.links,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    List<Payload> payloads = [];
    if (json['payloads'] != null) {
      payloads = List<Payload>.from(
        (json['payloads'] as List).map((x) => Payload(id: x)),
      );
    }

    return Launch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dateUtc: json['date_utc'] != null ? DateTime.parse(json['date_utc']) : null,
      datePrecision: json['date_precision'] != null ? DateTime.parse(json['date_precision']) : null,
      upcoming: json['upcoming'] ?? false,
      success: json['success'] ?? false,
      details: json['details'],
      patchSmall: json['links']?['patch']?['small'],
      patchLarge: json['links']?['patch']?['large'],
      webcast: json['links']?['webcast'],
      article: json['links']?['article'],
      wikipedia: json['links']?['wikipedia'],
      rocketId: json['rocket'] ?? '',
      launchpadId: json['launchpad'] ?? '',
      payloads: payloads,
      links: Links.fromJson(json['links'] ?? {}),
    );
  }

  String get formattedDate {
    if (dateUtc == null) return 'TBD';
    return DateFormat('MMM dd, yyyy').format(dateUtc!);
  }

  String get formattedTime {
    if (dateUtc == null) return '';
    return DateFormat('HH:mm').format(dateUtc!);
  }

  String get statusText {
    if (upcoming) return 'Upcoming';
    return success == true ? 'Successful' : 'Failed';
  }
}

class Payload {
  final String id;
  String? name;
  String? type;
  double? massKg;
  String? orbit;
  String? manufacturer;
  String? customer;

  Payload({
    required this.id,
    this.name,
    this.type,
    this.massKg,
    this.orbit,
    this.manufacturer,
    this.customer,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      id: json['id'] ?? '',
      name: json['name'],
      type: json['type'],
      massKg: json['mass_kg']?.toDouble(),
      orbit: json['orbit'],
      manufacturer: json['manufacturers']?.isNotEmpty == true ? json['manufacturers'][0] : null,
      customer: json['customers']?.isNotEmpty == true ? json['customers'][0] : null,
    );
  }
}

class Links {
  final String? webcast;
  final String? article;
  final String? wikipedia;
  final Patch patch;

  Links({
    this.webcast,
    this.article,
    this.wikipedia,
    required this.patch,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      webcast: json['webcast'],
      article: json['article'],
      wikipedia: json['wikipedia'],
      patch: Patch.fromJson(json['patch'] ?? {}),
    );
  }
}

class Patch {
  final String? small;
  final String? large;

  Patch({
    this.small,
    this.large,
  });

  factory Patch.fromJson(Map<String, dynamic> json) {
    return Patch(
      small: json['small'],
      large: json['large'],
    );
  }
} 