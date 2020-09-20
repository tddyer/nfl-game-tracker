import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../matchup_data.dart';
import 'dart:io' show Platform;
import 'package:sports_tracker/widgets/matchup_card.dart';

class MatchupsScreen extends StatefulWidget {

  MatchupsScreen({this.matchupData});

  final matchupData;

  @override
  _MatchupsScreenState createState() => _MatchupsScreenState();
}

class _MatchupsScreenState extends State<MatchupsScreen> {

  // TODO: add dates to matchup cards
  String selectedLeague = favoriteLeague;
  List<MatchupCard> matchups = [];

  // api data lists
  List<String> homeTeams = [];
  List<String> awayTeams = [];
  List<String> gameTimes = [];

  // populate api data lists with matchup data passed over from loading screen
  // and build matchup cards for display
  @override
  void initState() {
    super.initState();
    updateUpcomingMatchups(widget.matchupData);
    buildMatchupCards();
  }

  void updateUpcomingMatchups(dynamic matchupData) {
    // clearing old matchup data from lists
    homeTeams = [];
    awayTeams = [];
    gameTimes = [];

    setState(() {
      if (matchupData == null) {
        // popup error message here
        return;
      } else {
        for (int i = 0; i < matchupData['events'].length; i++) {
          homeTeams.add(matchupData['events'][i]['strHomeTeam']);
          awayTeams.add(matchupData['events'][i]['strAwayTeam']);
          gameTimes.add(formatGameTime(matchupData['events'][i]['strTimeLocal']));
        }
      }
    });
  }

  // formats gameTime strings to include AM/PM
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

  // builds MatchupCards using api data lists
  void buildMatchupCards() {
    // clear out any matchups that were present
    matchups = [];
    
    for (int i = 0; i < homeTeams.length; i++) {
      MatchupCard matchup = MatchupCard(
        homeTeam: homeTeams[i],
        awayTeam: awayTeams[i],
        gameTime: gameTimes[i],
      );
      matchups.add(matchup);
    }
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
      onChanged: (value) async {
        selectedLeague = value;
        var matchupData = await MatchupData().getUpcomingMatchupData(leagues[value]);
        updateUpcomingMatchups(matchupData);
        setState(() {  
          buildMatchupCards();
        });
      },
    );
  }

  // generates iOS CupertinePicker for iOS devices
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String league in leagues.keys) {
      pickerItems.add(Text(league));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (ind) async {
        selectedLeague = pickerItems[ind].data;
        var matchupData = await MatchupData().getUpcomingMatchupData(leagues[selectedLeague]);
        updateUpcomingMatchups(matchupData);
        setState(() {  
          buildMatchupCards();
        });
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
          Expanded(
            child: ListView(
              children: matchups,
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
