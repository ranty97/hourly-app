import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hourly/calendarscreen.dart';
import 'package:hourly/checkscreen.dart';
import 'package:hourly/profilescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0077B6);
  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarDay,
    FontAwesomeIcons.check,
    FontAwesomeIcons.userTie,
  ];

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: const [
          CalendarScreen(),
          CheckScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: screenHeight / 43,
          left: 12,
          right: 12,
        ),
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(navigationIcons.length, (i) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                    _pageController.jumpToPage(i);
                  },
                  child: SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            navigationIcons[i],
                            color: i == currentIndex ? primary : Colors.black26,
                            size: i == currentIndex ? 30 : 26,
                          ),
                          if (currentIndex == i) ...[
                            Container(
                              margin: EdgeInsets.all(screenWidth / 100),
                              height: 3,
                              width: 24,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                color: primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}