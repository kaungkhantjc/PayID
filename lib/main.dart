import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_id/ui/drop_zone/drop_zone_view.dart';
import 'package:pay_id/ui/left_pane.dart';
import 'package:pay_id/ui/right_pane.dart';
import 'package:window_manager/window_manager.dart';

import 'bloc/ocr_bloc.dart';
import 'bloc/window_settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    title: "Pay ID v1.0.1",
    size: Size(700, 470),
    center: true,
    alwaysOnTop: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        selectionColor: Colors.blue.withValues(alpha: 0.5),
        fontFamily: GoogleFonts.notoSansMyanmar().fontFamily
      ),
      home: ScaffoldPage(
        padding: EdgeInsets.only(top: 5),
        content: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => WindowSettingsCubit()),
            BlocProvider(create: (context) => OcrBloc()),
          ],
          child: DropZoneView(child: MainScreen()),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // left pane
        Expanded(flex: 1, child: LeftPane()),

        // vertical divider
        SizedBox(
          width: 1,
          height: double.infinity,
          child: ColoredBox(color: Colors.grey[50]),
        ),

        // right pane
        Expanded(flex: 1, child: RightPane()),
      ],
    );
  }
}
