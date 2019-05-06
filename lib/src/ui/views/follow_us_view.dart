import 'package:flutter/material.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/social_network.dart';
import '../components/navigation/drawer/widget.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/follow_us.dart';
import 'package:flutter/rendering.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlUtils;
import '../components/widgets/loading.dart';
import '../components/widgets/empty.dart';
import '../components/widgets/scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../social_network_icons_icons.dart';

class FollowUsView extends StatefulWidget implements ViewContract
{
    final FollowUsPresenter presenter;

    FollowUsView({Key key, this.presenter}): super(key: key);

    @override
    _FollowUsViewState createState() => _FollowUsViewState();
}

class _FollowUsViewState extends State<FollowUsView> implements ViewFutureContract<List<SocialNetwork>>
{
    List<SocialNetwork> _socialNetworks;

    bool _isError = false;

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(FollowUsView oldWidget)
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

    void onLoad(List<SocialNetwork> socialNetworks)
    {
        setState(() {
            _socialNetworks = socialNetworks;
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    @override
    Widget build(BuildContext context)
    {
        return _socialNetworks == null
          ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
          : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            includeDrawer: true,
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.contactsItem,
            bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            includeDrawer: true,
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.contactsItem,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text('Следите за нами'),

            ),
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.followUsItem,
            bottomNavigationDelegate: widget.presenter,
            body: SafeArea(
                child: Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(48, 8, 64, 48),
                                child: Text(
                                    "Мы в социальных сетях",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline
                                        .copyWith(
                                            fontSize: 16,
                                            color: Colors.black54
                                        )
                                ),
                            ),
                            _buildSocialNetworks(context)
                        ],
                    )
                )
            ),
        );
    }

    Widget _buildSocialNetworks(BuildContext context)
    {
        List<Widget> _socialNetworksWidgets = List<Widget>();

        for(SocialNetwork socialNetwork in _socialNetworks) {
            _socialNetworksWidgets.add(
                _buildSocialNetworkItem(context, socialNetwork)
            );
        }

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _socialNetworksWidgets,
        );
    }

    Widget _buildSocialNetworkItem(BuildContext context, SocialNetwork socialNetwork)
    {
        if(socialNetwork.url == null) {
            return null;
        }

        double iconSize = 48;

        Widget iconWidget;
        if(socialNetwork.icon != null) {
            iconWidget = CachedNetworkImage(
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                imageUrl: socialNetwork.icon
            );
        } else if(socialNetwork.name == SocialNetwork.FACEBOOK) {
            iconWidget = Icon(SocialNetworkIcons.facebook, size: iconSize, color: Theme.of(context).primaryColor);
        } else if(socialNetwork.name == SocialNetwork.VKONTAKTE) {
            iconWidget = Icon(SocialNetworkIcons.vkontakte, size: iconSize, color: Theme.of(context).primaryColor);
        } else if(socialNetwork.name == SocialNetwork.TWITTER) {
            iconWidget = Icon(SocialNetworkIcons.twitter, size: iconSize, color: Theme.of(context).primaryColor);
        } else if(socialNetwork.name == SocialNetwork.INSTAGRAM) {
            iconWidget = Icon(SocialNetworkIcons.instagram, size: iconSize, color: Theme.of(context).primaryColor);
        } else {
            return null;
        }

        return InkWell(
            child: iconWidget,
            onTap: () {
                UrlUtils.launchUrl(socialNetwork.url);
            },
        );
    }
}