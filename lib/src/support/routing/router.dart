import 'package:flutter/material.dart';
import 'router_contract.dart';
import 'package:oppo_gdu/src/presenters/contract.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';
import 'package:oppo_gdu/src/presenters/auth/register/register_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/news_detail_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/comments_presenter.dart';
import 'package:oppo_gdu/src/presenters/photos/album_list.dart';
import 'package:oppo_gdu/src/presenters/photos/album_detail.dart';
import 'package:oppo_gdu/src/presenters/videos/list.dart';
import 'package:oppo_gdu/src/presenters/events/calendar.dart';
import 'package:oppo_gdu/src/presenters/workers/leadership_list.dart';
import 'package:oppo_gdu/src/presenters/workers/detail.dart';
import 'package:oppo_gdu/src/presenters/organizations/list.dart';
import 'package:oppo_gdu/src/presenters/organizations/detail.dart';
import 'package:oppo_gdu/src/presenters/documents/list.dart';
import 'package:oppo_gdu/src/presenters/order.dart';
import 'package:oppo_gdu/src/presenters/contacts.dart';
import 'package:oppo_gdu/src/presenters/follow_us.dart';
import 'package:oppo_gdu/src/ui/views/photo/single.dart';
import 'package:oppo_gdu/src/ui/views/photos/gallery.dart';
import 'package:oppo_gdu/src/data/models/photo/photo.dart';
import 'package:oppo_gdu/src/data/models/documents/document.dart';
import 'package:oppo_gdu/src/ui/views/pdf.dart';

typedef void RouterPushCallback<T>(T result);

class Router implements RouterContract
{
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    void replace(PresenterContract presenter)
    {
        navigatorKey.currentState.pushReplacement(
            MaterialPageRoute(
                builder: (context) => presenter.view as StatefulWidget
            )
        );
    }

    void push(PresenterContract presenter, [RouterPushCallback callback])
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => presenter.view as StatefulWidget
            )
        ).then((value) {
            if(callback != null) {
                callback(value);
            }
        });
    }

    void pop()
    {
        navigatorKey.currentState.pop();
    }

    void presentHomeScreen()
    {
        presentNewsList();
    }

    void presentNewsList()
    {
        replace(NewsListPresenter(this));
    }

    void presentNewsDetail(int newsId, [RouterPushCallback callback])
    {
        push(NewsDetailPresenter(this, id: newsId), callback);
    }

    void presentNewsComments(int newsId, [RouterPushCallback callback])
    {
        push(NewsCommentsPresenter(this, id: newsId), callback);
    }

    void presentPhotoAlbums()
    {
        replace(PhotoAlbumListPresenter(this));
    }

    void presentPhotoAlbumDetail(int albumId)
    {
        push(PhotoAlbumDetailPresenter(this, id: albumId));
    }

    void presentVideos()
    {
        replace(VideoListPresenter(this));
    }

    void presentSportComplex()
    {
        replace(EventsCalendarPresenter(this));
    }

    void presentLeaderships()
    {
        replace(LeadershipListPresenter(this));
    }

    void presentWorkerDetail(int id)
    {
        push(WorkerDetailPresenter(this, id: id));
    }

    void presentOrganizations()
    {
        replace(OrganizationListPresenter(this));
    }

    void presentOrganizationDetail(int id)
    {
        push(OrganizationDetailPresenter(this, id: id));
    }

    void presentPrints()
    {
        replace(DocumentListPresenter(this, DocumentTypes.PRINTS));
    }

    void presentActs()
    {
        replace(DocumentListPresenter(this, DocumentTypes.ACTS));
    }

    void presentDocumentDetail(int id)
    {
        // TODO
    }

    void presentLogin()
    {
        replace(LoginPresenter(this));
    }

    void presentRegister()
    {
        replace(RegisterPresenter(this));
    }

    void presentSinglePhoto(String imageUrl, {String title})
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => SinglePhotoView(imageUrl: imageUrl, title: title)
            )
        );
    }

    void presentPhotoGallery(List<Photo> photos, {int initialIndex = 0})
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => PhotoGalleryView(photos: photos, initialIndex: initialIndex)
            )
        );
    }

    void presentWriteToUs()
    {
        replace(OrderPresenter(this));
    }

    void presentFollowUs()
    {
        replace(FollowUsPresenter(this));
    }

    void presentContacts()
    {
        replace(ContactsPresenter(this));
    }

    void presentCollectiveAgreement()
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => PdfViewWidget(title: "Коллектвный договор", url: "http://oppo-gdu.ru/kollektivnyij-dogovor.pdf")
            )
        );
    }
}