import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

class NewsListItemView extends StatefulWidget
{
    final News news;

    final NewsListItemOnTapCallback onTap;

    NewsListItemView({Key key, this.news, this.onTap}): super(key: key);

    @override
    _NewsListItemViewState createState() => _NewsListItemViewState();
}

class _NewsListItemViewState extends State<NewsListItemView>
{
    @override
    Widget build(BuildContext context)
    {
        List<Widget> widgets = [
            Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Text(
                    widget.news.name,
                    style: Theme.of(context).textTheme.headline,
                ),
            )
        ];

        if(widget.news.createdAt != null) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                        "Опубликованно " + DateTimeFormatter.format(widget.news.createdAt),
                        style: Theme.of(context).textTheme.overline
                    ),
                )
            );
        }

        if(widget.news.introText != null && widget.news.introText.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                        widget.news.introText,
                        style: Theme.of(context).textTheme.body1
                    ),
                )
            );
        }

        if(widget.news.image != null) {
            widgets.add(
                Image(
                    image: CachedNetworkImageProvider(widget.news.image),
                    fit: BoxFit.cover,
                )
            );
        }

        List<Widget> actions = [];

        if(AuthService.instance.isAuthenticated()) {
            if(widget.news.isFavorited) {
                actions.add(
                    FlatButton.icon(
                        onPressed: () {
                            // TODO
                        },
                        icon: Icon(Icons.favorite_border, color: Colors.red),
                        label: Text(
                            "${widget.news.favoritesCount}",
                            style: Theme.of(context).textTheme.button
                        ),
                    )
                );
            } else {
                actions.add(
                    FlatButton.icon(
                        onPressed: () {
                            // TODO
                        },
                        icon: Icon(Icons.favorite_border, color: Color(0xFF9B9B9B)),
                        label: Text(
                            "${widget.news.favoritesCount}",
                            style: Theme.of(context).textTheme.button
                        ),
                    )
                );
            }
        }

        actions.add(
            FlatButton.icon(
                onPressed: () {
                    // TODO
                },
                icon: Icon(Icons.forum, color: Color(0xFF9B9B9B)),
                label: Text("${widget.news.commentsCount}", style: Theme.of(context).textTheme.button)
            )
        );

        actions.add(
            FlatButton.icon(
                onPressed: () {
                    Share.share(
                      "${widget.news.name} http://api.oppo-gdu.ru/news/${widget.news.id}"
                    );
                },
                icon: Icon(Icons.share, color: Color(0xFF9B9B9B)),
                label: Text("", style: Theme.of(context).textTheme.button)
            )
        );

        actions.add(
            Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Icon(Icons.remove_red_eye, color: Color(0xFF9B9B9B)),
                        Container(width: 8),
                        Text("${widget.news.viewsCount}", style: Theme.of(context).textTheme.button)
                    ],
                ),
            )
        );

        widgets.add(
            Padding(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: actions,
                ),
            )
        );

        return Card(
            child: InkWell(
                onTap: () {
                    if(widget.onTap != null) {
                        widget.onTap(widget.news);
                    }
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widgets,
                ),
            ),
        );
    }
}