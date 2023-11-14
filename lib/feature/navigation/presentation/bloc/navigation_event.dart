abstract class NavigationEvent{}

class NavigationRouteEvent extends NavigationEvent{
  final int index;
  NavigationRouteEvent({required this.index});
}