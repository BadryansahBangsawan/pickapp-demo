import 'package:equatable/equatable.dart';

enum NotificationType { order, promo, payment, system }

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.deepLink,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? deepLink;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      deepLink: deepLink,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, title, body, createdAt, isRead, deepLink];
}

// ──────────────────── Mock Data ────────────────────

List<AppNotification> buildMockNotifications() {
  final now = DateTime.now();
  return [
    AppNotification(
      id: 'notif-1',
      type: NotificationType.order,
      title: 'Pesanan dalam perjalanan',
      body: 'Driver Budi sedang menuju lokasi penjemputan kamu.',
      createdAt: now.subtract(const Duration(minutes: 5)),
      deepLink: '/activity',
    ),
    AppNotification(
      id: 'notif-2',
      type: NotificationType.promo,
      title: 'Diskon 50% PickRide!',
      body: 'Gunakan kode HEMAT50 untuk perjalanan pertamamu hari ini. Berlaku hingga pukul 23:59.',
      createdAt: now.subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      id: 'notif-3',
      type: NotificationType.payment,
      title: 'Top up berhasil',
      body: 'Saldo PickPay kamu bertambah Rp 200.000. Saldo saat ini: Rp 347.000.',
      createdAt: now.subtract(const Duration(hours: 3)),
      isRead: true,
      deepLink: '/payment',
    ),
    AppNotification(
      id: 'notif-4',
      type: NotificationType.order,
      title: 'Pesanan selesai',
      body: 'Perjalanan PickRide kamu ke Bandara Soetta telah selesai. Yuk beri rating!',
      createdAt: now.subtract(const Duration(days: 1)),
      isRead: true,
      deepLink: '/activity',
    ),
    AppNotification(
      id: 'notif-5',
      type: NotificationType.promo,
      title: 'Cashback PickFood Rp 10.000',
      body: 'Pesan makanan di atas Rp 50.000 dan dapatkan cashback langsung ke PickPay.',
      createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
    ),
    AppNotification(
      id: 'notif-6',
      type: NotificationType.system,
      title: 'Verifikasi akun berhasil',
      body: 'Akun kamu telah terverifikasi. Nikmati semua layanan Pick Up!',
      createdAt: now.subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      id: 'notif-7',
      type: NotificationType.payment,
      title: 'Refund diterima',
      body: 'Refund sebesar Rp 32.000 dari pesanan PickFood telah masuk ke saldo PickPay.',
      createdAt: now.subtract(const Duration(days: 4)),
      isRead: true,
      deepLink: '/payment',
    ),
    AppNotification(
      id: 'notif-8',
      type: NotificationType.promo,
      title: 'Top Up Gratis Admin',
      body: 'Top up PickPay minimal Rp 100.000 tanpa biaya admin. Berlaku hari ini!',
      createdAt: now.subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];
}
