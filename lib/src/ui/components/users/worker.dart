import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkerListItemWidget extends StatefulWidget
{
    final String name;

    final String position;

    final String phone;

    final String email;

    final String photo;

    final GestureTapCallback onTap;

    WorkerListItemWidget({
        Key key,
        this.name,
        this.position,
        this.phone,
        this.email,
        this.photo,
        this.onTap
    }): super(key: key);

    @override
    _WorkerListItemState createState() => _WorkerListItemState();
}

class _WorkerListItemState extends State<WorkerListItemWidget>
{
    String _noPhotoImage = 'http://api.oppo-gdu.ru/img/no-photo.png';

    @override
    Widget build(BuildContext context)
    {
        List<Widget> widgets = List<Widget>();

        widgets.add(
            _buildNameWidget(context)
        );

        if(widget.position != null && widget.position.isNotEmpty) {
            widgets.add(
                _buildPositionWidget(context)
            );
        }

        if(widget.phone != null && widget.phone.isNotEmpty) {
            widgets.add(
                _buildContactWidget(context, widget.phone, Icons.phone)
            );
        }

        if(widget.email != null && widget.email.isNotEmpty) {
            widgets.add(
                _buildContactWidget(context, widget.email, Icons.alternate_email)
            );
        }

        return Card(
            child: InkWell(
                onTap: widget.onTap,
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Flexible(
                            child: CachedNetworkImage(
                                imageUrl: widget.photo ?? _noPhotoImage,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover
                            ),
                            flex: 0,
                            fit: FlexFit.tight,
                        ),
                        Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widgets,
                            ),
                            flex: 1,
                            fit: FlexFit.loose,
                        )
                    ],
                )
            ),
        );
    }

    Widget _buildNameWidget(BuildContext context)
    {
        return Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Text(
                widget.name,
                style: Theme.of(context).textTheme.headline,
            ),
        );
    }

    Widget _buildPositionWidget(BuildContext context)
    {
        return Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text(
                widget.position,
                style: Theme.of(context).textTheme.overline
            ),
        );
    }

    Widget _buildContactWidget(BuildContext context, String contact, IconData icon)
    {
        return Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Icon(
                        icon,
                        size: 16,
                        color: Colors.black54,
                    ),
                    Container(width: 8),
                    Text(
                        contact,
                        style: Theme.of(context).textTheme.overline
                    )
                ],
            ),
        );
    }
}