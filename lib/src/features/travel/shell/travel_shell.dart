import 'package:flutter/material.dart';

import '../core/design_system/travel_design_tokens.dart';
import '../presentation/widgets/travel_feedback.dart';
import '../routing/travel_route_contract.dart';

class TravelShellDestination {
  final TravelRouteContract route;
  final String label;
  final IconData icon;

  const TravelShellDestination({
    required this.route,
    required this.label,
    required this.icon,
  });
}

class TravelShell extends StatelessWidget {
  final Widget body;
  final String? title;
  final String activePath;
  final List<TravelShellDestination> destinations;
  final ValueChanged<TravelRouteContract>? onDestinationSelected;
  final List<Widget>? actions;
  final bool showBackButton;

  const TravelShell({
    super.key,
    required this.body,
    this.title,
    this.activePath = '',
    this.destinations = const <TravelShellDestination>[],
    this.onDestinationSelected,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = TravelThemeData.light();
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: TravelColors.canvas,
        appBar: AppBar(
          automaticallyImplyLeading: showBackButton,
          title: title == null ? null : Text(title!),
          actions: actions,
        ),
        body: SafeArea(child: body),
        bottomNavigationBar: destinations.isEmpty
            ? null
            : NavigationBar(
                selectedIndex: _activeIndex(),
                onDestinationSelected: (index) {
                  final route = destinations[index].route;
                  onDestinationSelected?.call(route);
                },
                destinations: destinations
                    .map(
                      (destination) => NavigationDestination(
                        icon: Icon(destination.icon),
                        label: destination.label,
                      ),
                    )
                    .toList(growable: false),
              ),
      ),
    );
  }

  int _activeIndex() {
    final index = destinations.indexWhere(
      (destination) => destination.route.path == activePath,
    );
    return index < 0 ? 0 : index;
  }
}

/// Foundation-only shell route. It deliberately does not build a product
/// dashboard; domain screens will be mounted after their contracts are ready.
class TravelShellScreen extends StatelessWidget {
  const TravelShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TravelShell(
      title: 'Travel',
      body: TravelEmptyState(
        title: 'Travel foundation',
        message:
            'Travel services will be mounted here after their contracts are ready.',
        icon: Icons.account_tree_outlined,
      ),
    );
  }
}
