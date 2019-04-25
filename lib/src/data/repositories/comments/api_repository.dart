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

        Map<String, dynamic> rawCommentsWithMeta = await _apiService.retrieveNewsComments(newsId);

        List<dynamic> rawComments = rawCommentsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Comment.fromList(rawComments));
    }

    Future<ModelCollection<Comment>> getByNewsId(int newsId) async
    {
        Map<String, dynamic> rawCommentsWithMeta = await _apiService.retrieveNewsComments(newsId);

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