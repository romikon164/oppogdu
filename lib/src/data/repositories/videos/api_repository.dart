import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/videos/video.dart';
import '../api_criteria.dart';


class VideoApiRepository extends RepositoryContract<Video, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Video>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.videos.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawVideosWithMeta = apiResponse.json();
        List<dynamic> rawVideos = rawVideosWithMeta["data"] as List<dynamic>;

        return ModelCollection(Video.fromList(rawVideos));
    }

    Future<Video> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<Video> videos = await get(criteria);

        if(videos.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return videos.first;
        }
    }

    Future<Video> getById(int id) async
    {
        ApiResponse apiResponse = await _apiService
          .videos
          .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawVideosWithMeta = apiResponse.json();

        if(!rawVideosWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawVideos = rawVideosWithMeta["data"] as Map<String, dynamic>;

        return Video.fromMap(rawVideos);
    }

    Future<bool> add(Video photoAlbum) async
    {
        return false;
    }

    Future<bool> delete(Video model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Video model) async
    {
        return false;
    }
}