import 'package:buscacep/models/cep_endereco.dart';
import 'package:buscacep/models/general_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<CepEndereco> getCep(String cep) async {
    final response = await http.get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      if (responseJson["erro"] != null) {
        throw GeneralException(message: "CEP Não Encontrado");
      }

      return CepEndereco.fromJson(responseJson);
    } else {
      throw GeneralException(message:"CEP Invalido");
    }
}