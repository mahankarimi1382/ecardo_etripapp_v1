# 🌍 eCardo etrip — اپ رزرو اقامتگاه eCardo

**اپ فلاتر مستقل «etrip»** — سامانه رزرو هتل/اقامت زیرمجموعهٔ eCardo.

این اپ دقیقاً از همان بک‌اند، API و منطق «eCardo Travel» در سوپر اپ `ecardo_userapp_v1` استفاده می‌کند، اما به‌صورت یک اپ جداگانه با برند و هویت مستقل (etrip) ارائه می‌شود.

## ✨ امکانات مشترک با سوپر اپ eCardo
- **ورود / ثبت‌نام** — با همان حساب eCardo (همان API احراز)
- **کیف پول eCardo** — نمایش موجودی، شارژ (Add Money) با همان کیف پول
- **پروفایل eCardo** — ویرایش پروفایل، تغییر رمز، امنیت دو مرحله‌ای، پشتیبانی
- **تراکنش‌ها** — تاریخچهٔ کامل کیف پول

## 🏨 ماژول سفر (Travel)
- جستجوی هتل (شهر، تاریخ ورود/خروج، بزرگسال/کودک)
- مشاهدهٔ جزئیات هتل، اتاق‌ها و قیمت‌ها
- انتخاب اتاق و تعداد
- تکمیل رزرو (اطلاعات مهمان)
- پرداخت از کیف پول eCardo (Wallet Capture — همان منطق سوپر اپ)
- پیگیری سفارش‌ها و ووچرها

> بک‌اند: `https://trip.ecardo.ir/api/v1` (travel-edge → travel-origin) — همان که سوپر اپ استفاده می‌کند.

## 🛠 ساختار
```
lib/
├── main.dart                      # ورودی اپ (Firebase + services)
├── l10n/                          # ترجمه (fa/en/ar/ru/zh)
└── src/
    ├── app/                       # تنظیمات، تم، روتر، ناوبری
    ├── common/                    # ویجت‌ها و سرویس‌های مشترک
    ├── helper/                    # توابع کمکی
    ├── network/                   # Dio + TokenService (secure storage)
    └── presentation/
        └── screens/
            ├── authentication/    # ورود/ثبت‌نام/فراموشی رمز
            ├── home/              # خانه + کیف پول
            ├── wallets/           # کیف پول‌ها
            ├── add_money/         # شارژ کیف پول
            ├── transactions/      # تراکنش‌ها
            ├── settings/          # پروفایل/تنظیمات/پشتیبانی
            └── travel/            # سفر (جستجو/جزئیات/رزرو/سفارش‌ها)
```

## 🤖 CI/CD (GitHub Actions)
| Workflow | خروجی |
|---|---|
| `flutter.yml` | Android APK (release) + artifact |
| `web.yml` | Flutter Web (release) + artifact |
| `ios.yml` | iOS build (no-codesign) + log |

هر push روی `main` هر سه بیلد را اجرا می‌کند (workflow_dispatch هم فعال است).

## 🔧 بیلد محلی
```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build apk --release   # خروجی: build/app/outputs/flutter-apk/app-release.apk
flutter build web --release   # خروجی: build/web
flutter build ios --release --no-codesign   # (روی macOS)
```

## 📌 نکات
- نام پکیج: `ecardo_etrip` — applicationId اندروید: `com.ecardo.etrip` — bundle id iOS: `com.ecardo.etrip`
- تم: سرمه‌ای تیره + طلایی (برند etrip)
- امنیت: توکن در `flutter_secure_storage` (Android Keystore / iOS Keychain)
- بدون تغییر در سوپر اپ / بک‌اند — این ریپو مستقل است.

---
© ۲۰۲۶ eCardo — ساخته‌شده برای سفرهای بهتر.
