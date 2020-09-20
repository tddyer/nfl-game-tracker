import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sports_tracker/utilities/constants.dart';


class MatchupCard extends StatelessWidget {
  
  MatchupCard({@required this.homeTeam, @required this.awayTeam, @required this.gameTime, @required this.gameDate});

  final String homeTeam;
  final String awayTeam;
  final String gameTime;
  final DateTime gameDate;

  // formats gameTime strings to include AM/PM
  static String formatGameTime(String gameTime) {
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

  @override
  Widget build(BuildContext context) {

    double teamsFontSize = 20.0;

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
              AutoSizeText(
                '$homeTeam vs $awayTeam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: teamsFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 5.0,
                width: double.infinity,
              ),
              Text(
                '$gameTime - ${daysOfWeek[gameDate.weekday]}, ${gameDate.month}/${gameDate.day}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: teamsFontSize - 4.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}