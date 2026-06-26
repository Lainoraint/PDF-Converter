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
  final File outputFile; 

  const ConvertSuccess(this.outputFile);

  @override
  List<Object> get props => [outputFile];
}

class ConvertFailure extends ConvertState {
  final String errorMessage;
  const ConvertFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}