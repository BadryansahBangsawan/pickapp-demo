import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/profile_models.dart';

const _profileEmailSentinel = Object();

class ProfileState extends Equatable {
  const ProfileState({
    this.name = 'Teman Pick Up',
    this.email,
    this.phone = '+62',
    this.photoUrl = defaultProfilePhotoUrl,
    this.notificationsEnabled = true,
    this.useEnglish = false,
    this.addresses = defaultSavedAddresses,
    this.faqs = defaultFaqItems,
  });

  final String name;
  final String? email;
  final String phone;
  final String photoUrl;
  final bool notificationsEnabled;
  final bool useEnglish;
  final List<SavedAddress> addresses;
  final List<FaqItem> faqs;

  ProfileState copyWith({
    String? name,
    Object? email = _profileEmailSentinel,
    String? phone,
    String? photoUrl,
    bool? notificationsEnabled,
    bool? useEnglish,
    List<SavedAddress>? addresses,
    List<FaqItem>? faqs,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email == _profileEmailSentinel ? this.email : email as String?,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      useEnglish: useEnglish ?? this.useEnglish,
      addresses: addresses ?? this.addresses,
      faqs: faqs ?? this.faqs,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    photoUrl,
    notificationsEnabled,
    useEnglish,
    addresses,
    faqs,
  ];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void hydrateFromAuth({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    if ((name ?? '').trim().isEmpty &&
        (email ?? '').trim().isEmpty &&
        (phone ?? '').trim().isEmpty &&
        (photoUrl ?? '').trim().isEmpty) {
      return;
    }

    final candidateName = (name ?? '').trim();
    final candidatePhone = (phone ?? '').trim();
    final candidatePhoto = (photoUrl ?? '').trim();

    final nextName = candidateName.isEmpty ? state.name : candidateName;
    final nextPhone = candidatePhone.isEmpty ? state.phone : candidatePhone;
    final nextPhoto = candidatePhoto.isEmpty ? state.photoUrl : candidatePhoto;
    final nextEmail = email ?? state.email;

    if (nextName == state.name &&
        nextPhone == state.phone &&
        nextPhoto == state.photoUrl &&
        nextEmail == state.email) {
      return;
    }

    emit(
      state.copyWith(
        name: nextName,
        email: nextEmail,
        phone: nextPhone,
        photoUrl: nextPhoto,
      ),
    );
  }

  void updateProfile({required String name, String? email, String? photoUrl}) {
    emit(
      state.copyWith(
        name: name,
        email: email,
        photoUrl: (photoUrl ?? '').trim().isEmpty ? state.photoUrl : photoUrl,
      ),
    );
  }

  void toggleNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void toggleLanguage(bool useEnglish) {
    emit(state.copyWith(useEnglish: useEnglish));
  }

  void addAddress(SavedAddress address) {
    emit(state.copyWith(addresses: [...state.addresses, address]));
  }

  void updateAddress(SavedAddress address) {
    final updated = state.addresses
        .map((current) => current.id == address.id ? address : current)
        .toList();
    emit(state.copyWith(addresses: updated));
  }

  void deleteAddress(String addressId) {
    emit(
      state.copyWith(
        addresses: state.addresses.where((e) => e.id != addressId).toList(),
      ),
    );
  }

  void reset() {
    emit(const ProfileState());
  }
}
