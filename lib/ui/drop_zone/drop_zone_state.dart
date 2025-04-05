part of 'drop_zone_cubit.dart';

sealed class DropZoneState extends Equatable {}

final class DropZoneNormal extends DropZoneState {
  @override
  List<Object?> get props => [];
}

final class DropZoneDragging extends DropZoneState {
  @override
  List<Object?> get props => [];
}

final class DropZoneItem extends DropZoneState {
  final String? path;
  DropZoneItem(this.path);

  @override
  List<Object?> get props => [path];
}
