import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/utils/utils.dart';
import 'package:flutter/material.dart';

class CepCard extends StatelessWidget {
  final CepEndereco _cepEndereco;
  final VoidCallback callback;
  CepCard(this._cepEndereco, {this.callback});

  String get formataTitulo {
    return _cepEndereco.logradouro;
  }

  String get formataSubtitulo {
    return '${_cepEndereco.complemento}\n${_cepEndereco.bairro}, ${_cepEndereco.localidade} - ${_cepEndereco.uf}';
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> responseList = [

    ];

    responseList.addAll([
      ListTile(
        isThreeLine: true,
        leading: Icon(Icons.pin_drop, color: CepColors.blue),
        title: Text('$formataTitulo'),
        subtitle: Text('$formataSubtitulo'),
        onTap: callback,
      ),
    ]);
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: responseList,
          ),
        ),
      ),
    );
  }
}
