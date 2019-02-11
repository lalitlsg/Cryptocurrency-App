import 'package:cryptoapp/data/crypto_data.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdCryptoRepository implements CryptoRepository{
  String cryptoUrl = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
  @override
  Future<List<Crypto>> fetchCurrencies() async{

    http.Response response = await http.get(cryptoUrl);
    final List responseBody =  json.decode(response.body);
    final statusCode = response.statusCode;
    if(statusCode != 200 || responseBody == null){
      throw FetchDataException("An error occured : [Status Code : $statusCode]");
    }
    return responseBody.map((c) => Crypto.fromMap(c)).toList();
  }

}
