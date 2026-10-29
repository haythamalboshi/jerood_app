# تطبيق جيرود - Flutter

تطبيق عربي أولاً، RTL، بتصميم Cupertino، مع كاش محلي ومصادر بيانات مستقلة للمياه والصيدليات والطوارئ والإعلانات والمفقودات والموجودات.

## أسرع طريقة للحصول على APK بدون تثبيت Flutter
1. فك ضغط المشروع وارفع **كل الملفات** إلى مستودع GitHub.
2. اجعل الفرع `main` أو `master`.
3. افتح تبويب **Actions** ثم Workflow باسم **Build Android APK**.
4. شغّله يدوياً عبر **Run workflow** أو ادفع Commit جديداً.
5. بعد نجاح البناء، افتح التشغيل ثم نزّل Artifact باسم `jerood-release-apk`.

> الـ Workflow ينشئ مجلد Android تلقائياً، يضبط minSdk 24 وتهيئة desugaring ومتطلبات جدولة الإشعارات، ثم يبني APK Release.

## ربط Google Sheets / API
عدّل الروابط الخمسة فقط داخل:
`lib/services/google_sheets_service.dart`

- `waterUrl`
- `pharmaciesUrl`
- `emergencyUrl`
- `adsUrl`
- `lostFoundUrl`

يمكن أن يعيد كل Endpoint مصفوفة JSON مباشرة أو كائناً بالشكل `{ "data": [...] }`.

### أعمدة Lost & Found
`id, category, title, description, location, date, contact, image_url, created_at`

`category` يجب أن تكون `lost` أو `found`. ارفع الصورة إلى أي Storage/CDN ثم ضع **الرابط المباشر العام للصورة** في `image_url` للصف نفسه. لا تحتاج الواجهة لأي تعديل عند تغيير مزود الصور.

### إشعار المياه قبل 8 ساعات
الأعمدة الأساسية للمياه هي:
`neighborhood, current_status, next_status`

ولتشغيل الجدولة الدقيقة أضف:
`next_arrival_at`

بقيمة ISO-8601 فعلية، مثل `2026-10-25T18:00:00+03:00`. التطبيق لا يخترع موعداً إذا لم يوجد هذا الحقل.

## Firebase Analytics
Firebase اختياري للبناء. التطبيق يعمل إذا لم تُضف Firebase، وتتعطل Analytics بأمان فقط. لتفعيلها أضف إعداد FlutterFire المعتاد (`google-services.json` على Android، وملفات iOS عند إنشاء نسخة iOS) ثم طبّق إعدادات FlutterFire الرسمية على host project. إذا كنت تريد أن يحتفظ GitHub Actions بملف `google-services.json`، خزّنه كـ GitHub Secret/Base64 وأضف خطوة لإنشائه أثناء البناء بدلاً من رفع السر إلى المستودع.

## التشغيل محلياً (اختياري)
إذا كان Flutter مثبتاً:
```bash
flutter create --platforms=android --project-name jerood_app --org com.jerood .
flutter pub get
flutter run
```

## ملاحظة خط Cairo
يستخدم المشروع `google_fonts` لتطبيق Cairo على النصوص، ومن ضمنها عبارة: **طور بواسطة هيثم البوشي** أسفل الصفحات الرئيسية. للاستخدام المؤسسي دون أي اعتماد شبكي للخط، يمكن لاحقاً تضمين ملفات Cairo المرخصة كـ assets وتغيير إعداد الخط فقط.
