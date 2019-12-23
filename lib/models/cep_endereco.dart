class CepEndereco {
  
  CepEndereco(this.cep, this.logradouro, this.complemento, this.bairro,
      this.localidade, this.uf, this.unidade, this.ibge, this.gia);

  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String unidade;
  final String ibge;
  final String gia;

  factory CepEndereco.fromJson(Map<String, dynamic> json) {
    return CepEndereco(
        json['cep'],
        json['logradouro'],
        json['complemento'],
        json['bairro'],
        json['localidade'],
        json['uf'],
        json['unidade'],
        json['ibge'],
        json['gia']);
  }

  Map<String, dynamic> toMap() {
    return {
      'cep': this.cep,
      'logradouro' : this.logradouro,
      'complemento' : this.complemento,
      'bairro' : this.bairro,
      'localidade' : this.localidade,
      'uf' : this.uf,
      'unidade' : this.unidade,
      'ibge' : this.ibge,
      'gia' : this.gia,

    };
  }
}
