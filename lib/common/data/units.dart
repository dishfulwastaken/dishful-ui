enum CookingUnit {
  /// Volume
  teaspoon,
  tablespoon,
  fluid_ounce,
  gill,
  cup,
  pint,
  quart,
  gallon,
  milliliter,
  liter,
  deciliter,

  /// Mass and weight
  pound,
  ounce,
  milligram,
  gram,
  kilogram,

  /// Length
  millimeter,
  centimeter,
  meter,
  inch,
  foot,

  /// Temperature
  fahrenheit,
  celsius,
}

enum CookingUnitSystem { imperial, metric }

extension CookingUnitLabel on CookingUnit {
  CookingUnitSystem get system {
    switch (this) {
      case CookingUnit.fluid_ounce:
      case CookingUnit.gill:
      case CookingUnit.cup:
      case CookingUnit.pint:
      case CookingUnit.quart:
      case CookingUnit.gallon:
      case CookingUnit.pound:
      case CookingUnit.ounce:
      case CookingUnit.inch:
      case CookingUnit.foot:
      case CookingUnit.fahrenheit:
        return CookingUnitSystem.imperial;
      default:
        return CookingUnitSystem.metric;
    }
  }

  String get plural {
    switch (this) {
      case CookingUnit.inch:
        return "inches";
      case CookingUnit.foot:
        return "feet";
      case CookingUnit.celsius:
      case CookingUnit.fahrenheit:
        return this.name;
      default:
        return this.name + "s";
    }
  }

  String get abbreviation {
    switch (this) {
      case CookingUnit.teaspoon:
        return "tsp";
      case CookingUnit.tablespoon:
        return "tbsp";
      case CookingUnit.fluid_ounce:
        return "fl oz";
      case CookingUnit.milliliter:
        return "ml";
      case CookingUnit.liter:
        return "l";
      case CookingUnit.deciliter:
        return "dl";
      case CookingUnit.pound:
        return "lb";
      case CookingUnit.ounce:
        return "oz";
      case CookingUnit.milligram:
        return "mg";
      case CookingUnit.gram:
        return "g";
      case CookingUnit.kilogram:
        return "kg";
      case CookingUnit.millimeter:
        return "mm";
      case CookingUnit.centimeter:
        return "cm";
      case CookingUnit.meter:
        return "m";
      case CookingUnit.fahrenheit:
        return "°F";
      case CookingUnit.celsius:
        return "°C";
      default:
        return this.name;
    }
  }
}
