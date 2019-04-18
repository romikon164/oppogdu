import 'package:oppo_gdu/src/presenters/contract.dart';
import 'package:oppo_gdu/src/ui/components/navigation/drawer/delegate.dart';
import 'package:oppo_gdu/src/ui/components/navigation/bottom/delegate.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

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
        // TODO
    }

    void didDrawerNavigationNewsPressed() {
        router.pop();
        router.presentNewsList();
    }

    void didDrawerNavigationPhotoGalleryPressed() {
        router.pop();
        // TODO;
    }

    void didDrawerNavigationVideoGalleryPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationSportComplexPressed() {
        router.pop();
        // TODO
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
        // TODO
    }

    void didDrawerNavigationCollectiveAgreementPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationContactsPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationFollowsUsPressed() {
        router.pop();
        // TODO
    }

    void didDrawerNavigationWriteToUsPressed() {
        router.pop();
        // TODO
    }

    void didBottomNavigationNewsPressed() {
        router.presentNewsList();
    }

    void didBottomNavigationSportComplex() {
        // TODO
    }
    void didBottomNavigationWriteToUs() {
        // TODO
    }
}