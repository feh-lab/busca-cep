
import 'package:buscacep/pages/list_person_page.dart';
import 'package:buscacep/utils/utils.dart';
import 'package:flutter/material.dart';


void main() => runApp(MainApp());

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca CEP',
      theme: ThemeData(
        primaryColor: CepColors.yellow,
        accentColor: CepColors.blue
      ),
      home: ListPersonPage(),
    );
  }
}

