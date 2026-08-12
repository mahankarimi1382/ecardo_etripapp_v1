import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';

/// LanguageDropdown — منوی انتخاب زبان (فارسی/انگلیسی/عربی/روسی/چینی)
///
/// زبان را تغییر می‌دهد و در SettingsService ذخیره می‌کند؛
/// با `Get.updateLocale` راست‌چین/چپ‌چین و ترجمه‌ها خودکار به‌روز می‌شوند.
class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  static const List<({String code, String label, String flag})> _languages = [
    (code: 'fa', label: 'فارسی', flag: '🇮🇷'),
    (code: 'en', label: 'English', flag: '🇬🇧'),
    (code: 'ar', label: 'العربية', flag: '🇸🇦'),
    (code: 'ru', label: 'Русский', flag: '🇷🇺'),
    (code: 'zh', label: '中文', flag: '🇨🇳'),
  ];

  Future<void> _change(String code) async {
    await Get.find<SettingsService>().saveLanguageLocaleCurrentState(code);
    Get.updateLocale(Locale(code));
  }

  @override
  Widget build(BuildContext context) {
    final current = Get.locale?.languageCode.toLowerCase() ?? 'en';
    return PopupMenuButton<String>(
      tooltip: 'Language',
      icon: Icon(
        Icons.translate_rounded,
        color: TravelInk,
        size: 24.r,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      onSelected: _change,
      itemBuilder: (context) => [
        for (final lang in _languages)
          PopupMenuItem(
            value: lang.code,
            child: Row(
              children: [
                Text(lang.flag, style: TextStyle(fontSize: 18.sp)),
                SizedBox(width: 10.w),
                Text(
                  lang.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: lang.code == current
                        ? const Color(0xFFD4AF37)
                        : TravelInk,
                  ),
                ),
                if (lang.code == current) ...[
                  const Spacer(),
                  const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Color(0xFFD4AF37),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

const Color TravelInk = Color(0xFF191C1D);
