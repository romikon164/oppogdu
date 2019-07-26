import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/users/organization.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/organizations/list.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/organizations/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class OrganizationListPresenter extends FuturePresenterContract<List<Organization>>
{
    OrganizationListView _view;

    ViewFutureContract<List<Organization>> _delegate;

    OrganizationApiRepository _apiRepository = OrganizationApiRepository();

    OrganizationListPresenter(RouterContract router): super(router) {
        _view = OrganizationListView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Organization>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadOrganizations();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadOrganizations();
    }

    void didTapLeadershipItem(Organization organization)
    {
        router.presentOrganizationDetail(organization.id);
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadOrganizations() async
    {
        try {
            List<Organization> _organizations = await _apiRepository.get();

            _delegate.onLoad(_organizations);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(_) {
            _delegate.onError();
        }
    }
}