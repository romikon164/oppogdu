import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/news/comment.dart';
import '../api_criteria.dart';


class CommentsApiRepository extends RepositoryContract<Comment, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Comment>> get(ApiCriteria criteria, {String deviceToken}) async
    {
        int newsId = criteria.getFilterValueByName("news_id");

        ApiResponse apiResponse = await _apiService.news.getComments(newsId);

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawCommentsWithMeta = apiResponse.json();

        List<dynamic> rawComments = rawCommentsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Comment.fromList(rawComments));
    }

    Future<ModelCollection<Comment>> getByNewsId(int newsId) async
    {
        ApiResponse apiResponse = await _apiService.news.getComments(newsId);

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawCommentsWithMeta = apiResponse.json();

        List<dynamic> rawComments = rawCommentsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Comment.fromList(rawComments));
    }

    Future<Comment> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        criteria.take(1);

        ModelCollection<Comment> comments = await get(criteria, deviceToken: deviceToken);

        if(comments.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return comments.first;
        }
    }

    Future<bool> add(Comment comment) async
    {
        ApiResponse apiResponse = await _apiService.news.sendComment(comment.newsId, comment.text);

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawCommentWithMeta = apiResponse.json();

        Map<String, dynamic> rawComment = rawCommentWithMeta["data"] as Map<String, dynamic>;

        if(rawComment.containsKey("id")) {
            comment.id = rawComment["id"] as int;
            return true;
        }

        return false;
    }

    Future<bool> delete(Comment comment) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Comment comment) async
    {
        return false;
    }
}