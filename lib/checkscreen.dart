import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'model/user.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0077B6);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Nexa Regular",
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Employee ${User.username}",
                style: TextStyle(
                  fontFamily: "Nexa Bold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 34),
              child: Text(
                "Today's status",
                style: TextStyle(
                  fontFamily: "Nexa Bold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 140,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 13,
                    offset: Offset(2, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                                fontFamily: "Nexa Regular",
                                fontSize: screenWidth / 20,
                                color: Colors.black54
                            ),
                          ),
                          Text(
                              "09:30",
                              style: TextStyle(
                                  fontFamily: "Nexa Bold",
                                  fontSize: screenWidth / 18,
                                  color: Colors.black
                              )
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check OUT",
                            style: TextStyle(
                              fontFamily: "Nexa Regular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54
                            ),
                          ),
                          Text(
                              "--/--",
                              style: TextStyle(
                                fontFamily: "Nexa Bold",
                                fontSize: screenWidth / 18,
                                color: Colors.black
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 20),
              child: RichText(
                  text: TextSpan(
                    text: "${DateTime.now().day} ",
                    style: TextStyle(
                      color: primary,
                      fontSize: screenWidth / 18,
                      fontFamily: "Nexa Bold",
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat('MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 20,
                          fontFamily: "Nexa Bold",
                        )
                      )
                    ]
                  ),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                        fontFamily: "Nexa Regular",
                        fontSize: screenWidth / 18 ,
                        color: Colors.black54
                    ),
                  ),
                );
              }
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Builder(
                  builder: (context) {
                    final GlobalKey<SlideActionState> key = GlobalKey();

                    return SlideAction(
                      text: "Slide to Check Out",
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 19,
                      ),
                      outerColor: Colors.white,
                      innerColor: primary,
                      key: key,
                      onSubmit: () {
                        print(DateFormat('mm:hh').format(DateTime.now()));

                      },
                    );
                  },
              ),
            )
          ],
        ),
      )
    );  }
}