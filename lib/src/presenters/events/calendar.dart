import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/events/event.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/events/calendar.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/events/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class EventsCalendarPresenter extends FuturePresenterContract<List<Event>>
{
    EventsCalendarView _view;

    ViewFutureContract<List<Event>> _delegate;

    EventApiRepository _apiRepository = EventApiRepository();

    EventsCalendarPresenter(RouterContract router): super(router) {
        _view = EventsCalendarView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Event>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadEvents();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadEvents();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadEvents() async
    {
        try {
            List<Event> _events = await _apiRepository.get();

            _delegate.onLoad(_events);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(_) {
            _delegate.onError();
        }
    }
}