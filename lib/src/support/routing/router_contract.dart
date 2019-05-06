import 'package:oppo_gdu/src/presenters/contract.dart';
import 'package:oppo_gdu/src/data/models/photo/photo.dart';

abstract class RouterContract
{
    void pop();
    void push(PresenterContract presenter);
    void presentSinglePhoto(String imageUrl, {String title});
    void presentPhotoGallery(List<Photo> photos, {int initialIndex = 0});
    void presentHomeScreen();
    void presentLogin();
    void presentRegister();
    void presentNewsList();
    void presentNewsDetail(int newsId);
    void presentNewsComments(int newsId);
    void presentPhotoAlbums();
    void presentPhotoAlbumDetail(int albumId);
    void presentVideos();
    void presentSportComplex();
    void presentLeaderships();
    void presentWorkerDetail(int id);
    void presentFollowUs();
    void presentWriteToUs();
    void presentContacts();
}