import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/photos/album_detail.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import '../../components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/data/models/photo/album.dart';
import 'package:oppo_gdu/src/data/models/photo/photo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoAlbumDetailView extends StatefulWidget implements ViewContract
{
    final PhotoAlbumDetailPresenter presenter;

    PhotoAlbumDetailView({Key key, this.presenter}): super(key: key);

    @override
    _PhotoAlbumDetailViewState createState() => _PhotoAlbumDetailViewState();
}

class _PhotoAlbumDetailViewState extends State<PhotoAlbumDetailView> implements ViewFutureContract<PhotoAlbum>
{
    PhotoAlbum _photoAlbum;

    bool _isError = false;

    BottomNavigationController _bottomNavigationBarController;

    double _flexibleSpaceHeight = 200.0;

    bool _appBarTitleVisibled = false;

    double _appBarTitleMarginTop = 0;

    double _bodyTitleMarginTop = 16;

    _PhotoAlbumDetailViewState(): super();

    @override
    void initState()
    {
        super.initState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.presenter;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(PhotoAlbumDetailView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.onInitState(this);
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();

        widget.presenter?.onInitState(this);
    }

    void onLoad(PhotoAlbum data)
    {
        setState(() {
            _photoAlbum = data;
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    @override
    Widget build(BuildContext context) {
        return _photoAlbum == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text("Загрузка"),
            ),
            body: Center(
                child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: BottomNavigationWidget(),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.photosItem
            ),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text("Ошибка"),
            ),
            body: Center(
                child: Text(
                    "Возникла ошибка при загрузке данных"
                ),
            ),
            bottomNavigationBar: BottomNavigationWidget(),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.photosItem
            ),
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        List<Widget> infoWidgets = List<Widget>();

        infoWidgets.add(
            Text(
                _photoAlbum.name,
                style: Theme.of(context).textTheme.headline,
            )
        );

        if(_photoAlbum.description != null && _photoAlbum.description.isNotEmpty) {
            infoWidgets.add(
                Container(height: 8)
            );

            infoWidgets.add(
                Text(
                    _photoAlbum.description,
                    style: Theme.of(context).textTheme.overline,
                )
            );
        }

        return Scaffold(
            body: RefreshIndicator(
                child: NotificationListener<ScrollNotification>(
                    child:  CustomScrollView(
                        slivers: [
                            _buildAppBar(context),
                            SliverToBoxAdapter(
                                child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(_bodyTitleMarginTop),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: infoWidgets,
                                        ),
                                    ),
                                ),
                            ),
                            _buildPhotoAlbumWidget(context)
                        ]
                    ),
                    onNotification: _onUserScroll,
                ),
                onRefresh: _onRefresh,
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        if(_photoAlbum.image == null) {
            _flexibleSpaceHeight = kToolbarHeight;

            return SliverAppBar(
                centerTitle: false,
                floating: false,
                pinned: true,
                title: _buildAppBarTitle(context),
            );
        } else {
            return SliverAppBar(
                centerTitle: false,
                expandedHeight: _flexibleSpaceHeight,
                floating: false,
                pinned: true,
                title: _buildAppBarTitle(context),
                flexibleSpace: FlexibleSpaceBar(
                    background: Image(
                        image: CachedNetworkImageProvider(_photoAlbum.image),
                        fit: BoxFit.cover,
                    ),
                ),
            );
        }
    }

    Widget _buildAppBarTitle(BuildContext context)
    {
        if(_appBarTitleVisibled) {
            return ClipRect(
                child: Padding(
                    padding: EdgeInsets.only(top: _appBarTitleMarginTop),
                    child: Text(_photoAlbum.name, textScaleFactor: 0.6),
                ),
            );
        }

        return null;
    }

    bool _onUserScroll(ScrollNotification notification)
    {
        double scrollTop = notification.metrics.pixels;

        if(scrollTop > _flexibleSpaceHeight - kToolbarHeight + _bodyTitleMarginTop) {
            if(!_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = true;
                    _appBarTitleMarginTop = kToolbarHeight;
                });
            } else {
                setState(() {
                    _appBarTitleMarginTop = _flexibleSpaceHeight - scrollTop + _bodyTitleMarginTop;

                    if(_appBarTitleMarginTop < 0) {
                        _appBarTitleMarginTop = 0;
                    }
                });
            }
        } else {
            if (_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = false;
                });
            }
        }

        if(notification is UserScrollNotification) {
            if(notification.direction == ScrollDirection.forward) {
                _bottomNavigationBarController.show();
            }

            if(notification.direction == ScrollDirection.reverse) {
                _bottomNavigationBarController.hide();
            }
        }

        return true;
    }

    Widget _buildPhotoAlbumWidget(BuildContext context)
    {
        if(_photoAlbum.photos == null || _photoAlbum.photos.isEmpty) {
            return SliverToBoxAdapter(
                child: Center(
                    child: Text("В альбоме нет фотографий"),
                )
            );
        } else {
            return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 8
                ),
                delegate: SliverChildBuilderDelegate(
                    _buildPhotoItem,
                    childCount: _photoAlbum.photos.length
                ),
            );
        }
    }

    Widget _buildPhotoItem(BuildContext context, int index) {
        if(_photoAlbum == null || _photoAlbum.photos == null || index >= _photoAlbum.photos.length) {
            return null;
        }

        Photo photo = _photoAlbum.photos[index];

        if(photo.image == null || photo.thumb == null) {
            return null;
        }

        List<Widget> infoWidgets = [];

        if(photo.name != null && photo.name.isNotEmpty) {
            infoWidgets.add(
                Text(
                    photo.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(color: Colors.white, fontSize: 14),
                ),
            );
        }

        if(photo.description != null && photo.description.isNotEmpty) {
            infoWidgets.add(
                Container(height: 8)
            );

            infoWidgets.add(
                Text(
                    photo.description,
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(color: Colors.white, fontSize: 12),
                )
            );
        }

        List<Widget> widgets = List<Widget>();

        widgets.add(
            Hero(
                tag: "photo-album-${_photoAlbum.id}-photo-${photo.id}",
                child: CachedNetworkImage(
                    imageUrl: photo.thumb,
                    fit: BoxFit.cover,
                )
            )
        );

        if(infoWidgets.isNotEmpty) {
            widgets.add(
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        color: Colors.black45,
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: infoWidgets,
                        ),
                    ),
                )
            );
        }

        return Card(
            child: GestureDetector(
                onTap: () {
                    widget.presenter?.router?.presentPhotoGallery(
                        _photoAlbum.photos,
                        initialIndex: index
                    );
                },
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Stack(
                        children: widgets,
                        fit: StackFit.expand,
                    ),
                ),
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}