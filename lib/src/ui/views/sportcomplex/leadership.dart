import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import 'package:oppo_gdu/src/data/repositories/workers/api_repository.dart';
import '../view_contract.dart';
import '../../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;
import 'package:oppo_gdu/src/ui/views/photo/single.dart';
import '../../components/users/worker.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

class SportComplexLeadershipView extends StatefulWidget implements ViewContract
{
    final RouterContract router;

    SportComplexLeadershipView({Key key, this.router}): super(key: key);

    @override
    _SportComplexLeadershipState createState() => _SportComplexLeadershipState();
}

class _SportComplexLeadershipState extends State<SportComplexLeadershipView>
{
    WorkerApiRepository _apiRepository = WorkerApiRepository();
    List<Worker> _data;
    bool _isLoad = false;
    bool _isError = false;

    MarkDownComponent _bodyWidget;

    @override void initState()
    {
        super.initState();

        _loadData();
    }

    @override
    Widget build(BuildContext context)
    {
        return _data == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Future<void> _loadData() async
    {
        if (_canLoad()) {
            _initLoader();

            try {
                List<Worker> workers = await _apiRepository.getSportComplexLeaderships();
                _onLoad(workers);
            } catch(e) {
                _onError();
            }
        }
    }

    bool _canLoad()
    {
        return _data == null && !_isLoad && !_isError;
    }

    void _initLoader()
    {
        _isError = false;
        _isLoad = true;
    }

    void _onLoad(List<Worker> workers)
    {
        setState(() {
            _data = workers;
            _isLoad = false;
            _isError = false;
        });
    }

    void _onError()
    {
        setState(() {
            _isLoad = false;
            _isError = true;
            _data = null;
        });
    }

    Widget _buildWidget(BuildContext context)
    {
        return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
                if(index < _data.length) {
                    Worker worker = _data[index];

                    return WorkerListItemWidget(
                        name: worker.name,
                        position: worker.position,
                        phone: worker.phone,
                        email: worker.email,
                        photo: worker.photo,
                        onTap: () {
                            widget.router.presentWorkerDetail(worker.id);
                        },
                    );
                }

                return null;
            }
        );
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return Center(
            child: CircularProgressIndicator(),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Center(
            child: Text('Возникла ошибка при загрузке данных'),
        );
    }

    void _onTapBodyImage(String src, String title, String alt)
    {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => SinglePhotoView(imageUrl: src, title: title)
            )
        );
    }

    void _onTapBodyLink(String href)
    {
        UrlService.launchUrl(href);
    }
}