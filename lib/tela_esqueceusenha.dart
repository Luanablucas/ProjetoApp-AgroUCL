import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_agrouclapp/tela_login.dart';

class EsqueceuSenhaPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  EsqueceuSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esqueceu a Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _resetPassword(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white, // Texto branco
              ),
              child: const Text('Enviar E-mail de Recuperação'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5EAF53), foregroundColor: Colors.white, // Texto branco
              ),
              child: const Text('Voltar para o Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      // Mostrar uma mensagem de sucesso ao usuário
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Color(0xFF5EAF53), width: 2.0),
            ),
            title: Text('E-mail Enviado'),
            content: Text(
                'Um e-mail de recuperação de senha foi enviado para ${_emailController.text.trim()}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF5EAF53), // Texto branco
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Tratar erros de envio de e-mail
      print('Erro ao enviar e-mail de recuperação de senha: $e');
      // Mostrar uma mensagem de erro ao usuário
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Color(0xFF5EAF53), width: 2.0),
            ),
            title: const Text('Erro'),
            content: const Text(
                'Não foi possível enviar o e-mail de recuperação de senha. Por favor, verifique o e-mail e tente novamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF5EAF53), // Texto branco
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
