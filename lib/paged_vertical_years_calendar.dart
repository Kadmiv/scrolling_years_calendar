import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/rendering.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';
import 'package:scrolling_years_calendar/utils/device_type_helper.dart';
import 'package:scrolling_years_calendar/utils/extentions.dart';
import 'package:scrolling_years_calendar/widgets/day/day_view.dart';
import 'package:scrolling_years_calendar/widgets/year/year_view.dart';

/// enum indicating the pagination enpoint direction
enum PaginationDirection {
  up,
  down,
}

/// a minimalistic paginated calendar widget providing infinite customisation
/// options and usefull paginated callbacks. all paremeters are optional.
///
/// ```
/// PagedVerticalMonthsCalendar(
///       startDate: DateTime(2021, 1, 1),
///       endDate: DateTime(2021, 12, 31),
///       onDayPressed: (day) {
///            print('Date selected: $day');
///          },
///          onMonthLoaded: (year, month) {
///            print('month loaded: $month-$year');
///          },
///          onPaginationCompleted: () {
///            print('end reached');
///          },
///        ),
/// ```
class PagedVerticalYearsCalendar extends StatefulWidget {
  PagedVerticalYearsCalendar({
    required this.initialDate,
    required this.minDate,
    required this.maxDate,
    required this.dayBuilder,
    this.monthBuilder,
    this.addAutomaticKeepAlives = false,
    this.onDayPressed,
    this.onMonthLoaded,
    this.onPaginationCompleted,
    this.invisibleMonthsThreshold = 1,
    this.physics,
    this.scrollController,
    this.listPadding = EdgeInsets.zero,
    int? monthsPerRow,
    DateFormat? monthFormatter,
    DateFormat? weekDayFormatter,
    this.onMonthTap,
    this.monthTitleStyle,
    this.showDayTitle = false,
    this.startWeekWithSunday = false,
    this.yearTitleBuilder,
    DecorationBuilder? dayTitleDecoration,
    DecorationBuilder? monthDecoration,
    DecorationBuilder? yearDecoration,
    List<DateTime>? uniqueDates,
    super.key,
  })  : yearDecoration = yearDecoration ?? defaultYearDecoration,
        dayTitleDecoration = dayTitleDecoration ?? defaultDayDecoration,
        uniqueDates = uniqueDates ?? [],
        monthDecoration = monthDecoration ?? defaultMonthDecoration,
        monthFormatter = monthFormatter ?? defaultMonthFormatter,
        weekDayFormatter = weekDayFormatter ?? defaultWeekDayFormatter,
        monthsPerRow = monthsPerRow ?? 3;

  /// the initial date displayed by the calendar.
  /// if inititial date is nulll, the start date will be used
  final DateTime initialDate;

  /// the [DateTime] to start the calendar from, if no [startDate] is provided
  /// `DateTime.now()` will be used
  final DateTime? minDate;

  /// optional [DateTime] to end the calendar pagination, of no [endDate] is
  /// provided the calendar can paginate indefinitely
  final DateTime? maxDate;

  final Function(DateTime date)? onMonthTap;
  final TextStyle? monthTitleStyle;
  final Function(BuildContext context, DateTime year)? yearTitleBuilder;

  /// a Builder used for month header generation. a default [MonthBuilder] is
  /// used when no custom [MonthBuilder] is provided.
  /// * [context]
  /// * [int] year: 2021
  /// * [int] month: 1-12
  final MonthBuilder? monthBuilder;

  /// a Builder used for day generation. a default [DayBuilder] is
  /// used when no custom [DayBuilder] is provided.
  /// * [context]
  /// * [DateTime] date
  final DayWidgetBuilder dayBuilder;

  /// if the calendar should stay cached when the widget is no longer loaded.
  /// this can be used for maintaining the last state. defaults to `false`
  final bool addAutomaticKeepAlives;

  /// callback that provides the [DateTime] of the day that's been interacted
  /// with
  final ValueChanged<DateTime>? onDayPressed;

  /// callback when a new paginated month is loaded.
  final OnMonthLoaded? onMonthLoaded;

  /// called when the calendar pagination is completed. if no [minDate] or [maxDate] is
  /// provided this method is never called for that direction
  final ValueChanged<PaginationDirection>? onPaginationCompleted;

  /// how many months should be loaded outside of the view. defaults to `1`
  final int invisibleMonthsThreshold;

  /// list padding, defaults to `EdgeInsets.zero`
  final EdgeInsetsGeometry listPadding;

  /// scroll physics, defaults to matching platform conventions
  final ScrollPhysics? physics;

  /// scroll controller for making programmable scroll interactions
  final ScrollController? scrollController;

  final int monthsPerRow;
  final DecorationBuilder yearDecoration;
  final DecorationBuilder monthDecoration;
  final DateFormat monthFormatter;
  final DateFormat weekDayFormatter;
  final DecorationBuilder dayTitleDecoration;
  final bool showDayTitle;
  final bool startWeekWithSunday;
  final List<DateTime> uniqueDates;

  @override
  _PagedVerticalYearsCalendarState createState() =>
      _PagedVerticalYearsCalendarState();
}

class _PagedVerticalYearsCalendarState
    extends State<PagedVerticalYearsCalendar> {
  late PagingController<int, DateTime> _pagingReplyUpController;
  late PagingController<int, DateTime> _pagingReplyDownController;

  final Key downListKey = UniqueKey();
  late bool hideUp;

  late final List<String> _monthTitles;
  late List<Widget> _daysWidgets;
  late final Map<String, DateTime> _uniqueDates;

  @override
  void initState() {
    super.initState();

    _monthTitles = List.generate(
      12,
      (index) => widget.monthFormatter.format(
        DateTime(2000, index + 1),
      ),
    );

    _uniqueDates = Map.fromIterable(
      widget.uniqueDates,
      key: (item) => item.toString(),
      value: (item) => item,
    );

    if (widget.minDate != null &&
        widget.initialDate.isBefore(widget.minDate!)) {
      throw ArgumentError("initialDate cannot be before minDate");
    }

    if (widget.maxDate != null && widget.initialDate.isAfter(widget.maxDate!)) {
      throw ArgumentError("initialDate cannot be after maxDate");
    }

    // assert(maxDate != null && !initialDate.isBefore(maxDate),
    //     'initialDate must be on or after maxDate'),
    // assert(minDate != null && !initialDate.isAfter(minDate),
    //     'initialDate must be on or before minDate'),
    // assert(minDate != null && maxDate != null && !maxDate.isAfter(minDate),
    //     'minDate must be on or after maxDate'),

    // hideUp = (widget.minDate == null || widget.minDate!.isSameYear(widget.initialDate));
    hideUp = true;

    _pagingReplyUpController = PagingController<int, DateTime>(
      firstPageKey: 0,
      invisibleItemsThreshold: widget.invisibleMonthsThreshold,
    );
    _pagingReplyUpController.addPageRequestListener(_fetchUpPage);
    _pagingReplyUpController.addStatusListener(paginationStatusUp);

    _pagingReplyDownController = PagingController<int, DateTime>(
      firstPageKey: 0,
      invisibleItemsThreshold: widget.invisibleMonthsThreshold,
    );
    _pagingReplyDownController.addPageRequestListener(_fetchDownPage);
    _pagingReplyDownController.addStatusListener(paginationStatusDown);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _generateUsedWidgets();
    });
  }

  @override
  void didUpdateWidget(covariant PagedVerticalYearsCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.minDate != oldWidget.minDate) {
      _pagingReplyUpController.refresh();

      hideUp = !(widget.minDate == null ||
          !widget.minDate!.isSameYear(widget.initialDate));
    }
  }

  void paginationStatusUp(PagingStatus state) {
    if (state == PagingStatus.completed) {
      return widget.onPaginationCompleted?.call(PaginationDirection.up);
    }
  }

  void paginationStatusDown(PagingStatus state) {
    if (state == PagingStatus.completed) {
      return widget.onPaginationCompleted?.call(PaginationDirection.down);
    }
  }

  /// fetch a new [DateTime] object based on the [pageKey] which is the Nth month
  /// from the start date
  Future<void> _fetchUpPage(int pageKey) async {
    try {
      final year = DateTime(
        widget.initialDate.year - pageKey - 1,
      );

      // WidgetsBinding.instance.addPostFrameCallback(
      //   (_) => widget.onMonthLoaded?.call(month.year, month.month),
      // );

      final newItems = [year];
      final isLastPage =
          widget.minDate != null && widget.minDate!.isSameDayOrAfter(year);

      if (isLastPage) {
        return _pagingReplyUpController.appendLastPage([year]);
      }

      final nextPageKey = pageKey + 1;
      _pagingReplyUpController.appendPage(newItems, nextPageKey);
    } catch (_) {
      _pagingReplyUpController.error;
    }
  }

  Future<void> _fetchDownPage(int pageKey) async {
    try {
      final year = DateTime(
        widget.initialDate.year + pageKey,
      );

      // WidgetsBinding.instance.addPostFrameCallback(
      //   (_) => widget.onMonthLoaded?.call(month.year, month.month),
      // );

      final newItems = [year];
      final isLastPage =
          widget.maxDate != null && widget.minDate!.isSameDayOrAfter(year);

      if (isLastPage) {
        return _pagingReplyUpController.appendLastPage([year]);
      }

      final nextPageKey = pageKey + 1;
      _pagingReplyUpController.appendPage(newItems, nextPageKey);
    } catch (_) {
      _pagingReplyDownController.error;
    }
  }

  Map<int, Widget> _yearWidgets = {};

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    DeviceTypeHelper.instance.checkDeviceScreen();
    print('width:$width');

    _daysWidgets = List.generate(
      31,
      (day) => DayView(
        day: (day + 1).toString(),
        monthsPerRow: widget.monthsPerRow,
      ),
    );

    return InfiniteListView.builder(
      // key: PageStorageKey(tab),
      // controller: _infiniteController,
      itemBuilder: (BuildContext context, int index) {
        final date = DateTime(widget.initialDate.year + index);

        // if (_yearWidgets.containsKey(index)) {
        //   return _yearWidgets[index]!;
        // }

        final yearWidget = YearView(
          date: date,
          monthsPerRow: widget.monthsPerRow,
          monthTitleStyle: widget.monthTitleStyle,
          monthTitles: _monthTitles,
          onMonthTap: widget.onMonthTap,
          dayBuilder: widget.dayBuilder,
          daysWidgets: _daysWidgets,
          showDayTitle: widget.showDayTitle,
          startWeekWithSunday: widget.startWeekWithSunday,
          monthDecoration: widget.monthDecoration,
          dayTitleDecoration: widget.dayTitleDecoration,
          weekDayFormatter: widget.weekDayFormatter,
          yearDecoration: widget.yearDecoration,
          uniqueDates: _uniqueDates,
        );

        // _yearWidgets[index] = yearWidget;

        return yearWidget;
      },
      // anchor: 0.5,
    );

    // return Scrollable(
    //   controller: widget.scrollController,
    //   physics: widget.physics,
    //   viewportBuilder: (BuildContext context, ViewportOffset position) {
    //     return Viewport(
    //       offset: position,
    //       center: downListKey,
    //       slivers: [
    //         if (!hideUp)
    //           PagedSliverList(
    //             pagingController: _pagingReplyUpController,
    //             builderDelegate: PagedChildBuilderDelegate<DateTime>(
    //               itemBuilder:
    //                   (BuildContext context, DateTime date, int index) {
    //                 /// Gets a widget with the view of the given year.
    //                 return buildYear(date);
    //               },
    //             ),
    //           ),
    //         PagedSliverList(
    //           key: downListKey,
    //           pagingController: _pagingReplyDownController,
    //           builderDelegate: PagedChildBuilderDelegate<DateTime>(
    //             itemBuilder: (BuildContext context, DateTime date, int index) {
    //               /// Gets a widget with the view of the given year.
    //               return buildYear(date);
    //             },
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );

    // final years = <Widget>[];
    // for (var index = 0; index < 100; index++) {
    //   final date = DateTime(widget.initialDate.year + index);
    //
    //   years.add(
    //     YearView(
    //       date: date,
    //       monthsPerRow: widget.monthsPerRow,
    //       onMonthTap: widget.onMonthTap,
    //       monthTitleStyle: widget.monthTitleStyle,
    //       monthTitles: _monthTitles,
    //       dayBuilder: widget.dayBuilder,
    //       daysWidgets: _daysWidgets,
    //       showDayTitle: widget.showDayTitle,
    //       startWeekWithSunday: widget.startWeekWithSunday,
    //       monthDecoration: widget.monthDecoration,
    //       dayTitleDecoration: widget.dayTitleDecoration,
    //       weekDayFormatter: widget.weekDayFormatter,
    //       yearDecoration: widget.yearDecoration,
    //       uniqueDates: _uniqueDates,
    //     ),
    //   );
    // }
    //
    // return ListView(
    //   children: years,
    // );
  }

  @override
  void dispose() {
    _pagingReplyUpController.dispose();
    _pagingReplyDownController.dispose();
    super.dispose();
  }
}

typedef MonthBuilder = Widget Function(
    BuildContext context, int month, int year);

typedef OnMonthLoaded = void Function(int year, int month);
