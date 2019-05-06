import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/photo/album.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/photos/album_detail.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/photos/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class PhotoAlbumDetailPresenter extends FuturePresenterContract<PhotoAlbum>
{
    int _albumId;

    PhotoAlbumDetailView _view;

    ViewFutureContract<PhotoAlbum> _delegate;

    PhotoApiRepository _apiRepository = PhotoApiRepository();

    PhotoAlbumDetailPresenter(RouterContract router, {@required int id}): super(router) {
        _albumId = id;
        _view = PhotoAlbumDetailView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<PhotoAlbum> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadPhotoAlbum();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadPhotoAlbum();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadPhotoAlbum() async
    {
        try {
            PhotoAlbum _photoAlbum = await _apiRepository.getById(_albumId);

            _delegate.onLoad(_photoAlbum);
        } on RepositoryNotFoundException {
            router.presentPhotoAlbums();
        } catch(e) {
            _delegate.onError();
        }
    }
}