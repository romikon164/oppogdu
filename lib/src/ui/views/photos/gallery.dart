import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oppo_gdu/src/data/models/photo/photo.dart';
import 'package:share/share.dart';
import 'package:oppo_gdu/src/data/repositories/photos/api_repository.dart';

class PhotoGalleryView extends StatefulWidget
{
    final List<Photo> photos;

    final int initialIndex;

    PhotoGalleryView({Key key, this.photos, this.initialIndex}): super(key: key) {
        assert(photos != null && photos.isNotEmpty);
        assert(initialIndex < photos.length);
    }

    _PhotoGalleryViewViewState createState() => _PhotoGalleryViewViewState();
}

class _PhotoGalleryViewViewState extends State<PhotoGalleryView>
{
    int _currentIndex;

    PhotoApiRepository _apiRepository = PhotoApiRepository();

    _PhotoGalleryViewViewState(): super();

    @override
    void initState()
    {
        _currentIndex = widget.initialIndex;
        super.initState();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child: Stack(
                    overflow: Overflow.visible,
                    children: [
                        PhotoViewGallery.builder(
                            pageController: PageController(initialPage: widget.initialIndex),
                            onPageChanged: _onPhotoChange,
                            itemCount: widget.photos.length,
                            builder: _buildPhotoItem,
                            loadingChild: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                            ),
                        ),
                        _buildCustomAppbar(context),
                        _buildActionWidgets(context)
                    ],
                ),
            ),
        );
    }

    Widget _buildCustomAppbar(BuildContext context)
    {
        return Positioned(
            top: 24,
            left: 16,
            right: 16,
            height: kToolbarHeight,
            child: Container(
                height: kToolbarHeight,
                width: MediaQuery.of(context).size.width,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                        InkWell(
                            child: Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.white
                            ),
                            onTap: () {
                                Navigator.of(context).pop();
                            },
                        ),
                        Container(width: 12, height: kToolbarHeight),
                        Text(
                            "${_currentIndex + 1} / ${widget.photos.length}",
                            style: Theme.of(context).appBarTheme.textTheme.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis
                        )
                    ],
                ),
            ),
        );
    }

    PhotoViewGalleryPageOptions _buildPhotoItem(BuildContext context, int index)
    {
        return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(widget.photos[index].image),
            heroTag: '',
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 4.0,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
        );
    }

    Widget _buildActionWidgets(BuildContext context)
    {
        List<Widget> actions = [];

        if(widget.photos[_currentIndex].isFavorited) {
            actions.add(
                FlatButton.icon(
                    onPressed: () {
                        _unFavorited();
                    },
                    icon: Icon(Icons.favorite, color: Colors.red),
                    label: Text(
                        "${widget.photos[_currentIndex].favoritesCount}",
                        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)
                    ),
                )
            );
        } else {
            actions.add(
                FlatButton.icon(
                    onPressed: () {
                        _favorited();
                    },
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    label: Text(
                        "${widget.photos[_currentIndex].favoritesCount}",
                        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)
                    ),
                )
            );
        }

        actions.add(
            FlatButton.icon(
                onPressed: () {
                    Share.share(
                        "${widget.photos[_currentIndex].image}"
                    );
                },
                icon: Icon(Icons.share, color: Colors.white),
                label: Text("", style: Theme.of(context).textTheme.button)
            )
        );

        return Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions,
            ),
        );
    }

    void _onPhotoChange(int index)
    {
        setState(() {
            _currentIndex = index;
        });
    }

    Future<void> _favorited() async
    {
        Photo photo = widget.photos[_currentIndex];

        if(photo.isFavorited) {
            return ;
        }

        setState(() {
            photo.isFavorited = true;
            photo.favoritesCount++;
        });

        await _apiRepository.addToFavorite(photo);

        setState(() {

        });
    }

    Future<void> _unFavorited() async
    {
        Photo photo = widget.photos[_currentIndex];

        if(!photo.isFavorited) {
            return ;
        }

        setState(() {
            photo.isFavorited = false;
            photo.favoritesCount--;
        });

        await _apiRepository.removeFromFavorite(photo);

        setState(() {

        });
    }
}