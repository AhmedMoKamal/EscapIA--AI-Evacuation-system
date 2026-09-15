import 'package:escapia/core/errors/error_handler.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  final dynamic report;
  ReportSuccess(this.report);
}

class ReportError extends ReportState {
  final AppError error;
  ReportError(this.error);
}