import 'package:flutter/material.dart';

@immutable
class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.distanceKm,
    required this.deliveryMinutes,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final double rating;
  final double distanceKm;
  final int deliveryMinutes;
  final String imageUrl;
}

@immutable
class MenuItem {
  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
}

const foodCategories = <String>[
  'Semua',
  'Makanan',
  'Minuman',
  'Cepat Saji',
  'Dessert',
];

const mockRestaurants = <Restaurant>[
  Restaurant(
    id: 'r1',
    name: 'Warung Bu Tini',
    category: 'Makanan',
    rating: 4.8,
    distanceKm: 0.6,
    deliveryMinutes: 20,
    imageUrl:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
  ),
  Restaurant(
    id: 'r2',
    name: 'Ramen Sora',
    category: 'Makanan',
    rating: 4.7,
    distanceKm: 1.2,
    deliveryMinutes: 25,
    imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
  ),
  Restaurant(
    id: 'r3',
    name: 'Kopi Kenangan',
    category: 'Minuman',
    rating: 4.9,
    distanceKm: 0.4,
    deliveryMinutes: 15,
    imageUrl:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
  ),
];

const mockMenus = <MenuItem>[
  MenuItem(
    id: 'm1',
    restaurantId: 'r1',
    name: 'Nasi Ayam Bakar',
    description: 'Nasi hangat, ayam bakar bumbu kecap, sambal.',
    price: 28000,
    imageUrl:
        'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=800',
  ),
  MenuItem(
    id: 'm2',
    restaurantId: 'r1',
    name: 'Es Teh Manis',
    description: 'Teh manis segar ukuran besar.',
    price: 8000,
    imageUrl:
        'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800',
  ),
  MenuItem(
    id: 'm3',
    restaurantId: 'r2',
    name: 'Ramen Chashu',
    description: 'Kuah gurih, mie kenyal, irisan chashu premium.',
    price: 45000,
    imageUrl:
        'https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=800',
  ),
  MenuItem(
    id: 'm4',
    restaurantId: 'r3',
    name: 'Latte Gula Aren',
    description: 'Kopi susu creamy dengan gula aren.',
    price: 23000,
    imageUrl:
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800',
  ),
];
