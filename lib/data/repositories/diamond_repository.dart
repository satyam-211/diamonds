import 'package:diamonds/data/data.dart';

import '../models/diamond.dart';

class DiamondRepository {
  // Get all diamonds
  List<Diamond> getAllDiamonds() {
    return diamonds;
  }

  // Filter diamonds based on criteria
  List<Diamond> filterDiamonds({
    double? minCarat,
    double? maxCarat,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
  }) {
    return diamonds.where((diamond) {
      // Filter by carat range
      if (minCarat != null && diamond.carat < minCarat) {
        return false;
      }
      if (maxCarat != null && diamond.carat > maxCarat) {
        return false;
      }

      // Filter by lab
      if (lab != null && lab.isNotEmpty && diamond.lab != lab) {
        return false;
      }

      // Filter by shape
      if (shape != null && shape.isNotEmpty && diamond.shape != shape) {
        return false;
      }

      // Filter by color
      if (color != null && color.isNotEmpty && diamond.color != color) {
        return false;
      }

      // Filter by clarity
      if (clarity != null && clarity.isNotEmpty && diamond.clarity != clarity) {
        return false;
      }

      return true;
    }).toList();
  }

  // Sort diamonds by final price
  List<Diamond> sortByFinalPrice(List<Diamond> diamonds, bool ascending) {
    List<Diamond> sortedList = List.from(diamonds);
    if (ascending) {
      sortedList.sort((a, b) => a.finalAmount.compareTo(b.finalAmount));
    } else {
      sortedList.sort((a, b) => b.finalAmount.compareTo(a.finalAmount));
    }
    return sortedList;
  }

  // Sort diamonds by carat weight
  List<Diamond> sortByCaratWeight(List<Diamond> diamonds, bool ascending) {
    List<Diamond> sortedList = List.from(diamonds);
    if (ascending) {
      sortedList.sort((a, b) => a.carat.compareTo(b.carat));
    } else {
      sortedList.sort((a, b) => b.carat.compareTo(a.carat));
    }
    return sortedList;
  }

  Map<String, List<String>> getFilterOptions() {
    return {
      'labs': getLabOptions(),
      'shapes': getShapeOptions(),
      'colors': getColorOptions(),
      'clarities': getClarityOptions(),
    };
  }

  // Get unique options for filter dropdowns
  List<String> getLabOptions() => labs;
  List<String> getShapeOptions() => shapes;
  List<String> getColorOptions() => colors;
  List<String> getClarityOptions() => clarities;
}