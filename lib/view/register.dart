// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/view/login.dart';
import 'package:firebase_crud/view/widgets/account_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpfController = TextEditingController();
  String id = '';

  Future signUp() async {
    var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    if (response != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }));
    }

    String generateRandomString(int len) {
      var r = Random();
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
          .join();
    }

    id = generateRandomString(10);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("usuarios").doc(id);

    Map<String, String> todoList = {
      "nome": _usernameController.text,
      "cpf": _cpfController.text,
      "telefone": _mobileNumberController.text,
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _mobileNumberController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Cadastrar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            _credential_container(context),
            AccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _credential_container(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(appPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 1,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nome completo',
            ),
            obscureText: false,
            controller: _usernameController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'E-mail',
            ),
            obscureText: false,
            controller: _emailController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Número de telefone',
            ),
            obscureText: false,
            controller: _mobileNumberController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'CPF',
            ),
            obscureText: false,
            controller: _cpfController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
            obscureText: true,
            controller: _passwordController,
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: signUp,
            child: const Text('Cadastrar'),
          )),
        ],
      ),
    );
  }
}
