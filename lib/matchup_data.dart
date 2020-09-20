import 'services/network_util.dart';

String favoriteLeague = 'NFL';

const leagues = {
  'NFL': '4391',
  'MLB': '4424'  
};



class MatchupData {

  // gets upcoming matchup data for the given league id
  Future<dynamic> getUpcomingMatchupData(String leagueID) async {
    NetworkUtil networkUtil = NetworkUtil(url: 'https://www.thesportsdb.com/api/v1/json/1/eventsnextleague.php?id=$leagueID');
    var matchupData = await networkUtil.getData();
    return matchupData;
  }
  
}
