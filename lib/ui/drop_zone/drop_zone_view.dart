import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../bloc/ocr_bloc.dart';
import 'drop_zone_cubit.dart';

class DropZoneView extends StatelessWidget {
  final Widget child;

  const DropZoneView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropZoneCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<DropZoneCubit, DropZoneState>(
            listener: (context, state) {
              if (state is DropZoneItem && state.path != null) {
                context.read<OcrBloc>().add(UpdatePath(state.path!));
                context.read<OcrBloc>().add(StartProcessing());
              }
            },
            child: DropRegion(
              onDropEnter:
                  (event) => context.read<DropZoneCubit>().setDragging(true),
              formats: const [...Formats.standardFormats],
              hitTestBehavior: HitTestBehavior.opaque,
              onDropOver: (event) {
                context.read<DropZoneCubit>().setDragging(true);
                return event.session.allowedOperations.firstOrNull ??
                    DropOperation.none;
              },
              onPerformDrop:
                  (event) =>
                      context.read<DropZoneCubit>().handleDropEvent(event),
              onDropLeave:
                  (event) => context.read<DropZoneCubit>().setDragging(false),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  child,
                  BlocBuilder<DropZoneCubit, DropZoneState>(
                    builder: (context, state) {
                      return state is DropZoneDragging
                          ? _buildPasteOverlay(context)
                          : const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasteOverlay(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: FluentTheme.of(context).accentColor.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: FluentTheme.of(context).accentColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FluentIcons.paste),
            Text("Paste", style: FluentTheme.of(context).typography.bodyStrong),
          ],
        ),
      ),
    );
  }
}
