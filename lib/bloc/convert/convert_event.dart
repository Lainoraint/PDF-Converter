import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();

  @override
  List<Object> get props => [];
}

class ConvertFileStarted extends ConvertEvent {
  final File inputFile;

  const ConvertFileStarted(this.inputFile);

  @override
  List<Object> get props => [inputFile];
}