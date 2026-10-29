import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/emergency_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lost_found_screen.dart';
import 'screens/pharmacies_screen.dart';
import 'screens/water_screen.dart';
import 'services/analytics_service.dart';
import 'services/google_sheets_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AnalyticsService.instance.initialize();
  try { await NotificationService.instance.initialize(); } catch (_) {}
  runApp(const JeroodApp());
}

class JeroodApp extends StatelessWidget {
  const JeroodApp({super.key});
  @override Widget build(BuildContext context) {
    final brightness = MediaQueryData.fromView(View.of(context)).platformBrightness;
    final base = CupertinoThemeData(primaryColor: CupertinoColors.activeBlue, brightness: brightness);
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'جيرود',
      locale: const Locale('ar'),
      theme: base.copyWith(textTheme: _textTheme(base.textTheme)),
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox.shrink()),
      home: const RootTabs(),
    );
  }
  CupertinoTextThemeData _textTheme(CupertinoTextThemeData t) => t.copyWith(
    textStyle: GoogleFonts.cairo(textStyle: t.textStyle),
    actionTextStyle: GoogleFonts.cairo(textStyle: t.actionTextStyle),
    navTitleTextStyle: GoogleFonts.cairo(textStyle: t.navTitleTextStyle),
    navLargeTitleTextStyle: GoogleFonts.cairo(textStyle: t.navLargeTitleTextStyle),
    tabLabelTextStyle: GoogleFonts.cairo(textStyle: t.tabLabelTextStyle),
  );
}

class RootTabs extends StatefulWidget { const RootTabs({super.key}); @override State<RootTabs> createState()=>_RootTabsState(); }
class _RootTabsState extends State<RootTabs>{final service=GoogleSheetsService();@override Widget build(BuildContext context)=>CupertinoTabScaffold(tabBar:CupertinoTabBar(items:const [BottomNavigationBarItem(icon:Icon(CupertinoIcons.house),label:'الرئيسية'),BottomNavigationBarItem(icon:Icon(CupertinoIcons.drop),label:'المياه'),BottomNavigationBarItem(icon:Icon(CupertinoIcons.bandage),label:'الصيدليات'),BottomNavigationBarItem(icon:Icon(CupertinoIcons.phone),label:'الطوارئ'),BottomNavigationBarItem(icon:Icon(CupertinoIcons.search),label:'المفقودات')]),tabBuilder:(context,index)=>CupertinoTabView(builder:(_)=>switch(index){0=>HomeScreen(service:service),1=>WaterScreen(service:service),2=>PharmaciesScreen(service:service),3=>EmergencyScreen(service:service),_=>LostFoundScreen(service:service)}));}
