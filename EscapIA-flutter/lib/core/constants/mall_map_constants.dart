import 'dart:ui';
import 'package:escapia/features/live_map/data/models/edge_connection_model.dart';

class MallMapConstants {
  MallMapConstants._();
  static const double baseWidth = 1050;
  static const double baseHeight = 840;
  static const List<EdgeConnection> edges = [
    EdgeConnection("Zone_1", "Zone_3", 10),
    EdgeConnection("Zone_1", "Zone_4", 15),
    EdgeConnection("Zone_2", "Zone_3", 12),
    EdgeConnection("Zone_2", "Zone_5", 10),
    EdgeConnection("Zone_3", "Zone_6", 20),
    EdgeConnection("Zone_4", "Exit_A", 25),
    EdgeConnection("Zone_5", "Zone_7", 15),
    EdgeConnection("Zone_6", "Exit_B", 30),
    EdgeConnection("Zone_7", "Exit_A", 10),
    EdgeConnection("Zone_8", "Exit_B", 10),
    EdgeConnection("Zone_4", "Zone_8", 20),
    EdgeConnection("Zone_5", "Zone_6", 15),
  ];
  static final Map<String, Rect> zoneRects = {
    'Zone_1': const Rect.fromLTWH(120, 80, 240, 110),
    'Zone_2': const Rect.fromLTWH(620, 80, 280, 110),
    'Zone_3': const Rect.fromLTWH(110, 275, 200, 110),
    'Zone_4': const Rect.fromLTWH(410, 275, 220, 110),
    'Zone_5': const Rect.fromLTWH(730, 275, 220, 110),
    'Zone_6': const Rect.fromLTWH(110, 480, 200, 110),
    'Zone_8': const Rect.fromLTWH(410, 480, 220, 110),
    'Zone_7': const Rect.fromLTWH(730, 480, 220, 110),
    'Exit_A': const Rect.fromLTWH(170, 715, 125, 48),
    'Exit_B': const Rect.fromLTWH(580, 715, 125, 48),
  };
  static const Map<String, List<Offset>> pathMap = {
    'Zone_1-Zone_3': [Offset(150, 190), Offset(150, 275)],
    'Zone_1-Zone_4': [
      Offset(300, 190),
      Offset(300, 215),
      Offset(520, 215),
      Offset(520, 275),
    ],
    'Zone_2-Zone_3': [
      Offset(650, 190),
      Offset(650, 250),
      Offset(240, 250),
      Offset(240, 275),
    ],
    'Zone_2-Zone_5': [Offset(850, 190), Offset(850, 275)],
    'Zone_3-Zone_6': [Offset(150, 385), Offset(150, 480)],
    'Zone_4-Zone_8': [Offset(520, 385), Offset(520, 480)],
    'Zone_5-Zone_7': [Offset(850, 385), Offset(850, 480)],
    'Zone_4-Exit_A': [
      Offset(430, 385),
      Offset(430, 402),
      Offset(60, 402),
      Offset(60, 739),
      Offset(170, 739),
    ],
    'Zone_5-Zone_6': [
      Offset(760, 385),
      Offset(760, 448),
      Offset(240, 448),
      Offset(240, 480),
    ],
    'Zone_8-Exit_B': [Offset(595, 590), Offset(595, 715)],
    'Zone_6-Exit_B': [
      Offset(250, 590),
      Offset(250, 620),
      Offset(650, 620),
      Offset(650, 715),
    ],
    'Zone_7-Exit_A': [
      Offset(780, 590),
      Offset(780, 675),
      Offset(230, 675),
      Offset(230, 715),
    ],
  };
  static const Map<String, Offset> badgeOffsets = {
    'Zone_1-Zone_3': Offset(150, 230),
    'Zone_1-Zone_4': Offset(410, 215),
    'Zone_2-Zone_3': Offset(330, 250),
    'Zone_2-Zone_5': Offset(850, 230),
    'Zone_3-Zone_6': Offset(150, 432),
    'Zone_4-Zone_8': Offset(520, 432),
    'Zone_5-Zone_7': Offset(850, 432),
    'Zone_4-Exit_A': Offset(60, 570),
    'Zone_5-Zone_6': Offset(350, 448),
    'Zone_8-Exit_B': Offset(595, 650),
    'Zone_6-Exit_B': Offset(420, 620),
    'Zone_7-Exit_A': Offset(420, 675),
  };
}
