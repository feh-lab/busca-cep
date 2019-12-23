
import 'package:buscacep/components/cep_card.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:buscacep/service/cep_service.dart' as service;
import 'package:buscacep/models/general_exception.dart';

class AddAddressPage extends StatefulWidget {
  AddAddressPage({this.cepEndereco=null}) ;

  CepEndereco cepEndereco;

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String _mensagemErro = "";
  CepEndereco _cepEndereco;

  bool isLoading = false;
  final cepController = MaskedTextController(mask: '00000-000');
  final logradouroController = TextEditingController();
  final bairroController = TextEditingController();
  final localidadeController = TextEditingController();
  final ufController = TextEditingController();
  final complementoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.cepEndereco != null) {
      _isEnabled = true;
      _cepEndereco = widget.cepEndereco;
      cepController.text = _cepEndereco.cep;
      logradouroController.text = _cepEndereco.logradouro;
      bairroController.text = _cepEndereco.bairro;
      localidadeController.text = _cepEndereco.localidade;
      ufController.text = _cepEndereco.uf;
      complementoController.text= _cepEndereco.complemento;
    }

  }

  void _getCEP() async {
    _cepEndereco = null;
    _mensagemErro = null;

    _setLoading(true);
    try {
      final cepDoUsuario = cepController.text;
      _cepEndereco = await service.getCep(cepDoUsuario);
      _atualizaCepEndereco(_cepEndereco);
    } on GeneralException catch (e) {
      _mensagemErro = e.errorMessage();
      _atualizaMensagemErro(_mensagemErro);
    } finally {
      _setLoading(false);
    }
  }

  void _atualizaCepEndereco(CepEndereco cepEndereco) {
    setState(() {
      _isEnabled = true;
      _cepEndereco = cepEndereco;
      logradouroController.text = _cepEndereco.logradouro;
      bairroController.text = _cepEndereco.bairro;
      localidadeController.text = _cepEndereco.localidade;
      ufController.text = _cepEndereco.uf;
      complementoController.text= _cepEndereco.complemento;
    });
  }

  void _atualizaMensagemErro(String valor ) {
    setState(() {
      _mensagemErro = valor;
    });
  }

  void _setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  @override
  void dispose() {
    cepController.dispose();
    logradouroController.dispose();
    bairroController.dispose();
    localidadeController.dispose();
    ufController.dispose();
    complementoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Endereço')
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildLayout(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_cepEndereco);
        },
        tooltip: 'Busca Cep',
        backgroundColor: CepColors.blue,
        child: Icon(Icons.save),
      ),
    );
  }

  List<Widget> _buildLayout() {
    List<Widget> widgets = [
    Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                    autofocus: true,
                    controller: cepController,
                    decoration: InputDecoration(
                        hintText: 'Digite o CEP', labelText: 'CEP'
                    )),
              ),
              FlatButton(
                child: Text('BUSCAR'),
                onPressed: _getCEP,
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: logradouroController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                        hintText: 'Logradouro', labelText: 'Logradouro'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: localidadeController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                        hintText: 'Localidade', labelText: 'Localidade'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: bairroController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                        hintText: 'Bairro', labelText: 'Bairro'),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  controller: ufController,
                  enabled: _isEnabled,
                  decoration:
                  InputDecoration(hintText: 'UF', labelText: 'UF'),
                ),
              ),
            ],
          ),
          TextFormField(
            autofocus: true,
            controller: complementoController,
            enabled: _isEnabled,
            decoration:
            InputDecoration(hintText: 'Complemento', labelText: 'Complemento'),
          ),
        ]),
      ),
    ),
    ];

    if (_mensagemErro != null) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_mensagemErro),
      ));
      return widgets;
    }

    if (_cepEndereco == null && !isLoading) {
      return widgets;
    }
    if (isLoading) {
      widgets.add(_buildCircularIndicator());
    }


    return widgets;
  }

  Widget _buildCircularIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    );
  }
}