import 'services/network_util.dart';

const nflID = '4391';
const mlbID = '4424';

// TODO: fetch list up upcoming games from api
const List<String> matchups = [];

// TODO: fetch game times from api
const List<String> gameTimes = [];

const List<String> leagues = [
  'NFL',
  'MLB'
];

class MatchupData {

  // gets upcoming matchup data for the given league id
  Future<dynamic> getUpcomingMatchupData(String leagueID) async {
    NetworkUtil networkUtil = NetworkUtil(url: 'https://www.thesportsdb.com/api/v1/json/1/eventsnextleague.php?id=$leagueID');
    var matchupData = await networkUtil.getData();
    return matchupData;
  }
}
