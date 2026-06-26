import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:convert_doc/repository/document_repository.dart'; 
import 'convert_event.dart';
import 'convert_state.dart';

class ConvertBloc extends Bloc<ConvertEvent, ConvertState> {
  final DocumentRepository repository;

  ConvertBloc({required this.repository}) : super(ConvertInitial()) {
    on<ConvertFileStarted>(_onConvertFileStarted);
    on<ConvertReset>((event, emit) => emit(ConvertInitial())); 
  }

  Future<void> _onConvertFileStarted(
    ConvertFileStarted event,
    Emitter<ConvertState> emit,
  ) async {
    emit(ConvertLoading());

    try {
      File resultFile;
      
      if (event.isFromPdf) {
        if (event.targetFormat == null) throw Exception("Target format belum ditentukan.");
        resultFile = await repository.convertFromPdf(event.inputFile, event.targetFormat!);
      } else {
        resultFile = await repository.convertToPdf(event.inputFile, orientation: event.orientation);
      }
      
      emit(ConvertSuccess(resultFile));
    } catch (e) {
      emit(ConvertFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}