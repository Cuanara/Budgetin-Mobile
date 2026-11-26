import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';

class _TermsSection {
  const _TermsSection(this.title, this.body);

  final String title;
  final String body;
}

const _sections = <_TermsSection>[
  _TermsSection(
    '1. Penerimaan syarat',
    'Dengan membuat akun, kamu menyetujui syarat penggunaan Budgetin yang berlaku.',
  ),
  _TermsSection(
    '2. Akun dan keamanan',
    'Kamu bertanggung jawab menjaga kerahasiaan email dan kata sandi akunmu.',
  ),
  _TermsSection(
    '3. Data keuangan',
    'Data budget, tabungan, dan transaksi hanya dipakai untuk menampilkan fitur di aplikasi.',
  ),
  _TermsSection(
    '4. Penggunaan yang wajar',
    'Budgetin tidak boleh dipakai untuk kegiatan yang melanggar hukum atau merugikan pengguna lain.',
  ),
  _TermsSection(
    '5. Perubahan Syarat',
    'Syarat dapat diperbarui. Kami akan memberi tahu kamu bila ada perubahan penting.',
  ),
];

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  static const String updatedAt = 'Diperbarui 18 November 2026';

  /// Hasilnya true kalau user menekan "Saya mengerti".
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const TermsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Syarat dan Ketentuan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  updatedAt,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Isi bisa di-scroll kalau layar pendek
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _sections.length; i++) ...[
                        if (i > 0) const SizedBox(height: 14),
                        Text(
                          _sections[i].title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _sections[i].body,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Tutup',
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Saya mengerti',
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}