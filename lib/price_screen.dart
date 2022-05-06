import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  // String selectedCoin = 'BTC';
  String baseApiUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';
  Map<String, String> valuesInSelectedCoinInCurrency = Map();
  NetworkHelper networkHelper = NetworkHelper();

  DropdownButton<String> andoridDropdown() {
    return DropdownButton(
      value: selectedCurrency,
      items: currenciesList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      onChanged: (dynamic? value) async {
        var tempMap = await getCoinInCurreny(value);
        setState(() {
          selectedCurrency = value!;
          valuesInSelectedCoinInCurrency = tempMap;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (int selectedIndex) async {
        var tempCurrency = currenciesList[selectedIndex];
        var tempMap = await getCoinInCurreny(tempCurrency);
        setState(() {
          selectedCurrency = tempCurrency;
          valuesInSelectedCoinInCurrency = tempMap;
        });
      },
      itemExtent: 32.0,
      children: currenciesList.map<Widget>((String value) {
        return Text(value);
      }).toList(),
    );
  }

  List<Widget> getColumnChildren() {
    var cryptButtons = cryptoList.map((String crypt) {
      return getCryptButton(crypt);
    }).toList();

    List<Widget> wList = [];
    wList.addAll(cryptButtons);

    var ddl = Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? iOSPicker() : andoridDropdown(),
    );

    wList.add(ddl);
    return wList;
  }

  Widget getCryptButton(String crypt) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypt = ${valuesInSelectedCoinInCurrency[crypt]} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>> getCoinInCurreny(String currency) async {
    Map<String, String> tempMap = Map();
    for (String crypt in cryptoList) {
      dynamic respBody =
          await networkHelper.getData('$baseApiUrl$crypt$currency');
      print('$baseApiUrl$crypt$currency');
      double bid = respBody['bid'];
      tempMap[crypt] = bid.toStringAsFixed(2);
    }

    print('map is: $tempMap');
    return tempMap;
  }

  void initVariables() async {
    var tempCoinInCur = await getCoinInCurreny(selectedCurrency);
    setState(() {
      valuesInSelectedCoinInCurrency = tempCoinInCur;
    });
  }

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getColumnChildren(),
      ),
    );
  }
}
