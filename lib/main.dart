import 'package:buscacep/cep_endereco.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primaryColor: Color(0xFFFFBF00),
      ),
      home: MyHomePage(shablaw: 'Felipao lindao'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.shablaw}) : super(key: key);

  final String shablaw;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resposta = "";
  CepEndereco cepEndereco;
  final myController = TextEditingController();


  void _incrementCounter() {
    final cepDoUsuario = myController.text;
    fetchPost(cepDoUsuario).then((response) {
      print ("codigo resposta: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        cepEndereco = CepEndereco.fromJson(responseJson);
        setState(() {
          resposta = response.body;
        });

      }

    });
   
  }

  @override
  void dispose() {

    myController.dispose();
    super.dispose();
  }

  
  Future<http.Response> fetchPost(String cep) {
    return http.get('https://viacep.com.br/ws/$cep/json/');
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shablaw),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          TextField(
            controller: myController,
            decoration: InputDecoration(
              hintText: "digite o cep"
            )
          ),

            Text(
              resposta
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Color(0xFFFFBF00),
        child: Icon(Icons.add_alert),
      ),
    );
  }
}
