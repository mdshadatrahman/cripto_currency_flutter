import 'dart:convert';

import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.diffValue}) : super(key: key);
  final Map diffValue;

  @override
  Widget build(BuildContext context) {
    List _currencies = diffValue.keys.toList();
    List _exchangeRates = diffValue.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: diffValue.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${_currencies[index].toString().toUpperCase()} : ${_exchangeRates[index].toString()}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
