package com.mobilprogramlar.unitraflow.convert;

import com.mobilprogramlar.unitraflow.model.Category;
import com.mobilprogramlar.unitraflow.model.UnitDef;

import java.util.ArrayList;
import java.util.List;

public class UnitConverter {

  // Base units:
  // LENGTH -> meter
  // MASS -> kilogram
  // VOLUME -> liter
  // TEMPERATURE -> special

  public static List<UnitDef> units(Category c) {
    List<UnitDef> list = new ArrayList<>();
    switch (c) {
      case LENGTH:
        list.add(new UnitDef("m", "Meter (m)", 1.0));
        list.add(new UnitDef("km", "Kilometer (km)", 1000.0));
        list.add(new UnitDef("cm", "Centimeter (cm)", 0.01));
        list.add(new UnitDef("mm", "Millimeter (mm)", 0.001));
        list.add(new UnitDef("in", "Inch (in)", 0.0254));
        list.add(new UnitDef("ft", "Foot (ft)", 0.3048));
        list.add(new UnitDef("yd", "Yard (yd)", 0.9144));
        list.add(new UnitDef("mi", "Mile (mi)", 1609.344));
        break;

      case MASS:
        list.add(new UnitDef("kg", "Kilogram (kg)", 1.0));
        list.add(new UnitDef("g", "Gram (g)", 0.001));
        list.add(new UnitDef("mg", "Milligram (mg)", 0.000001));
        list.add(new UnitDef("lb", "Pound (lb)", 0.45359237));
        list.add(new UnitDef("oz", "Ounce (oz)", 0.028349523125));
        break;

      case VOLUME:
        // base = liter
        list.add(new UnitDef("l", "Liter (L)", 1.0));
        list.add(new UnitDef("ml", "Milliliter (mL)", 0.001));
        list.add(new UnitDef("m3", "Cubic meter (m³)", 1000.0));

        // US/UK differences (same name, different value!)
        list.add(new UnitDef("gal_us", "Gallon (US)", 3.785411784));
        list.add(new UnitDef("gal_uk", "Gallon (UK)", 4.54609));
        list.add(new UnitDef("pt_us", "Pint (US)", 0.473176473));
        list.add(new UnitDef("pt_uk", "Pint (UK)", 0.56826125));
        list.add(new UnitDef("floz_us", "Fluid ounce (US)", 0.0295735295625));
        list.add(new UnitDef("floz_uk", "Fluid ounce (UK)", 0.0284130625));
        break;

      case TEMPERATURE:
        list.add(new UnitDef("c", "Celsius (°C)", 1.0));
        list.add(new UnitDef("f", "Fahrenheit (°F)", 1.0));
        list.add(new UnitDef("k", "Kelvin (K)", 1.0));
        break;
    }
    return list;
  }

  public static double convert(Category c, String fromId, String toId, double value) {
    if (c == Category.TEMPERATURE) return convertTemp(fromId, toId, value);

    UnitDef from = find(c, fromId);
    UnitDef to = find(c, toId);
    if (from == null || to == null) return Double.NaN;

    double base = value * from.toBaseFactor; // to base
    return base / to.toBaseFactor;           // to target
  }

  private static UnitDef find(Category c, String id) {
    for (UnitDef u : units(c)) if (u.id.equals(id)) return u;
    return null;
  }

  private static double convertTemp(String from, String to, double v) {
    // convert to Celsius first
    double c;
    switch (from) {
      case "c": c = v; break;
      case "f": c = (v - 32.0) * (5.0/9.0); break;
      case "k": c = v - 273.15; break;
      default: return Double.NaN;
    }
    switch (to) {
      case "c": return c;
      case "f": return c * (9.0/5.0) + 32.0;
      case "k": return c + 273.15;
      default: return Double.NaN;
    }
  }
}
