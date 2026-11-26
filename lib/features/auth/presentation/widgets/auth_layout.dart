import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.child,
    this.footer,
    this.leading,
    this.topAligned = false,
  });

  final Widget child;

  /// Menempel di dasar layar (di layar pendek ikut turun dan bisa di-scroll).
  final Widget? footer;

  /// Biasanya tombol kembali, di kiri atas.
  final Widget? leading;

  /// true: konten rata atas. false: konten di tengah.
  final bool topAligned;

  static const double _verticalPadding = 24;
  static const double _maxContentWidth = 420;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth < 360 ? 16.0 : 24.0;
              final minHeight = constraints.maxHeight - (_verticalPadding * 2);

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: _verticalPadding,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minHeight > 0 ? minHeight : 0.0,
                      maxWidth: _maxContentWidth,
                    ),
                    child: _content(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _content() {
    final lead = leading == null
        ? const SizedBox.shrink()
        : Align(alignment: Alignment.centerLeft, child: leading);
    final foot = footer == null
        ? const SizedBox.shrink()
        : Padding(padding: const EdgeInsets.only(top: 24), child: footer);

    if (topAligned) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [lead, const SizedBox(height: 16), child],
          ),
          foot,
        ],
      );
    }

    // Konten di tengah ruang antara leading dan footer
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [lead, child, foot],
    );
  }
}