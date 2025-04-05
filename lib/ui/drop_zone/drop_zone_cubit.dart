import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import '../../app_utils.dart';

part 'drop_zone_state.dart';

class DropZoneCubit extends Cubit<DropZoneState> {
  DropZoneCubit() : super(DropZoneNormal());

  void setDragging(bool isDragging) {
    emit(isDragging ? DropZoneDragging() : DropZoneNormal());
  }

  Future<void> handleDropEvent(PerformDropEvent event) async {
    final item = event.session.items.first;
    final reader = item.dataReader!;
    if (reader.canProvide(Formats.plainText)) {
      reader.getValue<String>(Formats.plainText, (str) {
        _handleDroppedItem(str);
      });
    } else if (reader.canProvide(Formats.fileUri)) {
      reader.getValue<Uri>(Formats.fileUri, (uri) {
        _handleDroppedItem(uri?.toFilePath());
      });
    }
    setDragging(false);
  }

  void _handleDroppedItem(String? path) => emit(
    DropZoneItem((path != null && (isUrl(path) || isFile(path))) ? path : null),
  );
}
