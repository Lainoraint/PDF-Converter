import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ConvertState extends Equatable {
  const ConvertState();
  
  @override
  List<Object> get props => [];
}

class ConvertInitial extends ConvertState {}

class ConvertLoading extends ConvertState {}

class ConvertSuccess extends ConvertState {
  final File pdfFile;

  const ConvertSuccess(this.pdfFile);

  @override
  List<Object> get props => [pdfFile];
}

class ConvertFailure extends ConvertState {
  final String errorMessage;

  const ConvertFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}