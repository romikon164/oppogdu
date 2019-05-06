import 'package:oppo_gdu/src/presenters/contract.dart';
import 'package:oppo_gdu/src/ui/components/navigation/drawer/delegate.dart';
import 'package:oppo_gdu/src/ui/components/navigation/bottom/delegate.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

abstract class Presenter implements PresenterContract, DrawerNavigationDelegate, BottomNavigationDelegate
{
    RouterContract _router;

    Presenter(RouterContract router): super()
    {
        _router = router;
    }

    RouterContract get router => _router;

    void didClosePressed()
    {
        router.pop();
    }

    void didDrawerNavigationProfilePressed() {
        router.pop();
        // router.presentProfile();
    }

    void didDrawerNavigationLoginPressed() {
        router.pop();
        router.presentLogin();
    }

    void didDrawerNavigationRegisterPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationLogoutPressed() {
        router.pop();

        AuthService.instance.logout();
    }

    void didDrawerNavigationNewsPressed() {
        router.pop();
        router.presentNewsList();
    }

    void didDrawerNavigationPhotoGalleryPressed() {
        router.pop();
        router.presentPhotoAlbums();
    }

    void didDrawerNavigationVideoGalleryPressed() {
        router.pop();
        router.presentVideos();
    }

    void didDrawerNavigationSportComplexPressed() {
        router.pop();
        router.presentSportComplex();
    }

    void didDrawerNavigationStructurePressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationPrintsPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationRegulationsPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationLeadershipPressed() {
        router.pop();
        router.presentLeaderships();
    }

    void didDrawerNavigationCollectiveAgreementPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationContactsPressed() {
        router.pop();
        router.presentContacts();
    }

    void didDrawerNavigationFollowsUsPressed() {
        router.pop();
        router.presentFollowUs();
    }

    void didDrawerNavigationWriteToUsPressed() {
        router.pop();
        router.presentWriteToUs();
    }

    void didBottomNavigationNewsPressed() {
        router.presentNewsList();
    }

    void didBottomNavigationSportComplex() {
        router.presentSportComplex();
    }
    void didBottomNavigationWriteToUs() {
        router.presentWriteToUs();
    }
}