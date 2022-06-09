import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AccountCheck({Key? key, required this.login, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Ainda não tem uma conta?" : "Você já tem conta?",
          style: const TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? " Registrar" : " Entrar?",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
