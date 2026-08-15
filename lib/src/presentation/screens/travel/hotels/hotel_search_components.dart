import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../core/models/travel_models.dart';
import '../shared/travel_theme.dart';
import '../shared/travel_widgets.dart';

String hotelFlowText(BuildContext context, String fa, String en) {
  final language = Localizations.localeOf(context).languageCode.toLowerCase();
  if (language == 'fa') return fa;
  final localized = _hotelLiteralTranslations[language]?[en];
  return localized ?? en;
}

const Map<String, Map<String, String>> _hotelLiteralTranslations = {
  'ar': {
    'Close': 'إغلاق',
    'Passenger information': 'معلومات المسافر',
    'Checking availability': 'التحقق من التوفر',
    'Room': 'غرفة',
    'Hotel filters': 'فلاتر الفنادق',
    'Apply filters': 'تطبيق الفلاتر',
    'Clear all': 'مسح الكل',
    'Price range': 'نطاق السعر',
    'Hotel stars': 'نجوم الفندق',
    'Special offers': 'عروض خاصة',
    'Hotel features': 'مرافق الفندق',
    'Property type': 'نوع مكان الإقامة',
    'Guest rating': 'تقييم الضيوف',
    'Show less': 'عرض أقل',
    'Show more': 'عرض المزيد',
    'nights': 'ليالٍ',
    'Popular cities': 'مدن شائعة',
    'All ratings': 'كل التقييمات',
    'All filters': 'كل الفلاتر',
    'Discounted': 'عليه خصم',
    'Overview': 'نظرة عامة',
    'Features': 'المرافق',
    'Rooms': 'الغرف',
    'Rules': 'القواعد',
    'Reviews': 'التقييمات',
    'Edit dates': 'تغيير التواريخ',
    'Details': 'التفاصيل',
    'Room details': 'تفاصيل الغرفة',
    'Room information': 'معلومات الغرفة',
    'Search results': 'نتائج البحث',
    'Select stay dates': 'اختيار تواريخ الإقامة',
    'Confirm dates': 'تأكيد التواريخ',
    'Persian': 'شمسي',
    'Gregorian': 'ميلادي',
  },
  'ru': {
    'Close': 'Закрыть',
    'Passenger information': 'Информация о пассажире',
    'Checking availability': 'Проверка доступности',
    'Room': 'Номер',
    'Hotel filters': 'Фильтры отелей',
    'Apply filters': 'Применить фильтры',
    'Clear all': 'Очистить',
    'Price range': 'Диапазон цен',
    'Hotel stars': 'Звезды отеля',
    'Special offers': 'Спецпредложения',
    'Hotel features': 'Удобства отеля',
    'Property type': 'Тип объекта',
    'Guest rating': 'Оценка гостей',
    'Show less': 'Скрыть',
    'Show more': 'Показать еще',
    'nights': 'ночей',
    'Popular cities': 'Популярные города',
    'All ratings': 'Все оценки',
    'All filters': 'Все фильтры',
    'Discounted': 'Со скидкой',
    'Overview': 'Обзор',
    'Features': 'Удобства',
    'Rooms': 'Номера',
    'Rules': 'Правила',
    'Reviews': 'Отзывы',
    'Edit dates': 'Изменить даты',
    'Details': 'Детали',
    'Room details': 'Детали номера',
    'Room information': 'Информация о номере',
    'Search results': 'Результаты поиска',
    'Select stay dates': 'Выберите даты проживания',
    'Confirm dates': 'Подтвердить даты',
    'Persian': 'Персидский',
    'Gregorian': 'Григорианский',
  },
  'tr': {
    'Close': 'Kapat',
    'Passenger information': 'Yolcu bilgileri',
    'Checking availability': 'Uygunluk kontrol ediliyor',
    'Room': 'Oda',
    'Hotel filters': 'Otel filtreleri',
    'Apply filters': 'Filtreleri uygula',
    'Clear all': 'Temizle',
    'Price range': 'Fiyat aralığı',
    'Hotel stars': 'Otel yıldızı',
    'Special offers': 'Özel teklifler',
    'Hotel features': 'Otel özellikleri',
    'Property type': 'Tesis tipi',
    'Guest rating': 'Misafir puanı',
    'Show less': 'Daha az göster',
    'Show more': 'Daha fazla göster',
    'nights': 'gece',
    'Popular cities': 'Popüler şehirler',
    'All ratings': 'Tüm puanlar',
    'All filters': 'Tüm filtreler',
    'Discounted': 'İndirimli',
    'Overview': 'Genel bakış',
    'Features': 'Özellikler',
    'Rooms': 'Odalar',
    'Rules': 'Kurallar',
    'Reviews': 'Yorumlar',
    'Edit dates': 'Tarihleri düzenle',
    'Details': 'Detaylar',
    'Room details': 'Oda detayları',
    'Room information': 'Oda bilgileri',
    'Search results': 'Arama sonuçları',
    'Select stay dates': 'Konaklama tarihlerini seç',
    'Confirm dates': 'Tarihleri onayla',
    'Persian': 'Farsça',
    'Gregorian': 'Miladi',
  },
  'zh': {
    'Close': '关闭',
    'Passenger information': '乘客信息',
    'Checking availability': '正在检查可用性',
    'Room': '房间',
    'Hotel filters': '酒店筛选',
    'Apply filters': '应用筛选',
    'Clear all': '清除全部',
    'Price range': '价格范围',
    'Hotel stars': '酒店星级',
    'Special offers': '特别优惠',
    'Hotel features': '酒店设施',
    'Property type': '住宿类型',
    'Guest rating': '住客评分',
    'Show less': '收起',
    'Show more': '查看更多',
    'nights': '晚',
    'Popular cities': '热门城市',
    'All ratings': '全部评分',
    'All filters': '全部筛选',
    'Discounted': '有折扣',
    'Overview': '概览',
    'Features': '设施',
    'Rooms': '房间',
    'Rules': '规则',
    'Reviews': '评论',
    'Edit dates': '修改日期',
    'Details': '详情',
    'Room details': '房间详情',
    'Room information': '房间信息',
    'Search results': '搜索结果',
    'Select stay dates': '选择入住日期',
    'Confirm dates': '确认日期',
    'Persian': '波斯历',
    'Gregorian': '公历',
  },
};

Future<TravelSuggestion?> showHotelDestinationPicker(
  BuildContext context, {
  String initialQuery = '',
}) {
  return Navigator.of(context).push<TravelSuggestion>(
    MaterialPageRoute(
      builder: (_) => HotelDestinationScreen(initialQuery: initialQuery),
    ),
  );
}

class HotelDestinationScreen extends StatefulWidget {
  final String initialQuery;

  const HotelDestinationScreen({super.key, this.initialQuery = ''});

  @override
  State<HotelDestinationScreen> createState() => _HotelDestinationScreenState();
}

class _HotelDestinationScreenState extends State<HotelDestinationScreen> {
  static const pageSize = 12;
  final queryController = TextEditingController();
  final scrollController = ScrollController();
  Timer? debounce;
  List<TravelSuggestion> suggestions = const [];
  bool loading = true;
  int visibleCount = pageSize;

  @override
  void initState() {
    super.initState();
    queryController.text = widget.initialQuery;
    scrollController.addListener(_onScroll);
    unawaited(_load());
  }

  @override
  void dispose() {
    debounce?.cancel();
    queryController.dispose();
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        scrollController.position.extentAfter > 280 ||
        visibleCount >= suggestions.length) {
      return;
    }
    setState(() {
      visibleCount = (visibleCount + pageSize).clamp(0, suggestions.length);
    });
  }

  Future<void> _load() async {
    if (mounted) setState(() => loading = true);
    final values = await ensureTravelController().getSuggestions(
      TravelProductType.hotel,
      query: queryController.text.trim(),
      limit: 100,
    );
    if (!mounted) return;
    setState(() {
      suggestions = values;
      visibleCount = pageSize.clamp(0, values.length);
      loading = false;
    });
  }

  void _search(String _) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), _load);
  }

  @override
  Widget build(BuildContext context) {
    final visible = suggestions.take(visibleCount).toList();
    return TravelPage(
      title: hotelFlowText(
        context,
        'شهر یا هتل مقصد',
        'Destination city or hotel',
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
            child: TextField(
              controller: queryController,
              autofocus: true,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: hotelFlowText(
                  context,
                  'نام شهر یا هتل را جستجو کنید',
                  'Search by city or hotel name',
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: TravelTheme.purple,
                ),
                suffixIcon: queryController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          queryController.clear();
                          _load();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                queryController.text.trim().isEmpty
                    ? hotelFlowText(
                        context,
                        'همه شهرهای دارای هتل',
                        'All cities with hotels',
                      )
                    : hotelFlowText(context, 'نتایج جستجو', 'Search results'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : visible.isEmpty
                ? TravelEmptyState(
                    message: hotelFlowText(
                      context,
                      'شهر یا هتلی با این نام پیدا نشد.',
                      'No matching city or hotel was found.',
                    ),
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
                    itemCount:
                        visible.length +
                        (visible.length < suggestions.length ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == visible.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final suggestion = visible[index];
                      final hotelCount = int.tryParse(
                        suggestion.metadata['property_count']?.toString() ?? '',
                      );
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                        leading: CircleAvatar(
                          backgroundColor: TravelTheme.purple.withValues(
                            alpha: .1,
                          ),
                          child: Icon(
                            suggestion.kind == 'hotel'
                                ? Icons.hotel_rounded
                                : Icons.location_city_rounded,
                            color: TravelTheme.purple,
                          ),
                        ),
                        title: TravelBidiText(
                          suggestion.title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        subtitle: hotelCount == null
                            ? (suggestion.subtitle.isEmpty
                                  ? null
                                  : TravelBidiText(suggestion.subtitle))
                            : Text(
                                hotelFlowText(
                                  context,
                                  '$hotelCount هتل',
                                  '$hotelCount hotels',
                                ),
                              ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).pop(suggestion),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Future<DateTimeRange?> showHotelDateRangePicker(
  BuildContext context, {
  required DateTime initialStart,
  required DateTime initialEnd,
}) {
  return Navigator.of(context).push<DateTimeRange>(
    MaterialPageRoute(
      builder: (_) => HotelDateRangeScreen(
        initialStart: initialStart,
        initialEnd: initialEnd,
      ),
    ),
  );
}

class HotelDateRangeScreen extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;

  const HotelDateRangeScreen({
    super.key,
    required this.initialStart,
    required this.initialEnd,
  });

  @override
  State<HotelDateRangeScreen> createState() => _HotelDateRangeScreenState();
}

class _HotelDateRangeScreenState extends State<HotelDateRangeScreen> {
  late List<DateTime?> values;
  bool persianCalendar = true;

  @override
  void initState() {
    super.initState();
    values = [widget.initialStart, widget.initialEnd];
  }

  String _dateLabel(DateTime value) {
    if (!persianCalendar) {
      return '${value.year}/${value.month.toString().padLeft(2, '0')}/'
          '${value.day.toString().padLeft(2, '0')}';
    }
    final jalali = Jalali.fromDateTime(value);
    return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/'
        '${jalali.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final start = values.whereType<DateTime>().firstOrNull;
    final end = values.whereType<DateTime>().length > 1
        ? values.whereType<DateTime>().elementAt(1)
        : null;
    return TravelPage(
      title: hotelFlowText(context, 'انتخاب تاریخ اقامت', 'Select stay dates'),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: FilledButton(
            onPressed: start != null && end != null && end.isAfter(start)
                ? () => Navigator.of(
                    context,
                  ).pop(DateTimeRange(start: start, end: end))
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: TravelTheme.purple,
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(
              hotelFlowText(context, 'تأیید تاریخ‌ها', 'Confirm dates'),
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
            child: TravelCard(
              child: Column(
                children: [
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: true,
                        label: Text(
                          hotelFlowText(context, 'تقویم شمسی', 'Persian'),
                        ),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(
                          hotelFlowText(context, 'تقویم میلادی', 'Gregorian'),
                        ),
                      ),
                    ],
                    selected: {persianCalendar},
                    onSelectionChanged: (selection) =>
                        setState(() => persianCalendar = selection.first),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SelectedDateSummary(
                          label: hotelFlowText(
                            context,
                            'تاریخ ورود',
                            'Check-in',
                          ),
                          value: start == null ? '—' : _dateLabel(start),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded),
                      Expanded(
                        child: _SelectedDateSummary(
                          label: hotelFlowText(
                            context,
                            'تاریخ خروج',
                            'Check-out',
                          ),
                          value: end == null ? '—' : _dateLabel(end),
                        ),
                      ),
                    ],
                  ),
                  if (start != null && end != null) ...[
                    SizedBox(height: 10.h),
                    Text(
                      hotelFlowText(
                        context,
                        '${end.difference(start).inDays} شب',
                        '${end.difference(start).inDays} nights',
                      ),
                      style: const TextStyle(
                        color: TravelTheme.purple,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                calendarViewMode: CalendarDatePicker2Mode.scroll,
                firstDate: DateUtils.dateOnly(DateTime.now()),
                lastDate: DateTime.now().add(const Duration(days: 730)),
                selectedDayHighlightColor: TravelTheme.purple,
                selectedRangeHighlightColor: TravelTheme.purple.withValues(
                  alpha: .16,
                ),
                rangeBidirectional: true,
                centerAlignModePicker: true,
                controlsTextStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
              value: values,
              onValueChanged: (next) => setState(() => values = next),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedDateSummary extends StatelessWidget {
  final String label;
  final String value;

  const _SelectedDateSummary({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: TravelTheme.muted, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
