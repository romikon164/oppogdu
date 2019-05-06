import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/news/comment.dart';
import '../../components/users/circle_avatar.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class CommentItemWidget extends StatefulWidget
{
    final Comment comment;

    CommentItemWidget({Key key, @required this.comment}): super(key: key);

    @override
    _CommentItemWidgetState createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget>
{
    @override
    Widget build(BuildContext context)
    {
        return Card(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: UserCircleAvatar(
                                radius: 24,
                                username: widget.comment?.user?.fullname,
                                image:  widget.comment?.user?.photo,
                            )
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    widget.comment?.user?.fullname,
                                    style: Theme.of(context).textTheme.headline
                                ),
                                Text( widget.comment?.text),
                                Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(
                                        DateTimeFormatter.format( widget.comment?.createdAt, pattern: "dd.MM.yyyy HH:mm:ss"),
                                        style: Theme.of(context).textTheme.overline
                                    ),
                                )
                            ]
                        )
                    ],
                ),
            ),
        );
    }
}