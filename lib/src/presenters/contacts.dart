import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/contacts.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/contacts.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/contacts/api_repository.dart';

class ContactsPresenter extends FuturePresenterContract<Contacts>
{
    ContactsView _view;

    ViewFutureContract<Contacts> _delegate;

    ContactsApiRepository _apiRepository = ContactsApiRepository();

    ContactsPresenter(RouterContract router): super(router) {
        _view = ContactsView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<Contacts> delegate)
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
            _delegate.onLoad(contacts);
        } catch(_) {
            _delegate.onError();
        }
    }
}