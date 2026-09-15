import 'package:escapia/core/utils/error_meassage_heper.dart';
import 'package:escapia/features/settings/domain/repositories/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(const ProfileInitial());

  Future<void> fetchProfile() async {
    emit(const ProfileLoading());
    try {
      final profile = await repository.getProfile();
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError(ErrorMessageHelper.getUserFriendlyMessage(e)));
    }
  }
}