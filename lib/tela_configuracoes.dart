import 'package:flutter/material.dart';
import 'package:projeto_agrouclapp/tela_acoes.dart';
import 'package:projeto_agrouclapp/tela_historico.dart';
import 'package:projeto_agrouclapp/tela_inicial.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      // Inicio do Drawer - Barra de navegações lateral
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: const Color(0xFF496945),
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: 24,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: Text(
                          user?.displayName != null ? user!.displayName![0] : '',
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.displayName ?? '',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Histórico'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoricoPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Ações'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AcoesPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Fim do Drawer
      body: const Center(
        child: Text(
          'Nessa página ficarão as configurações do app',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
