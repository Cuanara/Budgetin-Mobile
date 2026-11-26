import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _tagline1 = 'Duit rapi, ';
  static const _tagline2 = 'wishlist kebeli.';

  static const _assets = <String>[
    'assets/images/alas-dompet.png',
    'assets/images/dompet2.png',
    'assets/images/kancing.png',
    'assets/images/koin-besar.png',
    'assets/images/koin-kecil.png',
    'assets/images/teks.png',
  ];

  // ===== Ukuran =====
  static const double _boxW = 204;
  static const double _boxH = 149;
  static const double _walletW = 153;
  static const double _walletH = 116;
  static const double _titleW = 187;
  static const double _titleH = 44;
  static const double _titleScale = 1.0;
  static const double _taglineSize = 18;

  static const double _baseLift = 11;

  // ===== Kancing =====
  static const double _buttonW = 41;
  static const double _buttonDx = -8;
  static const double _buttonDy = 31;

  // ===== Koin =====
  static const double _coinBigW = 61;
  static const double _coinSmallW = 49;
  static const double _coinBigVisible = 0.55;
  static const double _coinSmallVisible = 0.45;
  static const double _coinSmallDx = -24;
  static const double _coinBigDx = 17;
  static const double _coinFall = 260; // jarak jatuh koin, tidak perlu diubah

  static const double _walletTop = _boxH - _walletH;
  static const double _walletLeft = (_boxW - _walletW) / 2;

  late final AnimationController _ctrl;
  late final Animation<double> _base;
  late final Animation<double> _front;
  late final Animation<double> _button;
  late final Animation<double> _coinBig;
  late final Animation<double> _coinSmall;
  late final Animation<double> _title;
  late final Animation<double> _typing;

  bool _started = false;

  Animation<double> _step(double begin, double end, Curve curve) {
    return CurvedAnimation(
      parent: _ctrl,
      curve: Interval(begin, end, curve: curve),
    );
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4600),
    );

    // Interval saling tumpang tindih supaya gerakan mengalir
    _base = _step(0.00, 0.12, Curves.easeOutCubic);
    _front = _step(0.08, 0.20, Curves.easeOutCubic);
    _button = _step(0.18, 0.28, Curves.easeOutCubic);
    _coinBig = _step(0.26, 0.44, const Cubic(0.4, 0.0, 0.2, 1.0));
    _coinSmall = _step(0.36, 0.54, const Cubic(0.4, 0.0, 0.2, 1.0));
    _title = _step(0.52, 0.70, Curves.easeOutCubic);
    _typing = _step(0.68, 0.96, Curves.linear);

    _ctrl.addStatusListener((s) async {
      if (s == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;

        final token = Get.find<SharedPreferences>().getString(
          AppConstants.tokenKey,
        );
        final hasToken = token != null && token.isNotEmpty;

        Get.offAllNamed(hasToken ? AppRoutes.home : AppRoutes.login);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _precacheAndStart();
  }

  // Decode semua gambar dulu, baru animasi jalan (hindari patah di awal)
  Future<void> _precacheAndStart() async {
    try {
      await Future.wait(
        _assets.map((a) => precacheImage(AssetImage(a), context)),
      );
    } catch (_) {}
    if (!mounted) return;
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7F0E4), // hijau muda di atas
              Colors.white, // putih di bawah
            ],
            stops: [0.0, 0.8],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildLogo(screenW), _buildTitle(), _buildTagline()],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double screenW) {
    final bigTop = _walletTop - _coinBigW * _coinBigVisible;
    final smallTop = _walletTop - _coinSmallW * _coinSmallVisible;

    return RepaintBoundary(
      child: SizedBox(
        width: _boxW,
        height: _boxH,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Alas dompet, masuk dari kiri
            Positioned(
              left: _walletLeft,
              bottom: _baseLift,
              child: _slideX(
                anim: _base,
                from: -screenW,
                child: Image.asset(
                  'assets/images/alas-dompet.png',
                  width: _walletW,
                  height: _walletH,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 2. Koin (di atas alas, di bawah dompet2)
            Positioned(
              left: _boxW / 2 - _coinSmallW / 2 + _coinSmallDx,
              top: smallTop,
              child: _dropCoin(
                'assets/images/koin-kecil.png',
                _coinSmallW,
                _coinSmall,
              ),
            ),
            Positioned(
              left: _boxW / 2 - _coinBigW / 2 + _coinBigDx,
              top: bigTop,
              child: _dropCoin(
                'assets/images/koin-besar.png',
                _coinBigW,
                _coinBig,
              ),
            ),

            // 3. Dompet2 (depan), masuk dari kiri
            Positioned(
              left: _walletLeft,
              bottom: 0,
              child: _slideX(
                anim: _front,
                from: -screenW,
                child: Image.asset(
                  'assets/images/dompet2.png',
                  width: _walletW,
                  height: _walletH,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 4. Kancing, masuk dari kanan
            Positioned(
              left: _walletLeft + _walletW - _buttonW - _buttonDx,
              top: _walletTop + _buttonDy,
              child: _slideX(
                anim: _button,
                from: screenW,
                child: Image.asset(
                  'assets/images/kancing.png',
                  width: _buttonW,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Geser horizontal. Gambar jadi `child`, tidak dibangun ulang tiap frame.
  Widget _slideX({
    required Animation<double> anim,
    required double from,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: anim,
      child: child,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(from * (1 - anim.value), 0),
          child: child,
        );
      },
    );
  }

  // Koin jatuh + fade-in di awal supaya tidak muncul tiba-tiba
  Widget _dropCoin(String asset, double size, Animation<double> anim) {
    return AnimatedBuilder(
      animation: anim,
      child: Image.asset(asset, width: size),
      builder: (context, child) {
        final t = anim.value;
        final opacity = (t * 4).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, -_coinFall * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _title,
      child: SizedBox(
        width: _titleW,
        height: _titleH,
        child: Transform.scale(
          scale: _titleScale,
          child: Image.asset('assets/images/budgetin.png', fit: BoxFit.contain),
        ),
      ),
      builder: (context, child) {
        final t = _title.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(-40 * (1 - t), 0),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    const full = _tagline1 + _tagline2;
    const base = TextStyle(fontSize: _taglineSize);

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AnimatedBuilder(
          animation: _typing,
          builder: (context, _) {
            final n = (full.length * _typing.value).floor();
            final typed = full.substring(0, n);

            final p1 = typed.substring(0, math.min(n, _tagline1.length));
            final p2 = n > _tagline1.length
                ? typed.substring(_tagline1.length)
                : '';

            // Teks transparan mengunci lebar supaya tidak bergeser
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                const Opacity(opacity: 0, child: Text(full, style: base)),
                Text.rich(
                  TextSpan(
                    style: base,
                    children: [
                      TextSpan(
                        text: p1,
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      TextSpan(
                        text: p2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
