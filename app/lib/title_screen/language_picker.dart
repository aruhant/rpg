import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ramayana/title_screen/title_screen.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(50),
          ),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          child: const Text('Language/भाषा')),
      onSelected: (Locale language) {
        context.setLocale(language);
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const TitleScreen(),
            transitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Locale>>[
          PopupMenuItem<Locale>(
            value: Locale('en', 'US'),
            child: Text('English'),
          ),
          PopupMenuItem<Locale>(
            value: Locale('hi', 'IN'),
            child: Text('Hindi'),
          ),
        ];
      },
    );
  }
}
