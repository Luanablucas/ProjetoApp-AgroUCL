import 'package:flutter/material.dart';
import 'package:projeto_agrouclapp/tela_acoes.dart';
import 'package:projeto_agrouclapp/tela_configuracoes.dart';
import 'package:projeto_agrouclapp/tela_inicial.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  String _selectedOption = 'Selecione o histórico';

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),
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
                    MaterialPageRoute(builder: (context) => AcoesPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfiguracoesPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButton<String>(
                value: _selectedOption,
                items: <String>[
                  'Selecione o histórico',
                  'ETP',
                  'Temperatura'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                    if (_selectedOption == 'ETP') {
                      Navigator.pushNamed(context, '/historico_etp');
                    } else if (_selectedOption == 'Temperatura') {
                      Navigator.pushNamed(context, '/historico_temperatura');
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/historico.png',
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
