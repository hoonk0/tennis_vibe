import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:tennis_vibe/ui/route/route_splash.dart';

import 'const/value/colors.dart';
import 'const/value/text_style.dart';
///tennis_reminder
void main() async {

/*
  //kakao login
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '5796f23d8e91feb7fe43c219fbdf4f01',
    javaScriptAppKey: '36fec2addf0579f3883e41811e7d2ee2',
  );

  setPathUrlStrategy();
  //firebase login
*/

  runApp(const ProviderScope(child: TennisReminder()));
}

class TennisReminder extends StatelessWidget {
  const TennisReminder({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          navigatorObservers: [RouteObserver()],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Pretendard',
            scaffoldBackgroundColor: colorWhite,
            appBarTheme: AppBarTheme(
              backgroundColor: colorWhite,
              shadowColor: null,
              scrolledUnderElevation: 0,
              foregroundColor: colorGray900,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TS.s18w600(colorGray900),
              iconTheme: const IconThemeData(color: colorGray900),
            ),
          ),
          home: const RouteSplash(),
        );
      },
    );
  }
}
