import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:intl/intl.dart';

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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(widget.news.thumb),
                                            fit: BoxFit.cover,
                                            alignment: FractionalOffset.center
                                        )
                                    ),
                                ),
                                Container(
                                    width: 8,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width - 160,
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
                            ]
                        )
                    )
                )
            )
        );
    }
}