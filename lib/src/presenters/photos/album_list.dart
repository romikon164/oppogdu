import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/photo/album.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/photos/album_list.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/photos/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

class PhotoAlbumListPresenter extends FuturePresenterContract<List<PhotoAlbum>>
{
    PhotoAlbumListView _view;

    ViewFutureContract<List<PhotoAlbum>> _delegate;

    PhotoApiRepository _apiRepository = PhotoApiRepository();

    PhotoAlbumListPresenter(RouterContract router): super(router) {
        _view = PhotoAlbumListView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<PhotoAlbum>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadPhotoAlbums();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadPhotoAlbums();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadPhotoAlbums() async
    {
        try {
            List<PhotoAlbum> _photoAlbums = await _apiRepository.get();

            _delegate.onLoad(_photoAlbums);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(e) {
            _delegate.onError();
        }
    }

    void didPhotoAlbumTap(PhotoAlbum photoAlbum)
    {
        router.presentPhotoAlbumDetail(photoAlbum.id);
    }
}