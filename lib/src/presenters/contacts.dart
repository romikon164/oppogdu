import 'package:flutter/material.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/contacts.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/contacts.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/contacts/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

class ContactsPresenter extends FuturePresenterContract<Contacts>
{
    ContactsView _view;

    ViewFutureContract<Contacts> _delegate;

    // PhotoApiRepository _apiRepository = PhotoApiRepository();

    ContactsPresenter(RouterContract router, {@required int id}): super(router) {
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
            // Contacts _photoAlbum = await _apiRepository.getById(_albumId);

            // _delegate.onLoad(_photoAlbum);
        } on RepositoryNotFoundException {
            router.presentHomeScreen();
        } catch(e) {
            _delegate.onError();
        }
    }
}