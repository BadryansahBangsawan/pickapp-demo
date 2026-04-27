import 'package:equatable/equatable.dart';

// ──────────────────── Order Types ────────────────────

enum OrderServiceType { ride, food, send }

enum OrderStatus {
  searching,
  driverFound,
  inProgress,
  completed,
  cancelled,
}

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.serviceType,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.amount,
    required this.createdAt,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.vehicleInfo,
    this.rating,
    this.items = const <OrderLineItem>[],
  });

  final String id;
  final OrderServiceType serviceType;
  final String title;
  final String subtitle;
  final OrderStatus status;
  final int amount;
  final DateTime createdAt;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final String? vehicleInfo;
  final double? rating;
  final List<OrderLineItem> items;

  bool get isOngoing =>
      status == OrderStatus.searching ||
      status == OrderStatus.driverFound ||
      status == OrderStatus.inProgress;

  String get serviceLabel {
    switch (serviceType) {
      case OrderServiceType.ride:
        return 'PickRide';
      case OrderServiceType.food:
        return 'PickFood';
      case OrderServiceType.send:
        return 'PickSend';
    }
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.searching:
        return 'Mencari driver';
      case OrderStatus.driverFound:
        return 'Driver ditemukan';
      case OrderStatus.inProgress:
        return 'Dalam perjalanan';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  @override
  List<Object?> get props => [
    id,
    serviceType,
    title,
    subtitle,
    status,
    amount,
    createdAt,
    driverName,
    driverPhone,
    driverPhoto,
    vehicleInfo,
    rating,
    items,
  ];
}

class OrderLineItem extends Equatable {
  const OrderLineItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final int price;

  @override
  List<Object?> get props => [name, quantity, price];
}

// ──────────────────── Mock Data ────────────────────

List<OrderItem> buildMockOrders() {
  final now = DateTime.now();
  return [
    OrderItem(
      id: 'ord-1',
      serviceType: OrderServiceType.ride,
      title: 'PickRide - Motor',
      subtitle: 'Jl. Sudirman → Jl. Thamrin',
      status: OrderStatus.inProgress,
      amount: 25000,
      createdAt: now.subtract(const Duration(minutes: 15)),
      driverName: 'Budi Santoso',
      driverPhone: '+6281234567890',
      driverPhoto: 'https://i.pravatar.cc/150?img=12',
      vehicleInfo: 'Honda Vario 150 • B 1234 XYZ',
    ),
    OrderItem(
      id: 'ord-2',
      serviceType: OrderServiceType.food,
      title: 'Warung Bu Tini',
      subtitle: 'Nasi Padang Rendang, Es Teh',
      status: OrderStatus.inProgress,
      amount: 45000,
      createdAt: now.subtract(const Duration(minutes: 30)),
      driverName: 'Andi Pratama',
      driverPhone: '+6281298765432',
      driverPhoto: 'https://i.pravatar.cc/150?img=15',
      vehicleInfo: 'Yamaha NMAX • B 5678 ABC',
      items: const [
        OrderLineItem(name: 'Nasi Rendang', quantity: 1, price: 28000),
        OrderLineItem(name: 'Es Teh Manis', quantity: 2, price: 8500),
      ],
    ),
    OrderItem(
      id: 'ord-3',
      serviceType: OrderServiceType.ride,
      title: 'PickRide - Car',
      subtitle: 'Jl. Gatot Subroto → Bandara Soetta',
      status: OrderStatus.completed,
      amount: 185000,
      createdAt: now.subtract(const Duration(days: 1)),
      driverName: 'Hendra Wijaya',
      driverPhoto: 'https://i.pravatar.cc/150?img=33',
      vehicleInfo: 'Toyota Avanza • B 9999 DEF',
      rating: 5.0,
    ),
    OrderItem(
      id: 'ord-4',
      serviceType: OrderServiceType.food,
      title: 'Ramen Sora',
      subtitle: 'Ramen Spicy x2, Gyoza',
      status: OrderStatus.completed,
      amount: 92000,
      createdAt: now.subtract(const Duration(days: 2)),
      driverName: 'Dewi Lestari',
      driverPhoto: 'https://i.pravatar.cc/150?img=25',
      vehicleInfo: 'Honda Beat • B 7777 GHI',
      rating: 4.0,
      items: const [
        OrderLineItem(name: 'Ramen Spicy', quantity: 2, price: 38000),
        OrderLineItem(name: 'Gyoza (5 pcs)', quantity: 1, price: 16000),
      ],
    ),
    OrderItem(
      id: 'ord-5',
      serviceType: OrderServiceType.send,
      title: 'PickSend - Paket Kecil',
      subtitle: 'Bekasi → Jakarta Selatan',
      status: OrderStatus.completed,
      amount: 18000,
      createdAt: now.subtract(const Duration(days: 3)),
      driverName: 'Fajar Ramadhan',
      driverPhoto: 'https://i.pravatar.cc/150?img=51',
      vehicleInfo: 'Honda Vario • B 2222 JKL',
      rating: 5.0,
    ),
    OrderItem(
      id: 'ord-6',
      serviceType: OrderServiceType.food,
      title: 'Burger Bar',
      subtitle: 'Double Cheese Burger, Fries',
      status: OrderStatus.cancelled,
      amount: 65000,
      createdAt: now.subtract(const Duration(days: 4)),
      items: const [
        OrderLineItem(name: 'Double Cheese Burger', quantity: 1, price: 45000),
        OrderLineItem(name: 'French Fries (L)', quantity: 1, price: 20000),
      ],
    ),
    OrderItem(
      id: 'ord-7',
      serviceType: OrderServiceType.ride,
      title: 'PickRide - Motor',
      subtitle: 'Stasiun Manggarai → Jl. Casablanca',
      status: OrderStatus.completed,
      amount: 15000,
      createdAt: now.subtract(const Duration(days: 5)),
      driverName: 'Rizki Maulana',
      driverPhoto: 'https://i.pravatar.cc/150?img=60',
      vehicleInfo: 'Yamaha Aerox • B 3333 MNO',
      rating: 4.5,
    ),
  ];
}
