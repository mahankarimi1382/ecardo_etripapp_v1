import 'travel_route_contract.dart';

class TravelRouteRegistry {
  const TravelRouteRegistry._();

  static const List<TravelRouteContract> contracts = TravelRoutes.all;

  static TravelRouteContract? resolve(String path) =>
      TravelRoutes.fromPath(path);

  static bool contains(String path) => resolve(path) != null;
}
