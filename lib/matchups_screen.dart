import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'matchup_data.dart';
import 'dart:io' show Platform;

class MatchupsScreen extends StatefulWidget {
  @override
  _MatchupsScreenState createState() => _MatchupsScreenState();
}

class _MatchupsScreenState extends State<MatchupsScreen> {

  String selectedLeague = 'NFL';

  // generates Android DropdownButton for android devices
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String league in leagues) {
      var menuItem = DropdownMenuItem(
        child: Text(league),
        value: league
      );
      dropDownItems.add(menuItem);
    }

    return DropdownButton<String>(
      value: selectedLeague,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedLeague = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {

    List<Text> pickerItems = [];

    for (String league in leagues) {
      pickerItems.add(Text(league));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matchup Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Column(
                  children: [
                    Text(
                      'Team 1 vs Team 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '12:00 PM CT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(), 
          ),
        ],
      ),
    );
  }
}

