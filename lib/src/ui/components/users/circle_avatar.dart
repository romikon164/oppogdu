import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserCircleAvatar extends StatefulWidget
{
    final double radius;

    final String username;

    final String image;

    UserCircleAvatar({
        Key key,
        @required this.radius,
        @required this.username,
        this.image
    }): super(key: key);

    @override
    _UserCircleAvatarState createState() => _UserCircleAvatarState();
}

class _UserCircleAvatarState extends State<UserCircleAvatar>
{
    @override
    Widget build(BuildContext context)
    {
        String usernameFirstLetter = widget.username.substring(0, 1);

        Color backgroundColor;
        CachedNetworkImageProvider backgroundImage;
        Widget avatarChild;

        if(widget.image == null) {
            backgroundColor = _avatarBackgroundColor(usernameFirstLetter);
            avatarChild = Text(usernameFirstLetter);
        } else {
            backgroundColor = Theme.of(context).appBarTheme.color;
            backgroundImage = CachedNetworkImageProvider(widget.image);
        }

        return CircleAvatar(
            radius: 32,
            backgroundColor: backgroundColor,
            backgroundImage: backgroundImage,
            child: avatarChild,
        );
    }

    static Color _avatarBackgroundColor(String l)
    {
        l = l.toLowerCase();
        if(l == "а" || l == "э" || l == "ю") {
            return Colors.amberAccent;
        } else if(l == "б") {
            return Colors.blue;
        } else if(l == "г" || l == "д" || l == "е" || l == "ё") {
            return Colors.deepOrangeAccent;
        } else if(l == "ж" || l == "з") {
            return Colors.blue;
        } else if(l == "и" || l == "й" || l == "к") {
            return Colors.indigoAccent;
        } else if(l == "л" || l == "м" || l == "н") {
            return Colors.lightBlueAccent;
        } else if(l == "о") {
            return Colors.orangeAccent;
        } else if(l == "п") {
            return Colors.pinkAccent;
        } else if(l == "р" || l == "с") {
            return Colors.redAccent;
        } else if(l == "т" || l == "у" || l == "ф" || l == "х") {
            return Colors.tealAccent;
        } else if(l == "ц" || l == "ч" || l == "ь" || l == "ъ") {
            return Colors.cyanAccent;
        } else if(l == "ш" || l == "щ" || l == "я") {
            return Colors.yellowAccent;
        } else {
            return Colors.lightBlueAccent;
        }
    }
}