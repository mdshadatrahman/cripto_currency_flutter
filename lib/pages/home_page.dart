import 'dart:convert';

import 'package:cripto_currency/pages/details_page.dart';
import 'package:cripto_currency/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;

  String? cryptoCoin;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
    cryptoCoin = 'bitcoin';
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropDown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = ['bitcoin', 'ethereum', 'tether', 'cardano'];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: cryptoCoin,
      items: _items,
      onChanged: (val) {
        setState((){
          cryptoCoin = val as String?;
        });
      },
      dropdownColor: Color.fromRGBO(83, 88, 206, 1),
      iconSize: 30,
      icon: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get('/coins/$cryptoCoin'),
      builder: (BuildContext _context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());
          num _usdPrice = data['market_data']['current_price']['usd'];
          num _changePercent =
              data['market_data']['price_change_percentage_24h'];
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_context) => DetailsPage(diffValue: data['market_data']['current_price']),
                    ),
                  );
                },
                child: _coinImage(
                  data['image']['large'],
                ),
              ),
              _currentPriceWidget(_usdPrice),
              _percentageChangeWidget(_changePercent),
              _descriptionCardWidget(data['description']['en']),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      rate.toStringAsFixed(2),
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChangeWidget(num change) {
    return Text(
      "${change.toStringAsFixed(2)} %",
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImage(String path) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(path),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String desc) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.9,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: Color.fromRGBO(83, 88, 206, 0.5),
      child: SingleChildScrollView(
        child: Text(
          desc,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
