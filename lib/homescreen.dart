import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hourly/calendarscreen.dart';
import 'package:hourly/checkscreen.dart';
import 'package:hourly/model/user.dart';
import 'package:hourly/profilescreen.dart';
import 'package:hourly/service/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String id = '';

  Color primary = const Color(0xFF0077B6);
  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarDay,
    FontAwesomeIcons.check,
    FontAwesomeIcons.userTie,
  ];

  @override
  void initState() {
    super.initState();
    _startLocationService();
    getId().then((onValue) {
      _getCredentials();
      _getProfilePic();
    });
  }

  void _getProfilePic() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("Employees").doc(User.id).get();
    setState(() {
      User.profilePicLink = doc['profilePicLink'];
    });
  }

  void _getCredentials() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("Employees").doc(User.id).get();
      setState(() {
        User.canEdit = doc['canEdit'];
        User.firstName = doc['firstName'];
        User.lastName = doc['lastName'];
        User.birthDate = doc['birthDate'];
        User.address = doc['address'];
      });
    } catch (e) {
      return;
    }
  }

  void _startLocationService() async {
    LocationService().initialize();

    LocationService().getLongitude().then((onValue) {
      setState(() {
        User.long = onValue!;
      });

      LocationService().getLatitude().then((onValue) {
        setState(() {
          User.lat = onValue!;
        });
      });
    });
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employees")
        .where('id', isEqualTo: User.employeeId)
        .get();

    setState(() {
      User.id = snap.docs[0].id;
    });
  }

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
                            size: i == currentIndex ? 30 : 24,
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