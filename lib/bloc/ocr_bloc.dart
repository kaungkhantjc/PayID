import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_id/ocr/ocr_result.dart';
import '../constants.dart';
import '../ocr/ocr_process.dart';

sealed class OcrEvent {}

class UpdatePath extends OcrEvent {
  final String path;

  UpdatePath(this.path);
}

class StartProcessing extends OcrEvent {}

class OcrState extends Equatable {
  final String? currentPath;
  final bool isProcessing;
  final OcrResult? result;

  const OcrState({this.currentPath, this.isProcessing = false, this.result});

  OcrState copyWith({
    String? currentPath,
    bool? isProcessing,
    OcrResult? result,
  }) {
    return OcrState(
      currentPath: currentPath ?? this.currentPath,
      isProcessing: isProcessing ?? this.isProcessing,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [currentPath, isProcessing, result];
}

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrBloc() : super(const OcrState()) {
    on<UpdatePath>((event, emit) {
      emit(state.copyWith(currentPath: event.path, result: null));
    });

    on<StartProcessing>((event, emit) async {
      if (state.isProcessing || state.currentPath == null) return;
      final path = state.currentPath!;
      emit(state.copyWith(isProcessing: true));
      try {
        final ocrResult = await performOcrTask(path);
        if (state.currentPath == path) {
          emit(state.copyWith(isProcessing: false, result: ocrResult));
        }
      } catch (e) {
        if (state.currentPath == path) {
          String error =
              (e is ProcessException &&
                      (e.message.contains(
                            "The system cannot find the file specified.",
                          ) ||
                          e.message.contains("No such file or directory")))
                  ? msgTesseractNotInstalled
                  : e.toString();
          emit(
            state.copyWith(
              isProcessing: false,
              result: OcrResult(null, null, error),
            ),
          );
        }
      }
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      add(UpdatePath(path));
      add(StartProcessing());
    }
  }
}
