import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../matchup_data.dart';
import 'dart:io' show Platform;

class MatchupsScreen extends StatefulWidget {

  MatchupsScreen({this.matchupData});

  final matchupData;

  @override
  _MatchupsScreenState createState() => _MatchupsScreenState();
}

class _MatchupsScreenState extends State<MatchupsScreen> {

  String selectedLeague = favoriteLeague;
  List<String> homeTeams = [];
  List<String> awayTeams = [];
  List<String> gameTimes = [];

  @override
  void initState() {
    super.initState();
    updateUpcomingMatchups(widget.matchupData);
  }

  void updateUpcomingMatchups(dynamic matchupData) {
    setState(() {
      if (matchupData == null) {
        // popup error message here
        return;
      }
      for (int i = 0; i < matchupData['events'].length; i++) {
        homeTeams.add(matchupData['events'][i]['strHomeTeam']);
        awayTeams.add(matchupData['events'][i]['strAwayTeam']);
        gameTimes.add(formatGameTime(matchupData['events'][i]['strTimeLocal']));
      }
    });
  }

  String formatGameTime(String gameTime) {
    String retString = gameTime.substring(0, gameTime.length - 3);
    int hour = int.parse(retString.substring(0, retString.indexOf(':')));
    if (hour > 12) {
      hour = hour - 12;
      retString = hour.toString() + retString.substring(retString.indexOf(':')) + ' PM';
    } else if (hour == 12) {
      retString = retString + ' PM';
    } else {
      retString = retString + ' AM';
    }
    return retString;
  }

  // generates Android DropdownButton for android devices
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String league in leagues.keys) {
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

    for (String league in leagues.values) {
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
          MatchupCard(
            homeTeam: homeTeams[0],
            awayTeam: awayTeams[0],
            gameTime: gameTimes[0],
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

class MatchupCard extends StatelessWidget {
  
  MatchupCard({@required this.homeTeam, @required this.awayTeam, @required this.gameTime});

  String homeTeam;
  String awayTeam;
  String gameTime;

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Text(
                '$homeTeam vs $awayTeam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Text(
                gameTime,
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
    );
  }
}

