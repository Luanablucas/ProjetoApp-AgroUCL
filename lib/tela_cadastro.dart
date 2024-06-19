import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_agrouclapp/tela_login.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _cpfError = false;
  bool _senhaError = false;

  void _validateCPF(String value) {
    if (value.length != 11) {
      setState(() {
        _cpfError = true;
      });
    } else {
      setState(() {
        _cpfError = false;
      });
    }
  }

  void _validateSenha(String value) {
    if (value.length < 6 || !value.contains(RegExp(r'[0-9]{6}'))) {
      setState(() {
        _senhaError = true;
      });
    } else {
      setState(() {
        _senhaError = false;
      });
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // Mostra um pop-up de sucesso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Color(0xFF5EAF53), width: 2.0),
            ),
            title: const Text('Cadastro Concluído'),
            content: const Text('Usuário cadastrado com sucesso!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF5EAF53),
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      print('Usuário cadastrado com sucesso: ${userCredential.user!.uid}');
    } catch (e) {
      // Tratar erros de cadastro
      print('Erro ao cadastrar usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cpfController,
              onChanged: _validateCPF,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CPF',
                errorText: _cpfError ? 'CPF inválido' : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              onChanged: _validateSenha,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha (mín. 6 caracteres, 6 números)',
                errorText: _senhaError ? 'Senha inválida' : null,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5EAF53), foregroundColor: Colors.white,
                ),
                child: const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
