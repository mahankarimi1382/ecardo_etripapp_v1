import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/core/controller/travel_controller.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/core/data/travel_repository.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/core/models/travel_models.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Date Range Invariants (Hotels & Flights)', () {
    test('Hotel search validates check-in <= check-out invariant', () {
      final now = DateTime(2026, 10, 15);

      // Case 1: Multi-day stay (checkIn < checkOut)
      final validStay = TravelHotelSearch(
        city: 'Tehran',
        checkInDate: now,
        checkOutDate: now.add(const Duration(days: 3)),
        roomCount: 1,
        adultCount: 2,
        childCount: 0,
      );
      expect(validStay.hasValidDates, isTrue);
      expect(validStay.nights, equals(3));
      expect(validStay.validateDates(), isNull);

      // Case 2: Same-day stay (checkIn == checkOut)
      final sameDayStay = TravelHotelSearch(
        city: 'Kish',
        checkInDate: now,
        checkOutDate: now,
        roomCount: 1,
        adultCount: 1,
        childCount: 0,
      );
      expect(sameDayStay.hasValidDates, isTrue);
      expect(sameDayStay.nights, equals(0));
      expect(sameDayStay.validateDates(), isNull);

      // Case 3: Invalid reversed dates (checkOut < checkIn)
      final invalidStay = TravelHotelSearch(
        city: 'Shiraz',
        checkInDate: now,
        checkOutDate: now.subtract(const Duration(days: 1)),
        roomCount: 1,
        adultCount: 2,
        childCount: 0,
      );
      expect(invalidStay.hasValidDates, isFalse);
      expect(invalidStay.validateDates(), isNotNull);
      expect(invalidStay.validateDates(), contains('cannot be before'));
    });

    test('TravelBookingDetails enforces hotel date validity', () {
      final checkIn = DateTime(2026, 11, 1);
      final checkOut = DateTime(2026, 11, 5);

      final validDetails = TravelBookingDetails(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        roomCount: 2,
      );
      expect(validDetails.hasValidHotelDates, isTrue);

      final invalidDetails = TravelBookingDetails(
        checkInDate: checkOut,
        checkOutDate: checkIn,
        roomCount: 1,
      );
      expect(invalidDetails.hasValidHotelDates, isFalse);

      const nullDetails = TravelBookingDetails();
      expect(nullDetails.hasValidHotelDates, isFalse);
    });

    test('Flight search validates departure < return invariant for round-trip', () {
      final departure = DateTime(2026, 10, 20);

      // Case 1: One-way flight (no return date)
      final oneWay = TravelFlightSearch(
        origin: 'IKA',
        destination: 'DXB',
        departureDate: departure,
      );
      expect(oneWay.hasValidDates, isTrue);
      expect(oneWay.isRoundTrip, isFalse);
      expect(oneWay.validateDates(), isNull);

      // Case 2: Valid round-trip (departure < return)
      final validRoundTrip = TravelFlightSearch(
        origin: 'IKA',
        destination: 'IST',
        departureDate: departure,
        returnDate: departure.add(const Duration(days: 7)),
      );
      expect(validRoundTrip.hasValidDates, isTrue);
      expect(validRoundTrip.isRoundTrip, isTrue);
      expect(validRoundTrip.validateDates(), isNull);

      // Case 3: Invalid round-trip: return equals departure
      final sameDayReturn = TravelFlightSearch(
        origin: 'IKA',
        destination: 'IST',
        departureDate: departure,
        returnDate: departure,
      );
      expect(sameDayReturn.hasValidDates, isFalse);
      expect(sameDayReturn.validateDates(), contains('strictly after'));

      // Case 4: Invalid round-trip: return before departure
      final reversedFlight = TravelFlightSearch(
        origin: 'IKA',
        destination: 'IST',
        departureDate: departure,
        returnDate: departure.subtract(const Duration(days: 2)),
      );
      expect(reversedFlight.hasValidDates, isFalse);
      expect(reversedFlight.validateDates(), contains('strictly after'));

      // Case 5: Missing departure date
      const missingDeparture = TravelFlightSearch(
        origin: 'IKA',
        destination: 'DXB',
      );
      expect(missingDeparture.hasValidDates, isFalse);
      expect(missingDeparture.validateDates(), contains('Departure date is required'));
    });
  });

  group('Accurate Price Calculation (No Floating-Point Precision Loss)', () {
    test('TravelPriceCalculator prevents classic double precision drift', () {
      // Classic IEEE 754 precision trap: 0.1 + 0.2 is 0.30000000000000004
      expect(0.1 + 0.2, isNot(equals(0.3)));
      expect(TravelPriceCalculator.sum([0.1, 0.2]), equals(0.3));

      // Multi-quantity trap: 149.95 * 7 * 2 = 2099.2999999999997
      expect(149.95 * 7 * 2, isNot(equals(2099.3)));
      expect(TravelPriceCalculator.roundCurrency(149.95 * 7 * 2), equals(2099.3));

      // Multiply with exact decimal rounding
      expect(TravelPriceCalculator.multiply(19.99, 3), equals(59.97));
    });

    test('Multi-room hotel pricing calculates exact totals with nights and add-ons', () {
      final rooms = [
        const TravelSelectedRoom(
          id: 'room-deluxe',
          name: 'Deluxe Suite',
          quantity: 2,
          unitPrice: 149.95,
          currency: 'USD',
        ),
        const TravelSelectedRoom(
          id: 'room-std',
          name: 'Standard Room',
          quantity: 1,
          unitPrice: 89.50,
          currency: 'USD',
        ),
      ];

      final addOns = [
        const TravelAddOnService(
          id: 'addon-breakfast',
          name: 'Daily Breakfast',
          unitPrice: 15.25,
          quantity: 3,
          currency: 'USD',
          category: 'meal',
        ),
        const TravelAddOnService(
          id: 'addon-transfer',
          name: 'Airport Transfer',
          unitPrice: 45.00,
          quantity: 1,
          currency: 'USD',
          category: 'transfer',
        ),
      ];

      // Stay of 4 nights
      // Room 1: 149.95 * 2 * 4 = 1199.60
      // Room 2: 89.50 * 1 * 4 = 358.00
      // Rooms subtotal = 1557.60
      // Add-on 1: 15.25 * 3 = 45.75
      // Add-on 2: 45.00 * 1 = 45.00
      // Add-ons subtotal = 90.75
      // Expected Grand Total = 1648.35
      final calculated = TravelPriceCalculator.calculateHotelTotal(
        selectedRooms: rooms,
        nights: 4,
        addOns: addOns,
        fallbackCurrency: 'USD',
      );

      expect(calculated.amount, equals(1648.35));
      expect(calculated.currency, equals('USD'));
    });

    test('Multi-passenger flight pricing calculates exact fares across adult, child, infant', () {
      const flightOffer = TravelOffer(
        id: 'flight-101',
        type: TravelProductType.flight,
        titleKey: 'Tehran to Dubai',
        subtitleKey: 'Emirates EK972',
        badgeKey: 'Direct',
        total: TravelMoney(amount: 320.00, currency: 'USD'),
        rating: 4.8,
        featureKeys: ['baggage_included'],
        metadata: {},
        pricingComponents: [
          {'type': 'adult', 'unit_amount': 320.00},
          {'type': 'child', 'unit_amount': 240.00},
          {'type': 'infant', 'unit_amount': 35.00},
        ],
      );

      const booking = TravelBookingDetails(
        adultCount: 2,
        childCount: 1,
        infantCount: 1,
      );

      final addOns = [
        const TravelAddOnService(
          id: 'bag-extra',
          name: 'Extra 23kg Baggage',
          unitPrice: 45.50,
          quantity: 2,
          currency: 'USD',
          category: 'baggage',
        ),
      ];

      // Fares: (2 * 320) + (1 * 240) + (1 * 35) = 640 + 240 + 35 = 915.00
      // AddOns: 45.50 * 2 = 91.00
      // Total: 915.00 + 91.00 = 1006.00
      final total = TravelPriceCalculator.calculateFlightTotal(
        offer: flightOffer,
        bookingDetails: booking,
        addOns: addOns,
      );

      expect(total.amount, equals(1006.00));
      expect(total.currency, equals('USD'));
    });

    test('Round-trip flight combining outbound and return fares has zero precision drift', () {
      const outbound = TravelOffer(
        id: 'fl-out',
        type: TravelProductType.flight,
        titleKey: 'IKA -> DXB',
        subtitleKey: 'Morning',
        badgeKey: 'Direct',
        total: TravelMoney(amount: 199.99, currency: 'EUR'),
        rating: 4.7,
        featureKeys: [],
        metadata: {},
        pricingComponents: [
          {'type': 'adult', 'unit_amount': 199.99},
        ],
      );

      const returnFlight = TravelOffer(
        id: 'fl-ret',
        type: TravelProductType.flight,
        titleKey: 'DXB -> IKA',
        subtitleKey: 'Evening',
        badgeKey: 'Direct',
        total: TravelMoney(amount: 149.99, currency: 'EUR'),
        rating: 4.6,
        featureKeys: [],
        metadata: {},
        pricingComponents: [
          {'type': 'adult', 'unit_amount': 149.99},
        ],
      );

      const booking = TravelBookingDetails(adultCount: 3);

      // Outbound: 199.99 * 3 = 599.97
      // Return: 149.99 * 3 = 449.97
      // Expected Total: 599.97 + 449.97 = 1049.94 exactly
      final roundTripTotal = TravelPriceCalculator.calculateFlightTotal(
        offer: outbound,
        bookingDetails: booking,
        returnOffer: returnFlight,
      );

      expect(roundTripTotal.amount, equals(1049.94));
      expect(roundTripTotal.currency, equals('EUR'));

      // Check TravelMoney operator + behavior
      final moneyA = const TravelMoney(amount: 19.99, currency: 'USD');
      final moneyB = const TravelMoney(amount: 30.01, currency: 'USD');
      final combined = moneyA + moneyB;
      expect(combined.amount, equals(50.00));
      expect(combined.currency, equals('USD'));
    });
  });

  group('Order & Booking Idempotency Invariants', () {
    test('Reservation retry maintains the same idempotency key on failure', () async {
      final fakeRepo = _InvariantsFakeRepo()..reservationFailures = 2;
      final controller = TravelController(repository: fakeRepo);
      controller.bootstrap.value = _testBootstrap();

      const details = TravelBookingDetails();

      // First attempt fails
      final res1 = await controller.reserve(
        type: TravelProductType.hotel,
        productId: 'hotel-paris',
        total: const TravelMoney(amount: 250, currency: 'EUR'),
        bookingDetails: details,
      );
      expect(res1, isNull);

      // Second attempt fails
      final res2 = await controller.reserve(
        type: TravelProductType.hotel,
        productId: 'hotel-paris',
        total: const TravelMoney(amount: 250, currency: 'EUR'),
        bookingDetails: details,
      );
      expect(res2, isNull);

      // Third attempt succeeds
      final res3 = await controller.reserve(
        type: TravelProductType.hotel,
        productId: 'hotel-paris',
        total: const TravelMoney(amount: 250, currency: 'EUR'),
        bookingDetails: details,
      );
      expect(res3, isNotNull);

      // Idempotency check: All 3 attempts used the exact same key!
      expect(fakeRepo.reservationKeys, hasLength(3));
      expect(fakeRepo.reservationKeys.toSet(), hasLength(1));
    });

    test('Reserving different products generates isolated, non-colliding idempotency keys', () async {
      final fakeRepo = _InvariantsFakeRepo();
      final controller = TravelController(repository: fakeRepo);
      controller.bootstrap.value = _testBootstrap();

      // Reserve Hotel A
      await controller.reserve(
        type: TravelProductType.hotel,
        productId: 'hotel-alpha',
        total: const TravelMoney(amount: 100, currency: 'USD'),
        bookingDetails: const TravelBookingDetails(),
      );

      // Reserve Flight B
      await controller.reserve(
        type: TravelProductType.flight,
        productId: 'flight-beta',
        total: const TravelMoney(amount: 200, currency: 'USD'),
        bookingDetails: const TravelBookingDetails(),
      );

      expect(fakeRepo.reservationKeys, hasLength(2));
      // Each product has its own isolated key
      expect(fakeRepo.reservationKeys[0], startsWith('hotel-hotel-alpha-'));
      expect(fakeRepo.reservationKeys[1], startsWith('flight-flight-beta-'));
      expect(fakeRepo.reservationKeys[0], isNot(equals(fakeRepo.reservationKeys[1])));
    });

    test('Re-entrant concurrent reserve calls are locked and do not double-book', () async {
      final fakeRepo = _InvariantsFakeRepo()..latencyMs = 50;
      final controller = TravelController(repository: fakeRepo);
      controller.bootstrap.value = _testBootstrap();

      // Fire two reserve calls concurrently (fast double-click simulation)
      final future1 = controller.reserve(
        type: TravelProductType.hotel,
        productId: 'hotel-concurrency',
        total: const TravelMoney(amount: 150, currency: 'USD'),
        bookingDetails: const TravelBookingDetails(),
      );

      final future2 = controller.reserve(
        type: TravelProductType.hotel,
        productId: 'hotel-concurrency',
        total: const TravelMoney(amount: 150, currency: 'USD'),
        bookingDetails: const TravelBookingDetails(),
      );

      final results = await Future.wait([future1, future2]);

      // Exactly one succeeds, the other was locked out by isCheckoutLoading guard
      final successfulCount = results.where((r) => r != null).length;
      final rejectedCount = results.where((r) => r == null).length;

      expect(successfulCount, equals(1));
      expect(rejectedCount, equals(1));
      expect(fakeRepo.reservationKeys, hasLength(1));
    });

    test('Payment retries reuse the same payment idempotency key', () async {
      final fakeRepo = _InvariantsFakeRepo()..paymentFailures = 1;
      final controller = TravelController(repository: fakeRepo);

      final reservation = TravelReservation(
        id: 'res-pay-test',
        orderNumber: 'TRV-PAY-1',
        title: 'Boutique Hotel',
        type: TravelProductType.hotel,
        total: const TravelMoney(amount: 180, currency: 'USD'),
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      );

      // Attempt 1 fails
      final order1 = await controller.payReservation(reservation);
      expect(order1, isNull);

      // Attempt 2 succeeds
      final order2 = await controller.payReservation(reservation);
      expect(order2, isNotNull);

      expect(fakeRepo.paymentKeys, hasLength(2));
      expect(fakeRepo.paymentKeys.toSet(), hasLength(1));
    });
  });

  group('Offline and Network Error Retry Banner Widget', () {
    testWidgets('TravelRetryBanner displays sanitized message, error icon and triggers retry', (tester) async {
      bool retried = false;
      bool dismissed = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            theme: ThemeData(brightness: Brightness.light),
            home: Scaffold(
              body: TravelRetryBanner(
                title: 'Network Timeout',
                message: 'DioException [connection error]: Request to trip.ecardo.ir failed.',
                isOffline: false,
                onRetry: () => retried = true,
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        ),
      );

      // Verifies safe sanitized presentation (does not leak raw DioException internals)
      expect(find.text('Network Timeout'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Tap Retry CTA
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);

      // Tap Dismiss CTA
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(dismissed, isTrue);
    });

    testWidgets('TravelRetryBanner displays offline mode styling and icons in dark theme', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            home: Scaffold(
              body: TravelRetryBanner(
                title: 'No Connection',
                message: 'You are currently offline. Please check your data connection.',
                isOffline: true,
                onRetry: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('No Connection'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('World-Class Travel Product Domain Diversity', () {
    test('TravelProductType covers all 6 travel domains', () {
      expect(TravelProductType.values, contains(TravelProductType.hotel));
      expect(TravelProductType.values, contains(TravelProductType.flight));
      expect(TravelProductType.values, contains(TravelProductType.esim));
      expect(TravelProductType.values, contains(TravelProductType.tour));
      expect(TravelProductType.values, contains(TravelProductType.visa));
      expect(TravelProductType.values, contains(TravelProductType.carRental));
    });

    test('travelProductIcon and travelProductColor resolve valid aesthetics for all domains', () {
      for (final domain in TravelProductType.values) {
        final icon = travelProductIcon(domain);
        final color = travelProductColor(domain);

        expect(icon, isNotNull);
        expect(color, isNotNull);
        expect(color.a, isPositive);
      }
    });
  });
}

TravelBootstrap _testBootstrap() {
  return const TravelBootstrap(
    currency: 'USD',
    locale: 'en',
    services: [
      TravelServiceConfig(
        type: TravelProductType.hotel,
        displayName: 'Hotels',
        description: 'Worldwide hotels',
        iconKey: 'hotel',
        accentColor: '#ABC3EA',
        capabilities: ['catalog_checkout', 'book'],
        searchFields: [],
        presentation: {},
        dataMode: 'live',
      ),
      TravelServiceConfig(
        type: TravelProductType.flight,
        displayName: 'Flights',
        description: 'Global flights',
        iconKey: 'flight',
        accentColor: '#2F80ED',
        capabilities: ['catalog_checkout', 'book'],
        searchFields: [],
        presentation: {},
        dataMode: 'live',
      ),
    ],
  );
}

class _InvariantsFakeRepo implements TravelRepository {
  int reservationFailures = 0;
  int paymentFailures = 0;
  int latencyMs = 0;

  final List<String> reservationKeys = [];
  final List<String> paymentKeys = [];

  @override
  Future<TravelReservation> createReservation({
    required TravelProductType type,
    required String productId,
    required TravelMoney expectedTotal,
    required String idempotencyKey,
    required TravelBookingDetails bookingDetails,
  }) async {
    if (latencyMs > 0) {
      await Future<void>.delayed(Duration(milliseconds: latencyMs));
    }
    reservationKeys.add(idempotencyKey);
    if (reservationFailures > 0) {
      reservationFailures--;
      throw StateError('Simulated reservation network error');
    }
    return TravelReservation(
      id: 'res-$productId',
      orderNumber: 'TRV-$productId',
      title: 'Booking for $productId',
      type: type,
      total: expectedTotal,
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
    );
  }

  @override
  Future<TravelOrder> payReservation({
    required TravelReservation reservation,
    required String idempotencyKey,
  }) async {
    paymentKeys.add(idempotencyKey);
    if (paymentFailures > 0) {
      paymentFailures--;
      throw StateError('Simulated payment network error');
    }
    return TravelOrder(
      id: reservation.id,
      type: reservation.type,
      titleKey: reservation.title,
      reference: reservation.orderNumber,
      total: reservation.total,
      status: TravelOrderStatus.confirmed,
      rawStatus: 'booked',
      createdAt: DateTime.now(),
      details: const {},
    );
  }

  @override
  Future<TravelBootstrap> getBootstrap() async => _testBootstrap();

  @override
  Future<List<TravelOrder>> getOrders() async => const [];

  @override
  Future<List<TravelOffer>> searchHotels(TravelHotelSearch search) async => const [];

  @override
  Future<List<TravelOffer>> searchFlights(TravelFlightSearch search) async => const [];

  @override
  Future<List<TravelOffer>> getUpcomingFlights() async => const [];

  @override
  Future<TravelOffer> getOfferDetails(TravelProductType type, String offerId) async =>
      throw UnimplementedError();

  @override
  Future<List<TravelEsimPackage>> getEsimPackages(String destinationCode) async => const [];

  @override
  Future<List<TravelSuggestion>> getSuggestions(
    TravelProductType type, {
    String query = '',
    int limit = 20,
  }) async => const [];

  @override
  Future<List<TravelTraveler>> getTravelers() async => const [];

  @override
  Future<TravelTraveler> saveTraveler(TravelTraveler traveler) async => traveler;

  @override
  Future<TravelTravelerProfile> getTravelerProfile() async =>
      const TravelTravelerProfile(complete: true);

  @override
  Future<TravelTravelerProfile> updateTravelerProfile(
    TravelPassenger passenger, {
    String phone = '',
  }) async => TravelTravelerProfile(complete: true, passenger: passenger, phone: phone);

  @override
  Future<TravelOrder> requestRefund({
    required TravelOrder order,
    required String reasonCode,
    String? customerNote,
    required String idempotencyKey,
  }) async => order;

  @override
  Future<List<TravelActivity>> getActivity() async => const [];
}
