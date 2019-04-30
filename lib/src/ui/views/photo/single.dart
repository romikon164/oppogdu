import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SinglePhotoView extends StatefulWidget
{
    final String imageUrl;

    final String title;

    SinglePhotoView({Key key, this.imageUrl, this.title}): super(key: key) {
        assert(imageUrl != null);
    }

    _SinglePhotoViewState createState() => _SinglePhotoViewState();
}

class _SinglePhotoViewState extends State<SinglePhotoView>
{
    _SinglePhotoViewState(): super();

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                title: Text(widget.title ?? "Просмотр изображения"),
                centerTitle: false,
                backgroundColor: Colors.transparent,
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child: PhotoView(
                    heroTag: widget.title,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained * 4.0,
                    initialScale: PhotoViewComputedScale.contained,
                    loadingChild: CircularProgressIndicator(backgroundColor: Colors.white),
                    imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                    basePosition: Alignment.center,
                ),
            ),
        );
    }
}