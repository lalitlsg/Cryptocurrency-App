import 'package:cryptoapp/data/crypto_data.dart';
import 'package:cryptoapp/module/crypto_presenter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements CryptoListViewContract{

  CryptoListPresenter _presenter;

  List<Crypto> _currencies;
  bool _isLoading;
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];

  _HomePageState(){
    _presenter = CryptoListPresenter(this);
  }

  @override
  void initState(){
    super.initState();
    _isLoading = true;
    _presenter.loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crypto App"),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ):_cryptoWidget()
    );
  }

  Widget _cryptoWidget() {
    return Container(
      child: Column(
        children:<Widget>[ Flexible(
          child: ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (BuildContext context, int index) {
              final Crypto currency = _currencies[index];
              final MaterialColor color = _colors[index % _colors.length];

              return _getListItemUi(currency, color);
            },
          ),
        ),
    ]
      ),
    );
  }

  @override
  void onLoadCryptoComplete(List<Crypto> items) {
    // TODO: implement onLoadCryptoComplete
    setState(() {
      _currencies = items;
      _isLoading = false;
    });
  }

  @override
  void onLoadCryptoError() {
    // TODO: implement onLoadCryptoError
  }
}

ListTile _getListItemUi(Crypto currency, MaterialColor color) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: color,
      child: Text(currency.name[0]),
    ),
    title: Text(
      currency.name,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle:
        _getSubtitleText(currency.price_usd, currency.percent_change_1h),
    isThreeLine: true,
  );
}

Widget _getSubtitleText(String priceUSD, String percentageChange) {
  TextSpan priceTextWidget =
      TextSpan(text: '\$$priceUSD\n', style: TextStyle(color: Colors.black87));
  String percentageChangeText = '1 hour : $percentageChange%';
  TextSpan percentageChangeTextWidget;

  if (double.parse(percentageChange) > 0) {
    percentageChangeTextWidget = TextSpan(
        text: percentageChangeText, style: TextStyle(color: Colors.green));
  } else {
    percentageChangeTextWidget = TextSpan(
        text: percentageChangeText, style: TextStyle(color: Colors.red));
  }
  return RichText(
    text: TextSpan(children: [priceTextWidget, percentageChangeTextWidget]),
  );
}
