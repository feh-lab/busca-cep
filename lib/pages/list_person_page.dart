


import 'package:buscacep/database/pessoa_database.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/pessoa.dart';
import 'package:buscacep/pages/form_person_page.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ListPersonPage extends StatelessWidget {
  List<Pessoa> _personList;
  PessoaDatabase database = PessoaDatabase();
  ListPersonPage() {
    _personList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de pessoas"),
        ),
        floatingActionButton: FloatingActionButton(

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormPersonPage()),
            );
          },
          child: Icon(Icons.add),
        ),
        body: FirebaseAnimatedList(
          query: database.databaseRef,
          itemBuilder: (context, snapshot, animation, index) {
            Pessoa pessoa = Pessoa.fromJson(Map.from(snapshot.value), snapshot.key);
            final firstLetter = pessoa.nome.isEmpty ? 'F' :  pessoa.nome[0].toUpperCase() ;
            return ListTile(
              selected: true,
              leading: CircleAvatar(child: Text(firstLetter)),
              title: Text(pessoa.nome, style: TextStyle(color: Colors.black87),),
              subtitle: Text(pessoa.cpf, style: TextStyle(color: Colors.grey)),
              onTap: () {
                //Abrir a tela que edita pessoa
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPersonPage(pessoa: pessoa)),
                );
              },
            );
        })
    );
  }
}