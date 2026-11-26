import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.hasError = false,
    this.onChanged,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChange);
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    _focus.dispose();
    super.dispose();
  }

  void _onTextChange() {
    setState(() {});
    final text = widget.controller.text;
    widget.onChanged?.call(text);
    if (text.length == widget.length) widget.onCompleted?.call(text);
  }

  Widget _box(int index, String text, double width, double height) {
    final filled = index < text.length;
    final cursor = text.length < widget.length ? text.length : widget.length - 1;
    final isCurrent = _focus.hasFocus && index == cursor;
    final highlighted = filled || isCurrent;

    final Color borderColor;
    if (widget.hasError) {
      borderColor = AppColors.error;
    } else if (highlighted) {
      borderColor = AppColors.primary;
    } else {
      borderColor = AppColors.inputBorder;
    }

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.hasError
            ? AppColors.errorBg
            : (filled ? Colors.white : AppColors.inputFill),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: (highlighted || widget.hasError) ? 1.5 : 1,
        ),
      ),
      child: Text(
        filled ? text[index] : '',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final boxWidth =
            ((constraints.maxWidth - gap * (widget.length - 1)) / widget.length)
                .clamp(0.0, 52.0);
        final boxHeight = boxWidth * 1.1;
        final text = widget.controller.text;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _focus.requestFocus(),
          child: SizedBox(
            height: boxHeight,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < widget.length; i++) ...[
                      if (i > 0) const SizedBox(width: gap),
                      _box(i, text, boxWidth, boxHeight),
                    ],
                  ],
                ),
                // Field asli: tidak terlihat, hanya menerima input.
                Positioned.fill(
                  child: Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      enableInteractiveSelection: false,
                      showCursor: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.length),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}