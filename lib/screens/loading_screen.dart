import 'package:flutter/material.dart';
import 'matchups_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sports_tracker/matchup_data.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    getFavoritedMatchupData();
  }

  // get matchup data for favorited leage
  void getFavoritedMatchupData() async {

    // get weather data for current location
    var nflMatchups = await MatchupData().getUpcomingMatchupData(favoriteLeagueID);    

    // transfer weather data to location screen
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MatchupsScreen(matchupData: nflMatchups);
    }));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRipple(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}