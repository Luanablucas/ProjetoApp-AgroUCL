import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:projeto_agrouclapp/tela_configuracoes.dart';
import 'package:projeto_agrouclapp/tela_historico.dart';
import 'package:projeto_agrouclapp/tela_inicial.dart';

class AcoesPage extends StatefulWidget {
  const AcoesPage({super.key});

  @override
  _AcoesPageState createState() => _AcoesPageState();
}

class _AcoesPageState extends State<AcoesPage> {
  late DatabaseReference _databaseReference;
  bool? ledStatus;
  late User _user;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('solo').child('led');

    // Configurar um listener para monitorar mudanças no valor do LED em tempo real
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value is bool) {
        setState(() {
          ledStatus = event.snapshot.value as bool?;
        });
      } else {
        // Tratar o caso em que o valor não é do tipo esperado
        print('O valor lido para o estado do LED não é válido');
      }
    }, onError: (error) {
      // Tratar erros ao acessar o banco de dados
      print('Erro ao acessar o banco de dados: $error');
    });

    _getUserData(); // Chame o método para obter os dados do usuário
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser!; // Obtenha o usuário atual
    setState(() {});
  }

  void updateLED(bool status) {
    // Atualiza o estado do LED no Firebase
    _databaseReference.set(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ações'),
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
                          _user.displayName != null ? _user.displayName![0] : '', // Exibe as iniciais do nome do usuário
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _user.displayName ?? '', // Exibe o nome do usuário se disponível
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _user.email ?? '', // Exibe o email do usuário se disponível
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
                    MaterialPageRoute(builder: (context) => const HomePage()),
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Acionador de LED',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (ledStatus != null) {
                    // Ao pressionar o botão, inverte o estado do LED
                    updateLED(!ledStatus!);
                    setState(() {
                      ledStatus = !ledStatus!;
                    });
                  } else {
                    // Tratar o caso em que não há dados disponíveis
                    print('Nenhum dado disponível para o estado do LED');
                  }
                },
                icon: const Icon(
                  Icons.lightbulb,
                  size: 30,
                  color: Colors.green,
                ),
                label: Text(
                  ledStatus != null ? (ledStatus! ? 'Desligar' : 'Ligar') : 'Carregando...',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
