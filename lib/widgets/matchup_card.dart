import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MatchupCard extends StatelessWidget {
  
  MatchupCard({@required this.homeTeam, @required this.awayTeam, @required this.gameTime});

  final String homeTeam;
  final String awayTeam;
  final String gameTime;

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
                gameTime,
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