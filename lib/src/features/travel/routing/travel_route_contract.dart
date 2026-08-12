enum TravelRouteKind {
  shell,
  dashboard,
  hotel,
  flight,
  esim,
  tour,
  bookings,
  account,
  support,
}

class TravelRouteContract {
  final String id;
  final String path;
  final TravelRouteKind kind;
  final bool requiresAuthentication;
  final bool isFeatureRoute;

  const TravelRouteContract({
    required this.id,
    required this.path,
    required this.kind,
    this.requiresAuthentication = true,
    this.isFeatureRoute = true,
  });
}

/// Canonical route IDs for the Travel module.
///
/// These are contracts only; a route is not considered implemented until a
/// real screen and its API/state contract are connected.
class TravelRoutes {
  const TravelRoutes._();

  static const TravelRouteContract shell = TravelRouteContract(
    id: 'travel.shell',
    path: '/travel_foundation_route',
    kind: TravelRouteKind.shell,
    isFeatureRoute: false,
  );

  static const TravelRouteContract dashboard = TravelRouteContract(
    id: 'travel.dashboard',
    path: '/travel/dashboard',
    kind: TravelRouteKind.dashboard,
  );

  static const TravelRouteContract hotelSearch = TravelRouteContract(
    id: 'travel.hotel.search',
    path: '/travel/hotel/search',
    kind: TravelRouteKind.hotel,
  );

  static const TravelRouteContract hotelResults = TravelRouteContract(
    id: 'travel.hotel.results',
    path: '/travel/hotel/results',
    kind: TravelRouteKind.hotel,
  );

  static const TravelRouteContract hotelDetails = TravelRouteContract(
    id: 'travel.hotel.details',
    path: '/travel/hotel/details',
    kind: TravelRouteKind.hotel,
  );

  static const TravelRouteContract flightSearch = TravelRouteContract(
    id: 'travel.flight.search',
    path: '/travel/flight/search',
    kind: TravelRouteKind.flight,
  );

  static const TravelRouteContract flightResults = TravelRouteContract(
    id: 'travel.flight.results',
    path: '/travel/flight/results',
    kind: TravelRouteKind.flight,
  );

  static const TravelRouteContract flightDetails = TravelRouteContract(
    id: 'travel.flight.details',
    path: '/travel/flight/details',
    kind: TravelRouteKind.flight,
  );

  static const TravelRouteContract esimPackages = TravelRouteContract(
    id: 'travel.esim.packages',
    path: '/travel/esim/packages',
    kind: TravelRouteKind.esim,
  );

  static const TravelRouteContract esimActivation = TravelRouteContract(
    id: 'travel.esim.activation',
    path: '/travel/esim/activation',
    kind: TravelRouteKind.esim,
  );

  static const TravelRouteContract tourSearch = TravelRouteContract(
    id: 'travel.tour.search',
    path: '/travel/tour/search',
    kind: TravelRouteKind.tour,
  );

  static const TravelRouteContract tourResults = TravelRouteContract(
    id: 'travel.tour.results',
    path: '/travel/tour/results',
    kind: TravelRouteKind.tour,
  );

  static const TravelRouteContract tourDetails = TravelRouteContract(
    id: 'travel.tour.details',
    path: '/travel/tour/details',
    kind: TravelRouteKind.tour,
  );

  static const TravelRouteContract bookings = TravelRouteContract(
    id: 'travel.bookings',
    path: '/travel/bookings',
    kind: TravelRouteKind.bookings,
  );

  static const TravelRouteContract account = TravelRouteContract(
    id: 'travel.account',
    path: '/travel/account',
    kind: TravelRouteKind.account,
  );

  static const TravelRouteContract support = TravelRouteContract(
    id: 'travel.support',
    path: '/travel/support',
    kind: TravelRouteKind.support,
  );

  static const List<TravelRouteContract> all = <TravelRouteContract>[
    shell,
    dashboard,
    hotelSearch,
    hotelResults,
    hotelDetails,
    flightSearch,
    flightResults,
    flightDetails,
    esimPackages,
    esimActivation,
    tourSearch,
    tourResults,
    tourDetails,
    bookings,
    account,
    support,
  ];

  static TravelRouteContract? fromPath(String path) {
    for (final route in all) {
      if (route.path == path) return route;
    }
    return null;
  }
}
