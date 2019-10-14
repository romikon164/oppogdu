import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/data/models/page.dart';
import 'package:oppo_gdu/src/data/repositories/pages/api_repository.dart';
import '../view_contract.dart';
import '../../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;
import 'package:oppo_gdu/src/ui/views/photo/single.dart';

class SportComplexAboutView extends StatefulWidget implements ViewContract
{
    SportComplexAboutView({Key key}): super(key: key);

    @override
    _SportComplexAboutState createState() => _SportComplexAboutState();
}

class _SportComplexAboutState extends State<SportComplexAboutView>
{
    static const PAGE_CODE = 'sportcomplex-about';

    PageApiRepository _apiRepository = PageApiRepository();
    Page _data;
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
                Page page = await _apiRepository.getByCode(PAGE_CODE);
                _onLoad(page);
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

    void _onLoad(Page page)
    {
        setState(() {
            _data = page;
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
        if(_bodyWidget == null) {
            _bodyWidget = MarkDownComponent(
                data: _data.content,
                onTapImage: _onTapBodyImage,
                onTapLink: _onTapBodyLink,
            );
        }

        return SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: _bodyWidget,
                ),
            ),
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