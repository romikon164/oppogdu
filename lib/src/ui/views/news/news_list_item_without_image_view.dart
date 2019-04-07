import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:intl/intl.dart';

class NewsListItemWithoutImageView extends StatefulWidget
{
    final News news;

    final NewsListItemOnTapCallback onTap;

    NewsListItemWithoutImageView({Key key, this.news, this.onTap}): super(key: key);

    @override
    _NewsListItemWithoutImageViewState createState() => _NewsListItemWithoutImageViewState();
}

class _NewsListItemWithoutImageViewState extends State<NewsListItemWithoutImageView>
{
    DateFormat dateFormatter = DateFormat("dd.MM.yyyy");

    @override
    Widget build(BuildContext context)
    {
        return Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: GestureDetector(
                onTap: () {
                    widget.onTap(widget.news);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.0
                            )
                        ]
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    widget.news.name,
                                    style: Theme.of(context).textTheme.subhead,
                                ),
                                Container(
                                    height: 16,
                                ),
                                Text(
                                    dateFormatter.format(widget.news.createdAt),
                                    style: Theme.of(context).textTheme.overline
                                )
                            ]
                        )
                    )
                )
            )
        );
    }
}