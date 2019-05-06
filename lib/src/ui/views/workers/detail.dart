import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/workers/detail.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import '../../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import '../../components/widgets/scrolled_title.dart';

class WorkerDetailView extends StatefulWidget implements ViewContract
{
    final WorkerDetailPresenter presenter;

    WorkerDetailView({Key key, @required this.presenter}): super(key: key);

    @override
    _WorkerDetailViewState createState() => _WorkerDetailViewState();
}

class _WorkerDetailViewState extends State<WorkerDetailView> implements ViewFutureContract<Worker>
{
    Worker _worker;

    bool _isError = false;

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(WorkerDetailView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.onInitState(this);
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();

        widget.presenter?.onInitState(this);
    }

    void onLoad(Worker data)
    {
        setState(() {
            _worker = data;
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    @override
    Widget build(BuildContext context) {
        return _worker == null
          ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
          : _buildWidget(context);
    }

    Widget _buildWidget(BuildContext context)
    {
        List<Widget> widgets = List<Widget>();

        List<Widget> contacts = List<Widget>();

        List<Widget> actions = List<Widget>();

        if(_worker.phone != null && _worker.phone.isNotEmpty) {
            contacts.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _buildWorkerPhoneBar(context),
                )
            );

            actions.add(
                IconButton(
                    icon: Icon(Icons.phone, size: 24, color: Colors.white),
                    onPressed: () {
                        UrlService.launchUrl("tel:${_worker.phone}");
                    }
                )
            );
        }

        if(_worker.email != null && _worker.email.isNotEmpty) {
            contacts.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _buildWorkerEmailBar(context),
                )
            );

            actions.add(
              IconButton(
                icon: Icon(Icons.alternate_email, size: 24, color: Colors.white),
                onPressed: () {
                    UrlService.launchUrl("mailto:${_worker.email}");
                }
              )
            );
        }

        if(contacts.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: contacts,
                    ),
                )
            );
        }

        if(_worker.description != null && _worker.description.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.all(16),
                    child: MarkDownComponent(
                        data: _worker.description,
                        onTapImage: _onTapBodyImage,
                        onTapLink: _onTapBodyLink,
                    ),
                )
            );
        }

        return ScaffoldWithBottomNavigation(
          includeDrawer: false,
          bottomNavigationDelegate: widget.presenter,
          body: CustomScrollViewWithScrolledTitle(
              title: _worker.name,
              image: _worker.photo,
              actions: actions,
              children: widgets,
              onRefresh: _onRefresh,
          )
        );
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
          includeDrawer: false,
          bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWorkerPhoneBar(BuildContext context)
    {
        return FlatButton.icon(
            padding: EdgeInsets.all(0),
            onPressed: () {
                setState(() {
                    UrlService.launchUrl("tel:${_worker.phone}");
                });
            },
            icon: Icon(Icons.phone, color: Colors.black54),
            label: Text(
                _worker.phone,
                style: Theme.of(context).textTheme.button.copyWith(color: Colors.black54)
            ),
        );
    }

    Widget _buildWorkerEmailBar(BuildContext context)
    {
        return FlatButton.icon(
            padding: EdgeInsets.all(0),
            onPressed: () {
                setState(() {
                    UrlService.launchUrl("mailto:${_worker.email}");
                });
            },
            icon: Icon(Icons.alternate_email, color: Colors.black54),
            label: Text(
              _worker.email,
              style: Theme.of(context).textTheme.button.copyWith(color: Colors.black54)
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        await widget.presenter?.didRefresh();
    }

    void _onTapBodyImage(String src, String title, String alt)
    {
        widget.presenter?.router?.presentSinglePhoto(src, title: title);
    }

    void _onTapBodyLink(String href)
    {
        UrlService.launchUrl(href);
    }
}