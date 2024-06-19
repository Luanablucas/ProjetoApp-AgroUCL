import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_agrouclapp/tela_cadastro.dart';
import 'package:projeto_agrouclapp/tela_esqueceusenha.dart';
import 'package:projeto_agrouclapp/tela_inicial.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _senhaError = false;

  void _validateSenha(String value) {
    if (value.isEmpty) {
      setState(() {
        _senhaError = true;
      });
    } else {
      setState(() {
        _senhaError = false;
      });
    }
  }

  Future<void> _showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Color(0xFF5EAF53), width: 2.0),
          ),
          title: const Text('Erro de autenticação'),
          content: const Text('Falha ao fazer login. Por favor, tente novamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Mostra o pop-up de erro
      _showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 350,
                  height: 350,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _senhaController,
                    onChanged: _validateSenha,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      errorText: _senhaError ? 'Campo obrigatório' : null,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (!_senhaError) {
                      _signIn(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EsqueceuSenhaPage()),
                    );
                  },
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
