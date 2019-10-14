/// Методы обратного вызова для главного меню

abstract class DrawerNavigationDelegate
{
    /// нажатие на имя пользователя или аватар
    void didDrawerNavigationProfilePressed();
    /// нажатие на "вход"
    void didDrawerNavigationLoginPressed();
    /// нажатие на "регистрация"
    void didDrawerNavigationRegisterPressed();
    /// нажатие на "выход"
    void didDrawerNavigationLogoutPressed();

    /// нажатие на "об организации"
    void didDrawerNavigationAboutPressed();
    /// нажатие на "новости"
    void didDrawerNavigationNewsPressed();
    /// нажатие на "фотогалерея"
    void didDrawerNavigationPhotoGalleryPressed();
    /// нажатие на "видеогалерея"
    void didDrawerNavigationVideoGalleryPressed();
    /// нажатие на "спортивный комплекс"
    void didDrawerNavigationSportComplexPressed();
    /// нажатие на "структура"
    void didDrawerNavigationStructurePressed();
    /// нажтие на "печатные издания"
    void didDrawerNavigationPrintsPressed();
    /// нажатие на "нормативные акты"
    void didDrawerNavigationRegulationsPressed();
    /// нажатие на "руководство"
    void didDrawerNavigationLeadershipPressed();
    /// нажатие на "коллективный договор"
    void didDrawerNavigationCollectiveAgreementPressed();
    /// нажатие на "контакты"
    void didDrawerNavigationContactsPressed();
    /// нажатие на "следите за нами"
    void didDrawerNavigationFollowsUsPressed();
    /// нажатие на "напишите нам"
    void didDrawerNavigationWriteToUsPressed();
}