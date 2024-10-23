import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hourly/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0077B6);

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 3,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(300),
                    //bottomLeft: Radius.circular(45)
                  )
              ),
              child: Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: screenWidth / 5,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 18,
              ),
              child: Text(
                "Вход",
                style: TextStyle(
                  fontSize: screenWidth / 10,
                  fontFamily: "Nexa Bold",
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth / 12,
                vertical: screenHeight / 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle("ID Сотрудника"),
                  customInputField("Введите свой ID", idController, Icons.person, false),
                  fieldTitle("Пароль"),
                  customInputField("Введите свой пароль", passwordController, Icons.key, true),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      String id = idController.text.trim();
                      String password = passwordController.text.trim();

                      if (id.isEmpty) {
                        showCustomBottomSheet(context, "ID не заполнен");
                      } else if (password.isEmpty) {
                        showCustomBottomSheet(context, "Пароль не заполнен");
                      } else {
                        QuerySnapshot snap = await FirebaseFirestore.instance
                            .collection("Employees")
                            .where('id', isEqualTo: id)
                            .get();

                        try {
                          if(password == snap.docs[0]['password']) {
                            sharedPreferences = await SharedPreferences.getInstance();
                            
                            sharedPreferences.setString('employeeId', id).then((_) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen()));
                            });

                          } else {
                            showCustomBottomSheet(context, "Неправильный пароль");
                          }
                        } catch (e) {
                          String error = "";
                          if (e.toString() == "RangeError (length): Invalid value: Valid value range is empty: 0") {
                            setState(() {
                              error = "ID не существует";
                            });
                          } else {
                            setState(() {
                              error = "Error occurred";
                            });
                          }
                          showCustomBottomSheet(context, error);
                        }
                      }
                    },
                    child: Container(
                      height: 65,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: screenHeight / 200),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: const BorderRadius.all(Radius.circular(35))
                      ),
                      child: Center(
                        child: Text(
                            "Продолжить",
                            style: TextStyle(
                              fontSize: screenWidth / 15,
                              fontFamily: "Nexa Bold",
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 20,
          fontFamily: "Nexa Bold",
        ),
      ),
    );
  }

  Widget customInputField(String hint, TextEditingController controller, IconData icon, bool obscure) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 60),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2)
            )
          ]
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 8,
            child: Icon(
              icon,
              color: primary,
              size: screenWidth / 12,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showCustomBottomSheet(BuildContext context, String message) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.redAccent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.redAccent, backgroundColor: Colors.white, shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}