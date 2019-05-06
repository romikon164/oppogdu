import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/contacts.dart';
import 'package:oppo_gdu/src/data/models/social_network.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/follow_us_view.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/contacts/api_repository.dart';

class FollowUsPresenter extends FuturePresenterContract<List<SocialNetwork>>
{
    FollowUsView _view;

    ViewFutureContract<List<SocialNetwork>> _delegate;

    ContactsApiRepository _apiRepository = ContactsApiRepository();

    FollowUsPresenter(RouterContract router): super(router) {
        _view = FollowUsView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<SocialNetwork>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadContacts();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadContacts();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadContacts() async
    {
        try {
            Contacts contacts = await _apiRepository.getCompanyContacts();
            _delegate.onLoad(contacts.socialNetworks);
        } catch(e) {
            print(e);
            _delegate.onError();
        }
    }
}