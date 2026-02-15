package com.mobilprogramlar.unitraflow.settings;

import android.content.Context;
import android.content.SharedPreferences;

public class AppSettings {
  private static final String PREFS = "unitraflow_prefs";

  public static SharedPreferences prefs(Context c) {
    return c.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
  }

  public static boolean adsEnabled(Context c) {
    return prefs(c).getBoolean("ads_enabled", true);
  }

  public static String bannerId(Context c, String fallback) {
    return prefs(c).getString("banner_id", fallback);
  }

  public static String interstitialId(Context c, String fallback) {
    return prefs(c).getString("interstitial_id", fallback);
  }

  public static int interstitialProb(Context c) {
    return prefs(c).getInt("interstitial_prob", 20);
  }

  public static String themeMode(Context c) {
    return prefs(c).getString("theme_mode", "system");
  }

  public static String lang(Context c) {
    return prefs(c).getString("lang", "en");
  }
}
