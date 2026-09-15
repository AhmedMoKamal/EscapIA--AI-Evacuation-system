import '../../../domain/entities/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileSuccess(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}