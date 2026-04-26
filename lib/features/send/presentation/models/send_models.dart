import 'package:flutter/material.dart';

enum PackageSize { small, medium, large }

extension PackageSizeX on PackageSize {
  String get label {
    return switch (this) {
      PackageSize.small => 'Kecil',
      PackageSize.medium => 'Sedang',
      PackageSize.large => 'Besar',
    };
  }

  String get description {
    return switch (this) {
      PackageSize.small => 'Dokumen, aksesoris, atau barang ringan',
      PackageSize.medium => 'Makanan, pakaian, atau paket harian',
      PackageSize.large => 'Paket besar hingga 8kg',
    };
  }

  int get baseFee {
    return switch (this) {
      PackageSize.small => 12000,
      PackageSize.medium => 18000,
      PackageSize.large => 26000,
    };
  }

  IconData get icon {
    return switch (this) {
      PackageSize.small => Icons.inventory_2_outlined,
      PackageSize.medium => Icons.all_inbox_outlined,
      PackageSize.large => Icons.local_shipping_outlined,
    };
  }
}

@immutable
class SendDraft {
  const SendDraft({
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.recipientName,
    required this.recipientPhone,
  });

  final String pickupAddress;
  final String deliveryAddress;
  final String recipientName;
  final String recipientPhone;
}

@immutable
class SendOrder {
  const SendOrder({
    required this.trackingCode,
    required this.draft,
    required this.packageSize,
    required this.isFragile,
    required this.notes,
    required this.photoPath,
    required this.fee,
    required this.createdAt,
  });

  final String trackingCode;
  final SendDraft draft;
  final PackageSize packageSize;
  final bool isFragile;
  final String notes;
  final String? photoPath;
  final int fee;
  final DateTime createdAt;
}

const sendTrackingSteps = <String>[
  'Driver menuju titik pickup',
  'Paket sudah dijemput',
  'Paket dalam perjalanan',
  'Paket berhasil diantar',
];
