import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'analytics_provider.dart'; // Importe o seu AnalyticsProvider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_agrouclapp/tela_configuracoes.dart';
import 'package:projeto_agrouclapp/tela_inicial.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({Key? key}) : super(key: key);

  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  late AnalyticsProvider analyticsProvider;
  late User _user;

  @override
  void initState() {
    super.initState();
    analyticsProvider = Provider.of<AnalyticsProvider>(context, listen: false);
    analyticsProvider.initializeDatabase();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser!;
    setState(() {});
  }

  // drawer - barra de navegações lateral
  @override
  Widget build(BuildContext context) {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Histórico'),
                onTap: () {
                  Navigator.pop(context); // Fecha o drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, analyticsProvider, child) {
          return ListView(
            children: analyticsProvider.allData.entries.map((entry) {
              String sensorType = entry.key;
              List<SensorData> sensorDataList = entry.value;
              return buildSensorSection(sensorType, sensorDataList);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildSensorSection(String sensorType, List<SensorData> sensorDataList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sensorType,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sensorDataList.length,
          itemBuilder: (context, index) {
            var sensorData = sensorDataList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${sensorData.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(sensorData.timestampLocal), // Histórico
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
