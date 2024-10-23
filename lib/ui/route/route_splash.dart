import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tennis_vibe/ui/route/route_main.dart';

import '../../service/stream/stream_me.dart';
import '../../static/global.dart';
import 'auth/route_auth_login.dart';

BuildContext? contextMain;

class RouteSplash extends ConsumerStatefulWidget {
  const RouteSplash({super.key});

  @override
  ConsumerState<RouteSplash> createState() => _RouteSplashState();
}

class _RouteSplashState extends ConsumerState<RouteSplash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserAndInitData();
  }

  Future<void> checkUserAndInitData() async {
    final pref = await SharedPreferences.getInstance();
    final uid = pref.getString('uid');

    try {
      Global.uid = uid;

      WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) async {
          /// FirebaseAuth에 등록되어 있지 않음: 아무것도 안함
          if (uid == null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RouteAuthLogin()));
          }

          /// FirebaseAuth에 등록되어 있음
          else {
            StreamMe.listenMe(ref);
            await Future.delayed(Duration(milliseconds: 100));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RouteMain(), settings: const RouteSettings(name: 'home')));
          }
        },
      );
    } catch (e) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RouteAuthLogin()));
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Global.contextSplash = context;
  }

  @override
  Widget build(BuildContext context) {
    Global.contextSplash = context;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 100.w,
          child: Image.asset(
            'assets/images/logo_courtvibe.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
