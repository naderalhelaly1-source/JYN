import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const JynApp());

// Brand
const kInk = Color(0xFF111111);
const kPink = Color(0xFFD6246E);

// Money: store prices in fils (1 KWD = 1000 fils) to avoid float errors.
String formatKwd(int fils, {bool ar = true}) {
  final s = '${fils ~/ 1000}.${(fils % 1000).toString().padLeft(3, '0')}';
  return ar ? '${_arDigits(s)} د.ك' : '$s KWD';
}

String _arDigits(String s) {
  const en = '0123456789';
  const ar = '٠١٢٣٤٥٦٧٨٩';
  return s.split('').map((c) => en.contains(c) ? ar[en.indexOf(c)] : c == '.' ? '٫' : c).join();
}

// Minimal strings (move to ARB files via flutter gen-l10n later).
const _strings = {
  'ar': {'home': 'الرئيسية', 'deals': 'عروض اليوم', 'search': 'ابحثي عن ملابس، أحذية، شنط...'},
  'en': {'home': 'Home', 'deals': "Today's deals", 'search': 'Search clothes, shoes, bags...'},
};

class JynApp extends StatefulWidget {
  const JynApp({super.key});
  @override
  State<JynApp> createState() => _JynAppState();
}

class _JynAppState extends State<JynApp> {
  Locale _locale = const Locale('ar');
  void _toggle() => setState(() => _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JYN',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kPink, primary: kPink),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: HomeScreen(onToggleLang: _toggle),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onToggleLang});
  final VoidCallback onToggleLang;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final t = _strings[lang]!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('JYN.', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 3)),
        actions: [TextButton(onPressed: onToggleLang, child: Text(lang == 'ar' ? 'EN' : 'عربي'))],
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(decoration: InputDecoration(hintText: t['search'], prefixIcon: const Icon(Icons.search), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none))),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kInk, borderRadius: BorderRadius.circular(20)),
          child: Align(alignment: AlignmentDirectional.centerStart, child: Text(t['deals']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(height: 16),
        // Placeholder product price shown in KWD
        Text(formatKwd(4750, ar: lang == 'ar'), style: const TextStyle(color: kPink, fontWeight: FontWeight.w800)),
      ]),
      bottomNavigationBar: NavigationBar(destinations: [
        NavigationDestination(icon: const Icon(Icons.home_outlined), label: t['home']!),
        const NavigationDestination(icon: Icon(Icons.grid_view), label: '—'),
        const NavigationDestination(icon: Icon(Icons.favorite_border), label: '—'),
        const NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: '—'),
        const NavigationDestination(icon: Icon(Icons.person_outline), label: '—'),
      ]),
    );
  }
}
