import 'package:buscacep/components/cep_card.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/general_exception.dart';
import 'package:buscacep/service/cep_service.dart' as service;
import 'package:buscacep/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca CEP',
      theme: ThemeData(
        primaryColor: CepColors.yellow,
        accentColor: CepColors.blue
      ),
      home: MyHomePage(title: 'Busca CEP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _resposta = "";
  CepEndereco _cepEndereco;

  bool isLoading = false;
  final myController = MaskedTextController(mask: '00000-000');

  void _getCEP() async {
    _setLoading(true);
    final cepDoUsuario = myController.text;
    try {
      _cepEndereco = await service.getCep(cepDoUsuario);
    } on GeneralException catch (e) {
      _resposta = e.errorMessage();
    } finally {
      _setLoading(false);
      _atualizaCampo(_resposta);
    }
  }

  void _atualizaCampo(String valor) {
    setState(() {
      _resposta = valor;
    });
  }

  void _setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildLayout(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCEP,
        tooltip: 'Busca Cep',
        backgroundColor: CepColors.blue,
        child: Icon(Icons.search),
      ),
    );
  }

  List<Widget> _buildLayout() {
    return [
      TextField(
          keyboardType: TextInputType.number,
          controller: myController,
          decoration: InputDecoration(
              hintText: "Digite o cep"
          )
      ),
      isLoading ? _buildCircularIndicator() : _buildCepCard(),
    ];
  }

  Widget _buildCircularIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCepCard() {
    return CepCard(_cepEndereco, _resposta);
  }
}
