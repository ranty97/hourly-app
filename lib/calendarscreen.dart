import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hourly/model/user.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0077B6);

  String _month = DateFormat("MMMM").format(DateTime.now());

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
                "Календарь посещений",
                style: TextStyle(
                  fontFamily: "Nexa Bold",
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    _month,
                    style: TextStyle(
                      fontFamily: "Nexa Bold",
                      fontSize: screenWidth / 20,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 32),
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2099),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primary,
                                  secondary: primary,
                                  onSecondary: Colors.white,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: primary,
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  headlineMedium: TextStyle(
                                    fontFamily: "Nexa Bold",
                                  ),
                                  bodyMedium: TextStyle(
                                    fontFamily: "Nexa Bold",
                                  )
                                )
                              ), child: child!,
                            );
                          }
                      );

                      if(month != null) {
                        setState(() {
                          _month = DateFormat('MMMM').format(month);
                        });
                      }
                    },
                    child: Text(
                      "Выберите месяц",
                      style: TextStyle(
                        fontFamily: "Nexa Bold",
                        fontSize: screenWidth / 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 1.40,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Employees")
                      .doc(User.id)
                      .collection("Record")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            return DateFormat('MMMM').format(snap[index]['date'].toDate()) == _month ? Container(
                              margin: EdgeInsets.only(top: index > 0 ? 12 : 0, left: 6, right: 6),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            DateFormat('EE\ndd').format(snap[index]['date'].toDate()),
                                            style: TextStyle(
                                              fontFamily: "Nexa Bold",
                                              fontSize: screenWidth / 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Вход",
                                          style: TextStyle(
                                              fontFamily: "Nexa Regular",
                                              fontSize: screenWidth / 20,
                                              color: Colors.black54
                                          ),
                                        ),
                                        Text(
                                            snap[index]['checkIn'],
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
                                          "Выход",
                                          style: TextStyle(
                                              fontFamily: "Nexa Regular",
                                              fontSize: screenWidth / 20,
                                              color: Colors.black54
                                          ),
                                        ),
                                        Text(
                                            snap[index]['checkOut'],
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
                            ) : const SizedBox();
                          }
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
              )
            )
          ],
        ),
      )
    );
  }
}
