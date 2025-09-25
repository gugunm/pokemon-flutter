// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

sealed class RemoteState extends Equatable {}

class RemoteStateNone extends RemoteState {
  @override
  List<Object?> get props => [];
}

class RemoteStateLoading extends RemoteState {
  @override
  List<Object?> get props => [];
}

class RemoteStateError extends RemoteState {
  final String message;

  RemoteStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class RemoteStateSuccess<T> extends RemoteState {
  final T data;

  RemoteStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}
