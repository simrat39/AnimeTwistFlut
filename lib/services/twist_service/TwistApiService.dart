// Project imports:
import 'EpisodesApiService.dart';
import '../../models/TwistModel.dart';
import '../../models/EpisodeModel.dart';
import 'AnimeApiService.dart';
import 'MOTDApiService.dart';
import 'DonationApiService.dart';

class TwistApiService {
  static List<TwistModel> allTwistModel = [];

  Future setTwistModels() async {
    AnimeApiService animeApiService = AnimeApiService();
    allTwistModel = await animeApiService.getAllTwistModel();
  }

  Future<List<EpisodeModel>> getEpisodesForSource(
      {TwistModel twistModel}) async {
    EpisodeApiService episodeApiService = EpisodeApiService();
    return await episodeApiService.getEpisodes(twistModel);
  }

  Future<List<String>> getMOTD() async {
    MOTDApiService motdApiService = MOTDApiService();
    return await motdApiService.getMOTD();
  }

  Future<List<int>> getDonationsData() async {
    DonationApiService motdApiService = DonationApiService();
    return await motdApiService.getDonations();
  }
}
