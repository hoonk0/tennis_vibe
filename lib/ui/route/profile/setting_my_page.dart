import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../const/value/colors.dart';
import '../../../../../../const/value/text_style.dart';
import '../alarm/user_alarm.dart';
import '../favorite/court_favorite.dart';

class SettingMyPage extends StatelessWidget {
  const SettingMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe8e8e8),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Account Management',
            style: GoogleFonts.anton(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color: colorGreen900,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CourtFavorite(),
                        ),
                      );
                    },
                    child: Text(
                      '선호 코트',
                      style: GoogleFonts.anton(
                        textStyle: const TS.s16w500(colorGreen900),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CourtFavorite(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.star_border_purple500_outlined),
                    color: colorGreen900,
                  ),
                ],
              ),
            ),



            const Divider(
              height: 32,
            thickness: 2,
            color: colorGreen900,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserAlarm(),
                        ),
                      );
                    },
                    child: Text(
                      '알림 코트',
                      style: GoogleFonts.anton(
                        textStyle: const TS.s16w500(colorGreen900),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserAlarm(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none),
                    color: colorGreen900,
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
