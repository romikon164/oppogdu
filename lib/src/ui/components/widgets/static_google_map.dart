import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oppo_gdu/src/consts.dart';

class StaticGoogleMap extends StatefulWidget
{
    final double latitude;

    final double longitude;

    final int zoom;

    final int width;

    final int height;

    final String apiKey;

    StaticGoogleMap({
        Key key,
        this.latitude,
        this.longitude,
        this.zoom,
        this.width,
        this.height,
        this.apiKey = GOOGLE_API_KEY
    }): super(key: key);

    @override
    _StaticGoogleMapState createState() => _StaticGoogleMapState();
}

class _StaticGoogleMapState extends State<StaticGoogleMap>
{
    @override
    Widget build(BuildContext context)
    {
        print(_buildMapUrl(context));
        return CachedNetworkImage(
            imageUrl: _buildMapUrl(context),
            fit: BoxFit.cover,
        );
    }

    String _buildMapUrl(BuildContext context)
    {
        MediaQueryData mediaQuery = MediaQuery.of(context);

        int width = widget.width ?? mediaQuery.size.width.toInt();
        int height = widget.height ?? mediaQuery.size.height.toInt();

        Uri uri = Uri(
            scheme: 'https',
            host: 'static-maps.yandex.ru',
            path: '/1.x/',
            port: 443,
            queryParameters: {
                'l': 'map',
                'll': "${widget.longitude},${widget.latitude}",
                'pt': "${widget.longitude},${widget.latitude},pm2blm",
                'size': "$width,$height",
                'z': "${widget.zoom}",
                // 'key': widget.apiKey
            }
        );

        return uri.toString();
    }
}