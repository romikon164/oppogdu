import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/videos/list.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import 'package:oppo_gdu/src/data/models/videos/video.dart';
import 'package:oppo_gdu/src/data/models/videos/category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:oppo_gdu/src/consts.dart';

class VideoListView extends StatefulWidget implements ViewContract
{
    final VideoListPresenter presenter;

    VideoListView({Key key, this.presenter}): super(key: key);

    @override
    _VideoListViewState createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> implements ViewFutureContract<List<Video>>
{
    List<Video> _videos;

    List<Video> _filteredVideos;

    List<VideoCategory> _categories;

    bool _isError = false;

    VideoCategory _currentVideoCategory;

    VideoCategory _nullVideoCategory = VideoCategory(id: 0, name: "Все видеозаписи");

    _VideoListViewState(): super();

    @override
    void initState()
    {
        super.initState();

        _currentVideoCategory = _nullVideoCategory;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(VideoListView oldWidget)
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

    void onLoad(List<Video> data)
    {
        setState(() {
            _videos = data.map((video) {
                if(video.category == null) {
                    video.category = _nullVideoCategory;
                }

                return video;
            }).toList();

            _updateCategoryList();
            _filterVideoList();
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    void _updateCategoryList()
    {
        _categories = List<VideoCategory>();

        _videos.forEach((video) {
            if(video.category != _nullVideoCategory) {
                if(!_categories.contains(video.category)) {
                    _categories.add(video.category);
                }
            }
        });
    }

    void _filterVideoList()
    {
        if(_currentVideoCategory == _nullVideoCategory) {
            _filteredVideos = _videos;
        } else {
            _filteredVideos = _videos.where(
                (video) => video.category == _currentVideoCategory
            ).toList();
        }
    }

    @override
    Widget build(BuildContext context) {
        return _videos == null
          ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
          : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.videosItem,
            bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.videosItem,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.videosItem,
            bottomNavigationDelegate: widget.presenter,
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                      _buildAppBar(context)
                  ];
              },
              body: Builder(
                  builder: (BuildContext context) {
                      return RefreshIndicator(
                          child: _buildVideosWidget(context),
                          onRefresh: _onRefresh,
                      );
                  },
              )
            ),
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        Widget title;

        if(_categories.isEmpty) {
            title = Text("Видеозаписи");
        } else {
            title = PopupMenuButton<VideoCategory>(
                child: Row(
                    children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 140,
                            child: Text(
                                _currentVideoCategory.name,
                                style: Theme.of(context)
                                  .appBarTheme
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        IconButton(
                            icon: Icon(Icons.arrow_drop_down, size: 24, color: Colors.white),
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {},
                        )
                    ],
                ),
                initialValue: _currentVideoCategory,
                itemBuilder: _buildVideoCategories,
                onSelected: (category) {
                    setState(() {
                        _currentVideoCategory = category;
                        _filterVideoList();
                    });
                },
            );
        }

        return SliverAppBar(
            title: title,
            floating: true,
            snap: true,
        );
    }

    List<PopupMenuItem<VideoCategory>> _buildVideoCategories(BuildContext context)
    {
        if(_categories.isEmpty) {
            return [];
        }

        List<PopupMenuItem<VideoCategory>> categoryWidgets = [
            PopupMenuItem<VideoCategory>(
                value: _nullVideoCategory,
                child: Text(_nullVideoCategory.name),
            )
        ];

        _categories.forEach((category) {
            categoryWidgets.add(
                PopupMenuItem<VideoCategory>(
                    value: category,
                    child: Text(category.name),
                )
            );
        });

        return categoryWidgets;
    }

    Widget _buildVideosWidget(BuildContext context)
    {
        if(_filteredVideos.isEmpty) {
            return Center(
                child: Text("Нет видеозаписей"),
            );
        } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: _filteredVideos.length,
                itemBuilder: _buildVideoItemWidget,
            );
        }
    }

    Widget _buildVideoItemWidget(BuildContext context, int index)
    {
        if(_filteredVideos == null || index >= _filteredVideos.length) {
            return null;
        }

        Video video = _filteredVideos[index];

        List<Widget> widgets = [
            Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Text(
                    video.name,
                    style: Theme.of(context).textTheme.headline,
                ),
            )
        ];

        if(video.createdAt != null) {
            widgets.add(
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Text(
                    "Опубликованно " + DateTimeFormatter.format(video.createdAt),
                    style: Theme.of(context).textTheme.overline
                  ),
              )
            );
        }

        if(video.description != null && video.description.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                        video.description,
                        style: Theme.of(context).textTheme.overline
                    ),
                )
            );
        }

        if(video.category != null && video.category != _nullVideoCategory) {
            widgets.add(
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Text(
                    video.category.name,
                    style: Theme.of(context).textTheme.overline
                  ),
              )
            );
        }

        return Card(
            child: InkWell(
                onTap: () {
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: YOUTUBE_API_KEY,
                        videoId: video.code,
                        autoPlay: true,
                        fullScreen: false,
                    );
                },
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Flexible(
                            child: Container(
                                width: 120,
                                height: 120,
                                child: Stack(
                                    children: [
                                        CachedNetworkImage(
                                          imageUrl: video.thumb,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover
                                        ),
                                        Positioned(
                                            child: Icon(Icons.play_circle_filled, size: 48, color: Colors.white70),
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                        )
                                    ],
                                ),
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

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}