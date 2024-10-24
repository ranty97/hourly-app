import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";

  Color primary = const Color(0xFF0077B6);

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(User.lat, User.long);
    setState(() {
      location = "${placemark[0].street}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}";
    });
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employees")
          .where('id', isEqualTo: User.employeeId)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore
          .instance
          .collection("Employees")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05), // Адаптивные отступы
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: screenWidth * 0.08),
              child: Text(
                "Здравствуйте",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Nexa Regular",
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Сотрудник ${User.employeeId}",
                style: TextStyle(
                  fontFamily: "Nexa Bold",
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: screenWidth * 0.08),
              child: Text(
                "Сегодня",
                style: TextStyle(
                  fontFamily: "Nexa Bold",
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenWidth * 0.05),
              height: screenWidth * 0.35,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 13,
                    offset: Offset(2, 2),
                  ),
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
                          "Вход",
                          style: TextStyle(
                              fontFamily: "Nexa Regular",
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54),
                        ),
                        Text(
                          checkIn,
                          style: TextStyle(
                              fontFamily: "Nexa Bold",
                              fontSize: screenWidth * 0.045,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Выход",
                          style: TextStyle(
                              fontFamily: "Nexa Regular",
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54),
                        ),
                        Text(
                          checkOut,
                          style: TextStyle(
                              fontFamily: "Nexa Bold",
                              fontSize: screenWidth * 0.045,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: screenWidth * 0.05),
              child: RichText(
                text: TextSpan(
                  text: "${DateTime.now().day} ",
                  style: TextStyle(
                    color: primary,
                    fontSize: screenWidth * 0.045,
                    fontFamily: "Nexa Bold",
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat('MM yyyy').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontFamily: "Nexa Bold",
                      ),
                    ),
                  ],
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
                      fontSize: screenWidth * 0.045,
                      color: Colors.black54,
                    ),
                  ),
                );
              },
            ),
            checkOut == "--/--"
                ? Container(
              margin: EdgeInsets.only(top: screenWidth * 0.06, bottom: screenWidth * 0.03),
              child: Builder(
                builder: (context) {
                  final GlobalKey<SlideActionState> key = GlobalKey();

                  return SlideAction(
                    text: checkIn == "--/--" ? "Свайп для входа" : "Свайп для выхода",
                    textStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: screenWidth * 0.045,
                    ),
                    outerColor: Colors.white,
                    innerColor: primary,
                    key: key,
                    onSubmit: () async {
                      if (User.lat != 0) {
                        _getLocation();

                        QuerySnapshot snap = await FirebaseFirestore.instance
                            .collection("Employees")
                            .where('id', isEqualTo: User.employeeId)
                            .get();

                        DocumentSnapshot snap2 = await FirebaseFirestore.instance
                            .collection("Employees")
                            .doc(snap.docs[0].id)
                            .collection("Record")
                            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                            .get();

                        try {
                          String checkIn = snap2['checkIn'];
                          setState(() {
                            checkOut = DateFormat('hh:mm').format(DateTime.now());
                          });
                          await FirebaseFirestore.instance
                              .collection("Employees")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .update({
                            'date': Timestamp.now(),
                            'checkIn': checkIn,
                            'checkOut': DateFormat('hh:mm a').format(DateTime.now()),
                            'checkInLocation': location,
                          });
                        } catch (e) {
                          setState(() {
                            checkIn = DateFormat('hh:mm').format(DateTime.now());
                          });
                          await FirebaseFirestore.instance
                              .collection("Employees")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .set({
                            'date': Timestamp.now(),
                            'checkIn': DateFormat('hh:mm a').format(DateTime.now()),
                            'checkOut': "--/--",
                            'checkOutLocation': location,
                          });
                        }
                        key.currentState!.reset();
                      } else {
                        Timer(const Duration(seconds: 3), () async {
                          _getLocation();

                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employees")
                              .where('id', isEqualTo: User.employeeId)
                              .get();

                          DocumentSnapshot snap2 = await FirebaseFirestore.instance
                              .collection("Employees")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .get();

                          try {
                            String checkIn = snap2['checkIn'];
                            setState(() {
                              checkOut = DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance
                                .collection("Employees")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .update({
                              'date': Timestamp.now(),
                              'checkIn': checkIn,
                              'checkOut': DateFormat('hh:mm a').format(DateTime.now()),
                              'location': location,
                            });
                          } catch (e) {
                            setState(() {
                              checkIn = DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance
                                .collection("Employees")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .set({
                              'date': Timestamp.now(),
                              'checkIn': DateFormat('hh:mm a').format(DateTime.now()),
                              'checkOut': "--/--",
                              'location': location,
                            });
                          }
                          key.currentState!.reset();
                        });
                      }
                    },
                  );
                },
              ),
            )
                : Container(
              margin: EdgeInsets.only(top: screenWidth * 0.08, bottom: screenWidth * 0.08),
              child: Text(
                "День завершен",
                style: TextStyle(
                  fontFamily: "Nexa Regular",
                  fontSize: screenWidth * 0.045,
                  color: Colors.black54,
                ),
              ),
            ),
            location != " "
                ? Text(
              "Геопозиция: $location",
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}