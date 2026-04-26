import 'package:flutter/material.dart';

@immutable
class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.address,
    this.notes,
  });

  final String id;
  final String label;
  final String address;
  final String? notes;

  SavedAddress copyWith({String? label, String? address, String? notes}) {
    return SavedAddress(
      id: id,
      label: label ?? this.label,
      address: address ?? this.address,
      notes: notes ?? this.notes,
    );
  }
}

@immutable
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

const defaultProfilePhotoUrl = 'https://i.pravatar.cc/300?img=13';

const defaultSavedAddresses = <SavedAddress>[
  SavedAddress(
    id: 'home',
    label: 'Rumah',
    address: 'Jl. Merdeka Raya No. 8, Bekasi',
    notes: 'Pager hitam, rumah pojok.',
  ),
  SavedAddress(
    id: 'office',
    label: 'Kantor',
    address: 'Jl. Jend. Sudirman No. 12, Jakarta',
    notes: 'Lantai 8, resepsionis utama.',
  ),
];

const defaultFaqItems = <FaqItem>[
  FaqItem(
    question: 'Bagaimana cara mengubah metode pembayaran?',
    answer:
        'Saat checkout di PickRide/PickFood/PickSend, tap kartu pembayaran lalu pilih metode yang diinginkan.',
  ),
  FaqItem(
    question: 'Kenapa driver sulit ditemukan?',
    answer:
        'Biasanya karena permintaan tinggi atau cuaca buruk. Coba ganti tipe layanan atau jadwalkan ulang 5-10 menit.',
  ),
  FaqItem(
    question: 'Bagaimana cara menghubungi bantuan?',
    answer:
        'Masuk menu Bantuan & FAQ, lalu pilih opsi Hubungi Support untuk lanjut ke chat bantuan.',
  ),
  FaqItem(
    question: 'Apa bisa simpan lebih dari satu alamat?',
    answer:
        'Bisa. Buka menu Alamat Tersimpan lalu tap Tambah Alamat untuk membuat alamat baru.',
  ),
];
