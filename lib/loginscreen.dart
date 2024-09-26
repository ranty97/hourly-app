import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0077B6);

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
                    bottomRight: Radius.circular(70),
                  )
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: screenWidth / 5,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 10,
              ),
              child: Text(
                "Login",
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
                  fieldTitle("Employee Id"),
                  customInputField("Enter your employee ID"),
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

  Widget customInputField(String hint) {
    return Container(
      width: screenWidth,
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
              Icons.person,
              color: primary,
              size: screenWidth / 12,
            ),
          ),
          Expanded(
            child: TextFormField(
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
            ),
          ),
        ],
      ),
    );
  }
}