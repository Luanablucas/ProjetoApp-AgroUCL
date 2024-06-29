import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsProvider extends ChangeNotifier {
  Map<String, List<SensorData>> allData = {
    'Temperatura': [],
    'Cálcio': [],
    'Evapotranspiração': [],
    'Umidade': [],
  };

  final DatabaseReference _temperaturaRef =
  FirebaseDatabase.instance.ref().child('solo').child('temperatura');
  final DatabaseReference _calcioRef =
  FirebaseDatabase.instance.ref().child('solo').child('Calcio');
  final DatabaseReference _etpRef =
  FirebaseDatabase.instance.ref().child('solo').child('ETP');
  final DatabaseReference _umidadeRef =
  FirebaseDatabase.instance.ref().child('solo').child('Umidade');

  Future<void> initializeDatabase() async {
    await _loadDataFromLocal();
    _temperaturaRef.onValue.listen((event) {
      final temperatura = event.snapshot.value;
      if (temperatura != null) {
        _saveDataToLocal('Temperatura', temperatura.toString());
        _updateData('Temperatura', temperatura.toString());
      }
    });

    _calcioRef.onValue.listen((event) {
      final calcio = event.snapshot.value;
      if (calcio != null) {
        _saveDataToLocal('Cálcio', calcio.toString());
        _updateData('Cálcio', calcio.toString());
      }
    });

    _etpRef.onValue.listen((event) {
      final etp = event.snapshot.value;
      if (etp != null) {
        _saveDataToLocal('Evapotranspiração', etp.toString());
        _updateData('Evapotranspiração', etp.toString());
      }
    });

    _umidadeRef.onValue.listen((event) {
      final umidade = event.snapshot.value;
      if (umidade != null) {
        _saveDataToLocal('Umidade', umidade.toString());
        _updateData('Umidade', umidade.toString());
      }
    });
  }

  Future<void> _saveDataToLocal(String type, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(type, value);
  }

  Future<void> _loadDataFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allData.forEach((key, value) {
      String? storedValue = prefs.getString(key);
      if (storedValue != null) {
        _updateData(key, storedValue);
      }
    });
    notifyListeners();
  }

  void _updateData(String type, String value) {
    allData[type]!.insert(0, SensorData(type, value, DateTime.now()));
    notifyListeners();
  }
}

class SensorData {
  final String type;
  final String value;
  final DateTime timestampLocal;

  SensorData(this.type, this.value, this.timestampLocal);
}
