import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInformacion extends StatefulWidget {
  const UserInformacion({super.key});

  @override
  State<UserInformacion> createState() => _UserInformacionState();
}

class _UserInformacionState extends State<UserInformacion> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadSpecificUser();
  }

  Future<void> _loadSpecificUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('SpecificUser');

    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      setState(() {
        _user = User.fromJson(jsonData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 78, bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: double.infinity,
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Información Usuario",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: navBarState.isExpanded ? 43 : 180,
                          child: navBarState.isExpanded
                              ? IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/createdUsers",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(
                                      14,
                                      145,
                                      14,
                                      1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/createdUsers",
                                    );
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Color.fromRGBO(14, 145, 14, 1),
                                      size: 22,
                                    ),
                                  ),
                                  label: const Text(
                                    "Regresar",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(
                                      14,
                                      145,
                                      14,
                                      1,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(234, 234, 234, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoRow(
                            "Tipo de Cliente:",
                            _user!.naturalPerson ? "Natural" : "Jurídico",
                          ),
                          infoRow("Rol:", _user!.role),
                          infoRow("Nombre:", _user!.name),
                          infoRow("Identificación:", _user!.identification),
                          infoRow("Email:", _user!.email),
                          infoRow("Teléfono:", _user!.phone),
                          infoRow("Dirección:", _user!.address),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Máquinas Registradas",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
