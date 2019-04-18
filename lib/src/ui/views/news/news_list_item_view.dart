import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

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

        // if(widget.news.intotext != null && widget.news.introtext.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                        // widget.news.intotext,
                        "Lorem werwf fwefr cwewewfw, werwfewfwc! werwef cwecwe.cw ecwecweccwerwe wERwere.",
                        style: Theme.of(context).textTheme.body1
                    ),
                )
            );
        // }

        if(widget.news.thumb != null) {
            widgets.add(
                Image.network(
                    widget.news.thumb,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width / 3 * 2,
                )
            );
        }

        List<Widget> actions = [];

        if(AuthService.instance.isAuthenticated()) {
            actions.add(
                FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border, color: Color(0xFF9B9B9B)),
                    label: Text("0", style: Theme.of(context).textTheme.button),
                )
            );
        }

        actions.add(
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.forum, color: Color(0xFF9B9B9B)),
                label: Text("0", style: Theme.of(context).textTheme.button)
            )
        );

        actions.add(
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.share, color: Color(0xFF9B9B9B)),
                label: Text("", style: Theme.of(context).textTheme.button)
            )
        );

        actions.add(
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.remove_red_eye, color: Color(0xFF9B9B9B)),
                label: Text("0", style: Theme.of(context).textTheme.button)
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
                    widget.onTap(widget.news);
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widgets,
                ),
            ),
        );
    }
}