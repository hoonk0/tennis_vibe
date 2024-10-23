import 'package:flutter/material.dart';

import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../tab/tab_profile_private_information.dart';
import '../tab/tab_profile_private_use.dart';

class RouteProfilePrivate extends StatefulWidget {
  const RouteProfilePrivate({Key? key}) : super(key: key);

  @override
  State<RouteProfilePrivate> createState() => _RouteProfilePrivateState();
}

class _RouteProfilePrivateState extends State<RouteProfilePrivate> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보 및 이용약관'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            ), // Use CustomAppbar

            // Tab navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                2,
                    (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Text(
                            index == 0 ? '개인정보처리방침' : '이용약관 ',
                            style: TextStyle(
                              color: _currentPageIndex == index
                                  ? colorGreen600
                                  : colorGray500,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Gaps.v20,
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: _currentPageIndex == index
                                ? colorGreen600
                                : colorGray200,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                itemCount: 2,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return TabProfilePrivateInformation();
                    case 1:
                      return TabProfilePrivateUse();
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
