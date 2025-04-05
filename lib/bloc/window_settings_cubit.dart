import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class WindowSettingsCubit extends Cubit<bool> {
  WindowSettingsCubit() : super(false);

  void setAlwaysOnTop(bool value) {
    emit(value);
    windowManager.setAlwaysOnTop(value);
  }
}