import 'package:buscacep/components/cep_card.dart';
import 'package:buscacep/database/pessoa_database.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/pessoa.dart';
import 'package:buscacep/pages/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FormPersonPage extends StatefulWidget {
  Pessoa pessoa;

  FormPersonPage({this.pessoa=null});

  @override
  _FormPersonPageState createState() => _FormPersonPageState(pessoa);
}

class _FormPersonPageState extends State<FormPersonPage> {
  _FormPersonPageState(this._pessoa);

  Pessoa _pessoa;
  PessoaDatabase database = PessoaDatabase();
  DateFormat formatter = DateFormat("dd/MM/yyyy");

  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  bool isUpdating = false;
  @override
  void initState() {
    super.initState();
    if (_pessoa != null) {
      isUpdating=true;
      nomeController.text = _pessoa.nome;
      cpfController.text = _pessoa.cpf;
      dataNascimentoController.text = formatter.format(_pessoa.dataNascimento);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CepEndereco> _enderecos;
    if (_pessoa == null) {
      _pessoa = Pessoa('', DateTime.now(), [], '', '');
    }
    _enderecos = _pessoa.enderecos;

    List<Widget> actions = [];
    if (isUpdating) {
      actions.add(IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          database.deletePessoa(_pessoa);
          Navigator.of(context).pop();
        },
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        actions: actions,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          _pessoa.nome = nomeController.text;
          _pessoa.cpf = cpfController.text;
          if (isUpdating) {
            database.updatePessoa(_pessoa);
          } else {
            database.addPessoa(_pessoa);
          }

          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                    autofocus: true,
                    controller: nomeController,
                    decoration: InputDecoration(
                        hintText: 'Digite o nome', labelText: 'Nome'
                    )
                ),
                TextFormField(
                    autofocus: true,
                    controller: cpfController,
                    decoration: InputDecoration(
                        hintText: 'Digite o cpf', labelText: 'CPF'
                    )
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                          enabled: false,
                          autofocus: true,
                          controller: dataNascimentoController,
                          decoration: InputDecoration(
                              hintText: 'Digite o cpf', labelText: 'Data Nascimento'
                          )
                      ),
                    ),
                    FlatButton(
                      child: Text('SELECIONAR'),
                      onPressed: () async {
                        DateTime selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1800),
                          lastDate: DateTime(2020),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.dark(),
                              child: child,
                            );
                          },
                        );
                        if(selectedDate != null) {
                          _pessoa.dataNascimento = selectedDate;

                          dataNascimentoController.text = formatter.format(selectedDate);
                        }
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Endereços',
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.w200),
                    ),
                    FlatButton(
                      child: Text('ADICIONAR'),
                      onPressed: () async {
                        final CepEndereco _novoCepEndereco =
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddAddressPage()),
                        );
                        if (_novoCepEndereco != null) {
                          setState(() {
                            _pessoa.enderecos.add(_novoCepEndereco);
                          });
                        }
                      },
                    )
                  ],
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _enderecos.length,
                    itemBuilder: (context, index) {
                      final CepEndereco endereco = _enderecos[index];
                      return CepCard(endereco, callback: () async {
                        final CepEndereco _novoCepEndereco =
                            await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddAddressPage(cepEndereco: endereco)),
                        );
                        if (_novoCepEndereco != null) {
                          setState(() {
                            _pessoa.enderecos[index] = _novoCepEndereco;
                          });
                        }
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
