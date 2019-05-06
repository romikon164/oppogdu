import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/workers/detail.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/workers/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class WorkerDetailPresenter extends FuturePresenterContract<Worker>
{
    int _workerId;

    Worker _worker;

    WorkerDetailView _view;

    ViewFutureContract<Worker> _delegate;

    WorkerApiRepository _apiRepository = WorkerApiRepository();

    WorkerDetailPresenter(RouterContract router, {@required int id}): super(router) {
        _workerId = id;
        _view = WorkerDetailView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<Worker> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadWorkerData();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadWorkerData();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadWorkerData() async
    {
        try {
            _worker = await _apiRepository.getById(_workerId);

            _delegate.onLoad(_worker);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(e) {
            _delegate.onError();
        }
    }
}