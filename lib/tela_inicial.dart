import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:projeto_agrouclapp/tela_acoes.dart';
import 'package:projeto_agrouclapp/tela_configuracoes.dart';
import 'package:projeto_agrouclapp/tela_historico.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

// Pegando dados do RTDB e declarando as variáveis
class _HomePageState extends State<HomePage> {
  late DatabaseReference _temperaturaRef;
  late DatabaseReference _calcioRef;
  late DatabaseReference _etpRef;
  late DatabaseReference _umidadeRef;
  String _temperatura = '';
  String _calcio = '';
  String _etp = '';
  String _umidade = '';
  late User _user;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _getUserData();
  }

  Future<void> _getUserData() async { // Pegando informações do usuário atual
    _user = FirebaseAuth.instance.currentUser!;
    setState(() {}); //
  }

  Future<void> _initializeDatabase() async { // Pegando referências diretas do Firebase
    await Firebase.initializeApp();
    _temperaturaRef = FirebaseDatabase.instance.ref().child('solo').child('temperatura');
    _calcioRef = FirebaseDatabase.instance.ref().child('solo').child('Calcio');
    _etpRef = FirebaseDatabase.instance.ref().child('solo').child('ETP');
    _umidadeRef = FirebaseDatabase.instance.ref().child('solo').child('Umidade');

    _temperaturaRef.onValue.listen((event) { //Atribuindo dados para as variáveis
      final temperatura = event.snapshot.value;

      if (temperatura != null) {
        setState(() {
          _temperatura = temperatura.toString();
        });
      } else {
        setState(() {
          _temperatura = 'Valor de temperatura não encontrado.';
        });
      }
    }, onError: (Object error) {
      setState(() {
        _temperatura = 'Erro ao carregar os dados.';
      });
    });

    _calcioRef.onValue.listen((event) {
      final calcio = event.snapshot.value;

      if (calcio != null) {
        setState(() {
          _calcio = calcio.toString();
        });
      } else {
        setState(() {
          _calcio = 'Valor do Cálcio não encontrado.';
        });
      }
    }, onError: (Object error) {
      setState(() {
        _calcio = 'Erro ao carregar os dados.';
      });
    });

    _etpRef.onValue.listen((event) {
      final evapotranspiracao = event.snapshot.value;

      if (evapotranspiracao != null) {
        setState(() {
          _etp = evapotranspiracao.toString();
        });
      } else {
        setState(() {
          _etp = 'Valor do ETP não encontrado.';
        });
      }
    }, onError: (Object error) {
      setState(() {
        _etp = 'Erro ao carregar os dados.';
      });
    });

    _umidadeRef.onValue.listen((event) {
      final umidade = event.snapshot.value;

      if (umidade != null) {
        setState(() {
          _umidade = umidade.toString();
        });
      } else {
        setState(() {
          _umidade = 'Valor do ETP não encontrado.';
        });
      }
    }, onError: (Object error) {
      setState(() {
        _umidade = 'Erro ao carregar os dados.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      // Inicio do Drawer - Barra de navegação lateral
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
                  child: Column(    // Iniciando a costumização da barra de navegação
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: Text(
                          _user.displayName != null ? _user.displayName![0] : '',
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _user.displayName ?? '',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _user.email ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(  // Opções da barra de navegação
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
      body: Center(  // Código da página inicial, onde deve ficar as leituras dos sensores
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'assets/images/blackberry.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 280,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thermostat_outlined, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Temperatura atual:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _temperatura,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
              width: 280,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(Icons.local_florist, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Cálcio:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _calcio,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
              width: 280,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_outlined, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Evapotranspiração:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _etp,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
              width: 280,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.opacity_outlined, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Umidade:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _umidade,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
