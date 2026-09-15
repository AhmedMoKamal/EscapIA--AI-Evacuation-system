import 'dart:async';
import 'package:escapia/core/errors/error_handler.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/domain/repositories/building_state_repository.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildingStateCubit extends Cubit<BuildingStateState> {
  final BuildingStateRepository repository;
  StreamSubscription? _zoneSubscription;
  List<ZoneEntity> _currentZones = [];

  BuildingStateCubit({required this.repository})
    : super(BuildingStateInitial());

  Future<void> initBuildingState() async {
    emit(BuildingStateLoading());

    try {
      final zones = await repository.getInitialState();
      _currentZones = List.from(zones);
      emit(BuildingStateLoaded(List.from(_currentZones)));

      await _zoneSubscription?.cancel();
      _zoneSubscription = repository.watchBuildingState().listen(
        (updatedZone) {
          if (isClosed) return;

          final index = _currentZones.indexWhere(
            (z) => z.zoneId == updatedZone.zoneId,
          );

          if (index != -1) {
            _currentZones[index] = updatedZone;
          } else {
            _currentZones.add(updatedZone);
          }

          emit(BuildingStateLoaded(List.from(_currentZones)));
        },
        onError: (error) {
          if (isClosed) return;
          emit(BuildingStateError(ErrorHandler.handle(error)));
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(BuildingStateError(ErrorHandler.handle(e)));
      }
    }
  }

  @override
  Future<void> close() {
    _zoneSubscription?.cancel();
    return super.close();
  }
}
