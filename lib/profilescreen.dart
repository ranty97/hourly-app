import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hourly/model/user.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0077B6);
  String birth = "Дата рождения";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return  Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: screenHeight / 20, bottom: screenHeight / 35),
              height: 120,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primary,
              ),
              child: const Center(
                child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Сотрудник ${User.employeeId}",
                  style: const TextStyle(
                    fontFamily: "Nexa Bold",
                    fontSize: 18,
                  ),
            )),
            const SizedBox(height: 24,),
            customTextField(primary, "Имя", firstNameController),
            customTextField(primary, "Фамилия", lastNameController),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Дата рождения",
                style: TextStyle(
                  fontFamily: "Nexa Bold",
                  color: Colors.black87,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1924),
                    lastDate: DateTime.now(),
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
                ).then((onValue) {
                  setState(() {
                    birth = DateFormat("dd/MM/yyyy").format(onValue!);
                  });
                });
              },
              child: Container(
                height: kToolbarHeight,
                width: screenWidth,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(left: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black54,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    birth,
                    style: const TextStyle(
                    fontFamily: "Nexa Bold",
                    color: Colors.black54,
                      fontSize: 16,
                  ),
                  ),
                ),
              ),
            ),
            customTextField(primary, "Адрес", addressController),
            GestureDetector(
              onTap: () async {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String address = addressController.text;
                String birthDate = birth;
                
                if(User.canEdit) {
                  if(firstName.isEmpty) {
                    showSnackBar("Пожалуйста введите своe имя");
                  } else if(lastName.isEmpty) {
                    showSnackBar("Пожалуйста введите свою фамилию");
                  } else if(address.isEmpty) {
                    showSnackBar("Пожалуйста введите свой адрес");
                  } else if(birth.isEmpty) {
                    showSnackBar("Пожалуйста введите дату рождения");
                  } else {
                    await FirebaseFirestore.instance.collection("Employees").doc(User.id).update(
                      {
                        'firstName': firstName,
                        'lastName': lastName,
                        'address': address,
                        'birthDate': birth,
                        'canEdit': false,
                      }
                    );
                  }
                } else {
                  showSnackBar("Вы не можете редактировать");
                }
              },
              child: Container(
                height: kToolbarHeight,
                width: screenWidth,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(left: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: primary,
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      "СОХРАНИТЬ",
                      style: TextStyle(
                        fontFamily: "Nexa Bold",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Widget customTextField(Color color, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: const TextStyle(
              fontFamily: "Nexa Bold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            cursorColor: color,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontFamily: "Nexa Bold",
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                    )
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                    )
                )
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}

