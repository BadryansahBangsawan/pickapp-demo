import 'package:flutter/material.dart';

@immutable
class RideLocation {
  const RideLocation({required this.label, required this.address});

  final String label;
  final String address;
}

@immutable
class RideOption {
  const RideOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.etaMinutes,
    required this.multiplier,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int etaMinutes;
  final double multiplier;
}

@immutable
class DriverProfile {
  const DriverProfile({
    required this.name,
    required this.vehicle,
    required this.plate,
    required this.rating,
  });

  final String name;
  final String vehicle;
  final String plate;
  final double rating;
}

@immutable
class RideQuote {
  const RideQuote({
    required this.pickup,
    required this.destination,
    required this.distanceKm,
    required this.durationMinutes,
    required this.option,
    required this.paymentMethod,
    required this.estimatedPrice,
    this.driver,
  });

  final RideLocation pickup;
  final RideLocation destination;
  final double distanceKm;
  final int durationMinutes;
  final RideOption option;
  final String paymentMethod;
  final int estimatedPrice;
  final DriverProfile? driver;

  RideQuote copyWith({
    RideLocation? pickup,
    RideLocation? destination,
    double? distanceKm,
    int? durationMinutes,
    RideOption? option,
    String? paymentMethod,
    int? estimatedPrice,
    DriverProfile? driver,
  }) {
    return RideQuote(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      option: option ?? this.option,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      driver: driver ?? this.driver,
    );
  }
}

const rideOptions = <RideOption>[
  RideOption(
    id: 'bike',
    title: 'PickRide Bike',
    description: 'Motor cepat untuk 1 penumpang',
    icon: Icons.two_wheeler_outlined,
    color: Color(0xFF00C853),
    etaMinutes: 4,
    multiplier: 1,
  ),
  RideOption(
    id: 'car',
    title: 'PickRide Car',
    description: 'Mobil nyaman untuk 4 penumpang',
    icon: Icons.directions_car_outlined,
    color: Color(0xFF1976D2),
    etaMinutes: 6,
    multiplier: 1.55,
  ),
  RideOption(
    id: 'premium',
    title: 'PickRide Premium',
    description: 'Mobil premium prioritas',
    icon: Icons.airport_shuttle_outlined,
    color: Color(0xFF8E24AA),
    etaMinutes: 8,
    multiplier: 2.1,
  ),
];

const savedPlaces = <RideLocation>[
  RideLocation(label: 'Rumah', address: 'Jl. Merdeka Raya No. 8, Bekasi'),
  RideLocation(label: 'Kantor', address: 'Jl. Jend. Sudirman No. 12, Jakarta'),
  RideLocation(label: 'Bandara', address: 'Soekarno-Hatta Terminal 3'),
];

const defaultRideDriver = DriverProfile(
  name: 'Rizky Pratama',
  vehicle: 'Honda Beat Hitam',
  plate: 'B 1234 PIK',
  rating: 4.92,
);
