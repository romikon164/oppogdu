import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/documents/document.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/documents/list.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/documents/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class DocumentListPresenter extends FuturePresenterContract<List<Document>>
{
    DocumentListView _view;

    ViewFutureContract<List<Document>> _delegate;

    final String documentsType;

    DocumentApiRepository _apiRepository = DocumentApiRepository();

    DocumentListPresenter(RouterContract router, this.documentsType): super(router) {
        _view = DocumentListView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Document>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadDocuments();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadDocuments();
    }

    void didTapDocumentItem(Document document)
    {
        router.presentDocumentDetail(document.id);
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadDocuments() async
    {
        try {
            List<Document> _documents;

            if(documentsType == DocumentTypes.PRINTS) {
                _documents = await _apiRepository.getPrints();
            } else if(documentsType == DocumentTypes.ACTS) {
                _documents = await _apiRepository.getActs();
            } else {
                _documents = List<Document>();
            }

            _delegate.onLoad(_documents);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(_) {
            _delegate.onError();
        }
    }
}