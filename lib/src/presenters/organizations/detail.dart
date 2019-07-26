import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/users/organization.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/organizations/detail.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/organizations/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class OrganizationDetailPresenter extends FuturePresenterContract<Organization>
{
    int _organizationId;

    Organization _organization;

    OrganizationDetailView _view;

    ViewFutureContract<Organization> _delegate;

    OrganizationApiRepository _apiRepository = OrganizationApiRepository();

    OrganizationDetailPresenter(RouterContract router, {@required int id}): super(router) {
        _organizationId = id;
        _view = OrganizationDetailView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<Organization> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadOrganizationData();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadOrganizationData();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadOrganizationData() async
    {
        try {
            _organization = await _apiRepository.getById(_organizationId);

            _delegate.onLoad(_organization);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(e) {
            print(e);
            _delegate.onError();
        }
    }

    void didTapWorkerItem(Worker worker)
    {
        router.presentWorkerDetail(worker.id);
    }
}