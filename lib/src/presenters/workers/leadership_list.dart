import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/workers/leadership_list.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/workers/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class LeadershipListPresenter extends FuturePresenterContract<List<Worker>>
{
    LeadershipListView _view;

    ViewFutureContract<List<Worker>> _delegate;

    WorkerApiRepository _apiRepository = WorkerApiRepository();

    LeadershipListPresenter(RouterContract router): super(router) {
        _view = LeadershipListView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Worker>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadLeaderships();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadLeaderships();
    }

    void didTapLeadershipItem(Worker worker)
    {
        router.presentWorkerDetail(worker.id);
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadLeaderships() async
    {
        try {
            List<Worker> _leaderships = await _apiRepository.getLeaderships();

            _delegate.onLoad(_leaderships);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(_) {
            _delegate.onError();
        }
    }
}