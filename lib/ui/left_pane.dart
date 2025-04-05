import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_id/bloc/ocr_bloc.dart';
import 'package:pay_id/ocr/ocr_result.dart';
import '../bloc/window_settings_cubit.dart';

class LeftPane extends StatelessWidget {
  const LeftPane({super.key});

  @override
  Widget build(BuildContext context) {
    OcrBloc ocrBloc = context.read<OcrBloc>();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          BlocBuilder<WindowSettingsCubit, bool>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<WindowSettingsCubit>().setAlwaysOnTop(!state);
                },
                child: Row(
                  spacing: 16.0,
                  children: [
                    Expanded(flex: 1, child: Text("Always on top")),
                    ToggleSwitch(
                      checked: state,
                      onChanged: (value) {
                        context.read<WindowSettingsCubit>().setAlwaysOnTop(
                          value,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 16),

          Row(
            spacing: 10.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: BlocBuilder<OcrBloc, OcrState>(
                  builder: (context, state) {
                    return TextBox(
                      placeholder: "Image path",
                      maxLines: null,
                      controller: TextEditingController(
                        text: state.currentPath ?? '',
                      ),
                      onChanged: (value) {
                        ocrBloc.add(UpdatePath(value));
                        ocrBloc.add(StartProcessing());
                      },
                    );
                  },
                ),
              ),
              Button(
                child: const Text("Select"),
                onPressed: () => ocrBloc.pickFile(),
              ),
            ],
          ),

          SizedBox(height: 10),

          Expanded(flex: 1, child: _buildProcessView(context)),
        ],
      ),
    );
  }
}

_buildProcessView(BuildContext context) {
  return BlocBuilder<OcrBloc, OcrState>(
    builder: (context, state) {
      if (state.isProcessing) {
        return Center(child: ProgressRing());
      } else if (state.result?.payData != null) {
        return ResultView(state.result!.payData!);
      } else {
        return Spacer();
      }
    },
  );
}

class ResultView extends StatefulWidget {
  final PayData payData;

  const ResultView(this.payData, {super.key});

  @override
  State<StatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  String userInput = "";

  void copyTransactionID() async {
    Clipboard.setData(ClipboardData(text: widget.payData.transactionId ?? ""));

    await displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: const Text('Transaction ID copied'),
          severity: InfoBarSeverity.success,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.payData.type.label,
              style: FluentTheme.of(context).typography.bodyLarge,
            ),

            FilledButton(
              onPressed: copyTransactionID,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.copy),
                  SizedBox(width: 5),
                  Text("Copy"),
                ],
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(5),
          child: SelectableText.rich(
            buildTextSpan(widget.payData.transactionId ?? ""),
            style: FluentTheme.of(
              context,
            ).typography.title?.copyWith(fontSize: 22),
          ),
        ),
        SizedBox(
          height: 100.0,
          child: TextBox(
            expands: false,
            onChanged: (str) => setState(() => userInput = str),
            maxLines: null,
            textAlign: TextAlign.end,
            padding: EdgeInsets.all(10),
            style: FluentTheme.of(context).typography.bodyLarge,
            placeholder: "Compare with",
          ),
        ),
      ],
    );
  }

  TextSpan buildTextSpan(String transactionId) {
    int n = transactionId.length;
    int k = userInput.length;
    List<TextSpan> spans = [];

    for (int i = 0; i < n; i++) {
      Color color;
      if (i < n - k) {
        // Characters before the comparison region (from the end) are black
        color = Colors.black;
      } else {
        // Compare characters in the overlapping region from the end
        int j = i - (n - k);
        if (transactionId[i] == userInput[j]) {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
      }
      spans.add(
        TextSpan(text: transactionId[i], style: TextStyle(color: color)),
      );
    }

    return TextSpan(children: spans);
  }
}
