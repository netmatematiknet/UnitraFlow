package com.mobilprogramlar.unitraflow.model;

public class UnitDef {
  public final String id;
  public final String label;
  public final double toBaseFactor; // for linear units (base depends on category)
  public final double toBaseOffset; // rarely used (not for temperature here)

  public UnitDef(String id, String label, double toBaseFactor) {
    this(id, label, toBaseFactor, 0.0);
  }

  public UnitDef(String id, String label, double toBaseFactor, double toBaseOffset) {
    this.id = id;
    this.label = label;
    this.toBaseFactor = toBaseFactor;
    this.toBaseOffset = toBaseOffset;
  }
}
