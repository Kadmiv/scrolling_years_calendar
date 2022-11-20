import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';
import 'package:scrolling_years_calendar/widgets/month/month_view.dart';
import 'package:scrolling_years_calendar/widgets/year/year_title.dart';

class PagedVerticalYearsCalendar extends StatefulWidget {
  PagedVerticalYearsCalendar({
    required this.initialDate,
    required this.minDate,
    required this.maxDate,
    this.addAutomaticKeepAlives = true,
    this.invisibleMonthsThreshold = 1,
    this.physics,
    this.scrollController,
    this.listPadding = EdgeInsets.zero,
    int? monthsPerRow,
    DateFormat? monthFormatter,
    DateFormat? weekDayFormatter,
    this.onMonthTap,
    this.showDayTitle = false,
    this.startWeekWithSunday = false,
    this.yearTitleBuilder,
    TextStyleBuilder? yearTitleStyleBuilder,
    DecorationWidgetBuilder? yearDecorationBuilder,
    DecorationWidgetBuilder? dayDecorationBuilder,
    TextStyleBuilder? dayStyleBuilder,
    DecorationWidgetBuilder? dayTitleDecorationBuilder,
    TextStyleBuilder? dayTitleStyleBuilder,
    TextStyleBuilder? monthTitleStyleBuilder,
    DecorationWidgetBuilder? monthDecorationBuilder,
    super.key,
  })  : yearTitleStyleBuilder =
            yearTitleStyleBuilder ?? defaultTextStyleBuilder,
        yearDecorationBuilder =
            yearDecorationBuilder ?? defaultDecorationWidgetBuilder,
        dayStyleBuilder = dayStyleBuilder ?? defaultTextStyleBuilder,
        dayDecorationBuilder =
            dayDecorationBuilder ?? defaultDecorationWidgetBuilder,
        dayTitleStyleBuilder = dayTitleStyleBuilder ?? defaultTextStyleBuilder,
        dayTitleDecorationBuilder =
            dayTitleDecorationBuilder ?? defaultDecorationWidgetBuilder,
        monthTitleStyleBuilder =
            monthTitleStyleBuilder ?? defaultTextStyleBuilder,
        monthDecorationBuilder =
            monthDecorationBuilder ?? defaultDecorationWidgetBuilder,
        monthFormatter = monthFormatter ?? defaultMonthFormatter,
        weekDayFormatter = weekDayFormatter ?? defaultWeekDayFormatter,
        monthsPerRow = monthsPerRow ?? 3,
        assert(maxDate != null && !initialDate.isAfter(maxDate),
            'initialDate must be on or after maxDate'),
        assert(minDate != null && !initialDate.isBefore(minDate),
            'initialDate must be on or before minDate');

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
  final Function(BuildContext context, DateTime year)? yearTitleBuilder;

  /// if the calendar should stay cached when the widget is no longer loaded.
  /// this can be used for maintaining the last state. defaults to `false`
  final bool addAutomaticKeepAlives;

  /// how many months should be loaded outside of the view. defaults to `1`
  final int invisibleMonthsThreshold;

  /// list padding, defaults to `EdgeInsets.zero`
  final EdgeInsetsGeometry listPadding;

  /// scroll physics, defaults to matching platform conventions
  final ScrollPhysics? physics;

  /// scroll controller for making programmable scroll interactions
  final ScrollController? scrollController;

  final int monthsPerRow;
  final DateFormat monthFormatter;
  final DateFormat weekDayFormatter;

  final TextStyleBuilder yearTitleStyleBuilder;
  final DecorationWidgetBuilder yearDecorationBuilder;
  final DecorationWidgetBuilder dayDecorationBuilder;
  final TextStyleBuilder dayStyleBuilder;
  final DecorationWidgetBuilder dayTitleDecorationBuilder;
  final TextStyleBuilder dayTitleStyleBuilder;
  final TextStyleBuilder monthTitleStyleBuilder;
  final DecorationWidgetBuilder monthDecorationBuilder;
  final bool showDayTitle;
  final bool startWeekWithSunday;

  @override
  _PagedVerticalYearsCalendarState createState() =>
      _PagedVerticalYearsCalendarState();
}

class _PagedVerticalYearsCalendarState
    extends State<PagedVerticalYearsCalendar> {
  late final List<String> _monthTitles;
  late final List<String> _dayTitles;
  late final SliverChildBuilderDelegate forwardDelegate;
  late final SliverChildBuilderDelegate reverseDelegate;

  final forwardListKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _monthTitles = List.generate(
      12,
      (index) => widget.monthFormatter.format(
        DateTime(2000, index + 1),
      ),
    );

    _dayTitles = List.generate(7, (index) {
      if (!widget.startWeekWithSunday) {
        index = index + 1;
      }

      return widget.weekDayFormatter.format(
        DateTime(2022, 8, index),
      );
    });

    reverseDelegate = SliverChildBuilderDelegate(
      (context, index) {
        final itemIndex = -(index + 1);
        final minDate = widget.minDate;

        /// check is last item of reverse list
        if (minDate != null && _isMinDate(minDate, itemIndex)) {
          return null;
        }

        return _buildItem(context, itemIndex);
      },
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
    );

    forwardDelegate = SliverChildBuilderDelegate(
      (context, index) {
        final itemIndex = index;
        final maxDate = widget.maxDate;

        /// check is last item of reverse list
        if (maxDate != null && _isMaxDate(maxDate, itemIndex)) {
          return null;
        }

        return _buildItem(context, itemIndex);
      },
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset offset) {
        return Viewport(offset: offset, center: forwardListKey, slivers: [
          SliverList(delegate: reverseDelegate),
          SliverList(
            delegate: forwardDelegate,
            key: forwardListKey,
          ),
        ]);
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final yearDate = widget.initialDate;

    final firstMonthIndex = (widget.monthsPerRow * index) + 1;
    final firstMonthDate = DateTime(yearDate.year, firstMonthIndex);
    final isStartOfYear = firstMonthDate.month == 1;

    final months = List<Widget>.generate(widget.monthsPerRow, (mIndex) {
      final monthIndex = mIndex + (widget.monthsPerRow * index) + 1;
      final monthDate = DateTime(yearDate.year, monthIndex);

      return Expanded(
        child: MonthView(
          date: monthDate,
          monthTitles: _monthTitles,
          dayTitles: _dayTitles,
          onMonthTap: widget.onMonthTap,
          showDayTitle: widget.showDayTitle,
          startWeekWithSunday: widget.startWeekWithSunday,
          dayDecorationBuilder: widget.dayDecorationBuilder,
          dayStyleBuilder: widget.dayStyleBuilder,
          dayTitleDecorationBuilder: widget.dayTitleDecorationBuilder,
          dayTitleStyleBuilder: widget.dayTitleStyleBuilder,
          monthTitleStyleBuilder: widget.monthTitleStyleBuilder,
          monthDecorationBuilder: widget.monthDecorationBuilder,
        ),
      );
    });

    if (isStartOfYear) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: YearTitle(firstMonthDate),
            ),
          ),
          Row(children: months),
        ],
      );
    }

    return Row(children: months);
  }

  bool _isMinDate(DateTime minDate, int index) {
    final yearDate = widget.initialDate;
    final firstMonthIndex = (widget.monthsPerRow * index) + 1;
    final firstMonthDate = DateTime(yearDate.year, firstMonthIndex);
    final isStartDate = firstMonthDate.year < widget.minDate!.year;

    return isStartDate;
  }

  bool _isMaxDate(DateTime maxDate, int index) {
    final yearDate = widget.initialDate;
    final firstMonthIndex = (widget.monthsPerRow * index) + 1;
    final lastMonthDate = DateTime(yearDate.year, firstMonthIndex);
    final isEndDate = lastMonthDate.year > widget.maxDate!.year;

    return isEndDate;
  }
}
