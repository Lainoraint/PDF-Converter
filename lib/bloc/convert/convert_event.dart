import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();
  @override
  List<Object?> get props => [];
}

class ConvertFileStarted extends ConvertEvent {
  final File inputFile;
  final bool isFromPdf;
  final String? targetFormat; 
  final String orientation; 

  const ConvertFileStarted({
    required this.inputFile,
    this.isFromPdf = false,
    this.targetFormat,
    this.orientation = 'landscape',
  });

  @override
  List<Object?> get props => [inputFile, isFromPdf, targetFormat, orientation];
}

class ConvertReset extends ConvertEvent {}