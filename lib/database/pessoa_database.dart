import 'package:buscacep/models/pessoa.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';

class PessoaDatabase {
  DatabaseReference databaseRef;

  PessoaDatabase() {
    final database = FirebaseDatabase();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    databaseRef = database.reference().child('pessoas');
  }

  Future<void> addPessoa(Pessoa pessoa) async{
    return databaseRef.push().set(pessoa.toMap());
  }

  Future<void> updatePessoa(Pessoa pessoa) async{
    return databaseRef.child(pessoa.key).set(pessoa.toMap());
  }

  Future<void> deletePessoa(Pessoa pessoa) async{
    return databaseRef.child(pessoa.key).remove();
  }
}
