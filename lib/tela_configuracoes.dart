import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projeto_agrouclapp/tela_historico.dart';
import 'package:projeto_agrouclapp/tela_inicial.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  static int notificationId = 0;
  late DatabaseReference _temperaturaRef;
  late DatabaseReference _calcioRef;
  late DatabaseReference _etpRef;
  late DatabaseReference _umidadeRef;
  String _temperatura = '';
  String _calcio = '';
  String _etp = '';
  String _umidade = '';
  late User _user;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _getUserData();

    // Inicializando o FlutterLocalNotificationsPlugin
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('app_icon');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser!;
    setState(() {});
  }

  Future<void> _initializeDatabase() async {
    await Firebase.initializeApp();
    _temperaturaRef =
        FirebaseDatabase.instance.ref().child('solo').child('temperatura');
    _calcioRef = FirebaseDatabase.instance.ref().child('solo').child('Calcio');
    _etpRef = FirebaseDatabase.instance.ref().child('solo').child('ETP');
    _umidadeRef =
        FirebaseDatabase.instance.ref().child('solo').child('Umidade');

    _temperaturaRef.onValue.listen((event) {
      final temperatura = event.snapshot.value;

      if (temperatura != null) {
        setState(() {
          _temperatura = temperatura.toString();
        });
        double tempValue = double.tryParse(temperatura.toString()) ?? 0.0;
        if (tempValue >= 30 || tempValue <= 0) {
          _showNotification('Atenção!', 'A temperatura está fora do esperado.');
        }
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
        double calcioValue = double.tryParse(calcio.toString()) ?? 0.0;
        if (calcioValue >= 15 || calcioValue <= 0) {
          _showNotification(
              'Atenção!', 'O valor de cálcio está fora do esperado.');
        }
      } else {
        setState(() {
          _calcio = 'Valor de cálcio não encontrado.';
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
        double etpValue = double.tryParse(evapotranspiracao.toString()) ?? 0.0;
        if (etpValue >= 5 || etpValue <= 0) {
          _showNotification(
              'Atenção!', 'O valor de ETP está fora do esperado.');
        }
      } else {
        setState(() {
          _etp = 'Valor de ETP não encontrado.';
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
        double umidadeValue = double.tryParse(umidade.toString()) ?? 0.0;
        if (umidadeValue >= 20 || umidadeValue <= 0) {
          _showNotification(
              'Atenção!', 'O valor de umidade está fora do esperado.');
        }
      } else {
        setState(() {
          _umidade = 'Valor de umidade não encontrado.';
        });
      }
    }, onError: (Object error) {
      setState(() {
        _umidade = 'Erro ao carregar os dados.';
      });
    });
  }
 // Lógica de notificações
  Future<void> _showNotification(String title, String body) async {
    try {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel one',
        'High priority notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      // Use o contador estático para gerar IDs únicos
      int uniqueId = notificationId++;

      await flutterLocalNotificationsPlugin.show(
        uniqueId,
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Erro ao exibir notificação: $e');
    }
  }
  // Lógica dos widgets
  Widget _buildSensorWidget(String label, String value) {
    Color borderColor = Colors.green;
    String statusMessage = 'Dentro do esperado';

    // Lógica para determinar a cor da borda e o status
    if (label == 'Temperatura') {
      double tempValue = double.tryParse(value) ?? 0.0;
      if (tempValue >= 30 || tempValue <= 0) {
        borderColor = Colors.red;
        statusMessage = 'Fora do esperado';
      }
    } else if (label == 'Cálcio') {
      double calcioValue = double.tryParse(value) ?? 0.0;
      if (calcioValue >= 15 || calcioValue <= 0) {
        borderColor = Colors.red;
        statusMessage = 'Fora do esperado';
      }
    } else if (label == 'ETP') {
      double etpValue = double.tryParse(value) ?? 0.0;
      if (etpValue >= 5 || etpValue <= 0) {
        borderColor = Colors.red;
        statusMessage = 'Fora do esperado';
      }
    } else if (label == 'Umidade') {
      double umidadeValue = double.tryParse(value) ?? 0.0;
      if (umidadeValue >= 20 || umidadeValue <= 0) {
        borderColor = Colors.red;
        statusMessage = 'Fora do esperado';
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Valor atual: $value',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            statusMessage,
            style: TextStyle(
              fontSize: 16,
              color: borderColor == Colors.green ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
  // Tela configurações front
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
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
                  child: Column( // Iniciando a costumização da barra de navegação
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: _user.displayName != null && _user.displayName!.isNotEmpty
                            ? Text(
                          _user.displayName![0],
                          style: const TextStyle(fontSize: 36),
                        )
                            : const Icon(
                          Icons.person,
                          size: 52,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 1),
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
                    MaterialPageRoute(builder: (context) => const HistoricoPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfiguracoesPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSensorWidget('Temperatura', _temperatura),
            _buildSensorWidget('Cálcio', _calcio),
            _buildSensorWidget('ETP', _etp),
            _buildSensorWidget('Umidade', _umidade),
            const Spacer(),
            Opacity(
              opacity: 0.7,
              child: Center(
                child: Image.asset(
                  'assets/images/fazenda-inteligente.png',
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
