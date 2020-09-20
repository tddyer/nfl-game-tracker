import 'package:sports_tracker/widgets/matchup_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../matchup_data.dart';



class MatchupsScreen extends StatefulWidget {

  MatchupsScreen({this.matchupData});

  final matchupData;

  @override
  _MatchupsScreenState createState() => _MatchupsScreenState();
}

class _MatchupsScreenState extends State<MatchupsScreen> {

  String selectedLeague = favoriteLeague;
  
  // holds MatchupCards to be displayed in listview
  List<MatchupCard> matchups = [];

  // api data lists
  List<String> homeTeams = [];
  List<String> awayTeams = [];
  List<String> gameTimes = [];
  List<DateTime> gameDates = [];

  // populate api data lists upon creation of screen with matchup data
  // passed over from loading screen and build matchup cards for display
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
    gameDates = [];

    setState(() {
      if (matchupData == null) {
        // popup error message here
        return;
      } else {
        for (int i = 0; i < matchupData['events'].length; i++) {
          homeTeams.add(matchupData['events'][i]['strHomeTeam']);
          awayTeams.add(matchupData['events'][i]['strAwayTeam']);
          gameTimes.add(MatchupCard.formatGameTime(matchupData['events'][i]['strTimeLocal']));
          gameDates.add(DateTime.parse(matchupData['events'][i]['dateEventLocal']));
        }
      }
    });
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
        gameDate: gameDates[i],
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
      onChanged: (value) {
        selectedLeague = value;
        onLeagueChange();
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
      onSelectedItemChanged: (ind)  {
        selectedLeague = pickerItems[ind].data;
        onLeagueChange();
      },
      children: pickerItems,
    );
  }

  // called when user changes league -> updates data from api + populates new data into matchup cards
  void onLeagueChange() async {
    var matchupData = await MatchupData().getUpcomingMatchupData(leagues[selectedLeague]);
    updateUpcomingMatchups(matchupData);
    setState(() {  
      buildMatchupCards();
    });
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
