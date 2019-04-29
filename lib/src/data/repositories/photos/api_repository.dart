import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/photo/album.dart';
import '../../models/photo/photo.dart';
import '../api_criteria.dart';


class PhotoApiRepository extends RepositoryContract<PhotoAlbum, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<PhotoAlbum>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.photos.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawPhotosWithMeta = apiResponse.json();
        List<dynamic> rawPhotos = rawPhotosWithMeta["data"] as List<dynamic>;

        return ModelCollection(PhotoAlbum.fromList(rawPhotos));
    }

    Future<PhotoAlbum> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<PhotoAlbum> photos = await get(criteria);

        if(photos.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return photos.first;
        }
    }

    Future<PhotoAlbum> getById(int id) async
    {
        ApiResponse apiResponse = await _apiService
            .photos
            .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawPhotosWithMeta = apiResponse.json();

        if(!rawPhotosWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawPhotos = rawPhotosWithMeta["data"] as Map<String, dynamic>;

        return PhotoAlbum.fromMap(rawPhotos);
    }

    Future<bool> add(PhotoAlbum photoAlbum) async
    {
        return false;
    }

    Future<bool> delete(PhotoAlbum model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(PhotoAlbum model) async
    {
        return false;
    }

    Future<void> addToFavorite(Photo photo) async
    {
        try {
            ApiResponse apiResponse = await _apiService.photos.addToFavorite(photo.id);

            if(apiResponse.isOk) {
                Map<String, dynamic> jsonResponse = apiResponse.json();

                if(jsonResponse.containsKey("data")) {
                    Map<String, dynamic> jsonCounters = jsonResponse["data"] as Map<String, dynamic>;

                    if(jsonCounters.containsKey("favorites_count")) {
                        photo.favoritesCount = jsonCounters["favorites_count"] as int;
                    }

                    if(jsonCounters.containsKey("views_count")) {
                        photo.viewsCount = jsonCounters["views_count"] as int;
                    }

                    if(jsonCounters.containsKey("is_favorited")) {
                        photo.isFavorited = jsonCounters["is_favorited"] as bool;
                    }
                }
            }
        } catch(_) {
            // TODO
        }
    }

    Future<void> removeFromFavorite(Photo photo) async
    {
        try {
            ApiResponse apiResponse = await _apiService.photos.removeFromFavorite(photo.id);

            if(apiResponse.isOk) {
                Map<String, dynamic> jsonResponse = apiResponse.json();

                if(jsonResponse.containsKey("data")) {
                    Map<String, dynamic> jsonCounters = jsonResponse["data"] as Map<String, dynamic>;

                    if(jsonCounters.containsKey("favorites_count")) {
                        photo.favoritesCount = jsonCounters["favorites_count"] as int;
                    }

                    if(jsonCounters.containsKey("views_count")) {
                        photo.viewsCount = jsonCounters["views_count"] as int;
                    }

                    if(jsonCounters.containsKey("is_favorited")) {
                        photo.isFavorited = jsonCounters["is_favorited"] as bool;
                    }
                }
            }
        } catch(_) {
            // TODO
        }
    }

    Future<void> getCounters(Photo photo) async
    {
        try {
            ApiResponse apiResponse = await _apiService.news.getCounters(photo.id);

            if(apiResponse.isOk) {
                Map<String, dynamic> jsonResponse = apiResponse.json();

                if(jsonResponse.containsKey("data")) {
                    Map<String, dynamic> jsonCounters = jsonResponse["data"] as Map<String, dynamic>;

                    if(jsonCounters.containsKey("favorites_count")) {
                        photo.favoritesCount = jsonCounters["favorites_count"] as int;
                    }

                    if(jsonCounters.containsKey("views_count")) {
                        photo.viewsCount = jsonCounters["views_count"] as int;
                    }

                    if(jsonCounters.containsKey("is_favorited")) {
                        photo.isFavorited = jsonCounters["is_favorited"] as bool;
                    }
                }
            }
        } catch (_) {

        }
    }
}