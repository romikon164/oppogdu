import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/videos/video.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/videos/list.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/videos/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class VideoListPresenter extends FuturePresenterContract<List<Video>>
{
    VideoListView _view;

    ViewFutureContract<List<Video>> _delegate;

    VideoApiRepository _apiRepository = VideoApiRepository();

    VideoListPresenter(RouterContract router): super(router) {
        _view = VideoListView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Video>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadVideos();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadVideos();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadVideos() async
    {
        try {
            List<Video> _videos = await _apiRepository.get();

            _delegate.onLoad(_videos);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(_) {
            _delegate.onError();
        }
    }
}