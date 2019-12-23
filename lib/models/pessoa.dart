

import 'dart:collection';

import 'package:buscacep/models/cep_endereco.dart';

class Pessoa {
    Pessoa(this.nome, this.dataNascimento, this.enderecos, this.cpf, this.key);
    String key;
    String nome;
    DateTime dataNascimento;
    String cpf;
    List<CepEndereco> enderecos;

    factory Pessoa.fromJson(Map<String, dynamic> json, String key) {
        final name = json['nome'];
        final dateTime = DateTime.fromMillisecondsSinceEpoch(json["dataNascimento"]);
        final List<dynamic> enderecosList = json['enderecos'];
        final enderecos = enderecosList.map((map)=> CepEndereco.fromJson(Map.from(map))).toList(growable: true);
        final cpf = json['cpf'];
        print(json);
        return Pessoa(name, dateTime, enderecos, cpf, key);
    }

    Map<String, dynamic> toMap() {
        List<Map<String, dynamic>> enderecosMap = enderecos.map((end) => end.toMap()).toList();
        return {
            'nome': this.nome,
            'dataNascimento': this.dataNascimento.millisecondsSinceEpoch,
            'cpf': this.cpf,
            'enderecos': enderecosMap
        };
    }
}

