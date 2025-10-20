import 'package:flutter/material.dart';

enum GroupType {
  trip,
  home,
  couple,
  other;

  String get displayName => switch (this) {
        GroupType.trip => "Trip",
        GroupType.home => "Home",
        GroupType.couple => "Couple",
        GroupType.other => "Other",
      };

  IconData get icon => switch (this) {
        GroupType.trip => Icons.flight_takeoff_outlined,
        GroupType.home => Icons.home_outlined,
        GroupType.couple => Icons.favorite_border_outlined,
        GroupType.other => Icons.list_alt_outlined,
      };

  String get hintText => switch (this) {
        GroupType.trip => "Kashmir trip",
        GroupType.home => "3BHK hunters",
        GroupType.couple => "You & Me",
        GroupType.other => "Coworkers",
      };
}
