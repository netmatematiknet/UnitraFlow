package com.mobilprogramlar.unitraflow.model;

import androidx.annotation.StringRes;
import com.mobilprogramlar.unitraflow.R;

public enum Category {
  LENGTH(R.string.cat_length),
  MASS(R.string.cat_mass),
  TEMPERATURE(R.string.cat_temperature),
  VOLUME(R.string.cat_volume);

  @StringRes public final int titleRes;
  Category(@StringRes int titleRes) { this.titleRes = titleRes; }
}
