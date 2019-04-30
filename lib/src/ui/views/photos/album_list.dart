import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/photos/album_list.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import '../../components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/data/models/photo/album.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoAlbumListView extends StatefulWidget implements ViewContract
{
    final PhotoAlbumListPresenter presenter;

    PhotoAlbumListView({Key key, this.presenter}): super(key: key);

    @override
    _PhotoAlbumListViewState createState() => _PhotoAlbumListViewState();
}

class _PhotoAlbumListViewState extends State<PhotoAlbumListView> implements ViewFutureContract<List<PhotoAlbum>>
{
    List<PhotoAlbum> _photoAlbums;

    bool _isError = false;

    BottomNavigationController _bottomNavigationBarController;

    _PhotoAlbumListViewState(): super();

    @override
    void initState()
    {
        super.initState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.presenter;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(PhotoAlbumListView oldWidget)
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

    void onLoad(List<PhotoAlbum> data)
    {
        setState(() {
            _photoAlbums = data;
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
        return _photoAlbums == null
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
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
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
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.photosItem
            ),
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                        SliverAppBar(
                            title: Text("Фотогалерея"),
                            floating: true,
                            snap: true,
                        )
                    ];
                },
                body: Builder(
                    builder: (BuildContext context) {
                        return RefreshIndicator(
                            child: NotificationListener<UserScrollNotification>(
                                child: _buildPhotoAlbumsWidget(context),
                                onNotification: _onUserScroll,
                            ),
                            onRefresh: _onRefresh,
                        );
                    },
                )
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.photosItem
            ),
        );
    }

    bool _onUserScroll(UserScrollNotification notification)
    {
        if(notification.direction == ScrollDirection.forward) {
            _bottomNavigationBarController.show();
        }

        if(notification.direction == ScrollDirection.reverse) {
            _bottomNavigationBarController.hide();
        }

        return true;
    }

    Widget _buildPhotoAlbumsWidget(BuildContext context)
    {
        if(_photoAlbums.isEmpty) {
            return Center(
                child: Text("Нет фотографий"),
            );
        } else {
            return GridView.builder(
                padding: EdgeInsets.only(top: 8),
                itemCount: _photoAlbums.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 0
                ),
                itemBuilder: _buildPhotoAlbumItemWidget,
            );
        }
    }

    Widget _buildPhotoAlbumItemWidget(BuildContext context, int index)
    {
        if(_photoAlbums == null || index >= _photoAlbums.length) {
            return null;
        }

        PhotoAlbum photoAlbum = _photoAlbums[index];

        List<Widget> infoWidgets = [
            Text(
                photoAlbum.name,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.white, fontSize: 14),
            ),
        ];

        if(photoAlbum.description != null && photoAlbum.description.isNotEmpty) {
            infoWidgets.add(
                Container(height: 8)
            );

            infoWidgets.add(
                Text(
                    photoAlbum.description,
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(color: Colors.white, fontSize: 12),
                )
            );
        }

        List<Widget> widgets = List<Widget>();

        if(photoAlbum.thumb != null && photoAlbum.thumb.isNotEmpty) {
            widgets.add(
                CachedNetworkImage(
                    imageUrl: photoAlbum.thumb,
                    fit: BoxFit.cover,
                )
            );
        }

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

        return Card(
            child: GestureDetector(
                onTap: () {
                    widget.presenter?.didPhotoAlbumTap(photoAlbum);
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