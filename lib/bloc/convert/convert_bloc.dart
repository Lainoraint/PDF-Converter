import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:convert_doc/repository/document_repository.dart'; 
import 'convert_event.dart';
import 'convert_state.dart';

class ConvertBloc extends Bloc<ConvertEvent, ConvertState> {
  final DocumentRepository repository;

  ConvertBloc({required this.repository}) : super(ConvertInitial()) {
    on<ConvertFileStarted>(_onConvertFileStarted);
  }

  Future<void> _onConvertFileStarted(
    ConvertFileStarted event,
    Emitter<ConvertState> emit,
  ) async {
    emit(ConvertLoading());

    try {
      final pdfFile = await repository.convertToPdf(event.inputFile);
      
      emit(ConvertSuccess(pdfFile));
    } catch (e) {
      emit(ConvertFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}