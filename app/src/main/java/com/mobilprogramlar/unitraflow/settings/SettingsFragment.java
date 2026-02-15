package com.mobilprogramlar.unitraflow.settings;

import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.core.os.LocaleListCompat;
import androidx.preference.Preference;
import androidx.preference.PreferenceFragmentCompat;
import com.mobilprogramlar.unitraflow.R;

public class SettingsFragment extends PreferenceFragmentCompat {

  @Override public void onCreatePreferences(@Nullable Bundle savedInstanceState, @Nullable String rootKey) {
    setPreferencesFromResource(R.xml.prefs, rootKey);

    Preference theme = findPreference("theme_mode");
    if (theme != null) {
      theme.setOnPreferenceChangeListener((p, newVal) -> {
        applyTheme(String.valueOf(newVal));
        return true;
      });
    }

    Preference lang = findPreference("lang");
    if (lang != null) {
      lang.setOnPreferenceChangeListener((p, newVal) -> {
        applyLang(String.valueOf(newVal));
        return true;
      });
    }
  }

  private void applyTheme(String mode) {
    switch (mode) {
      case "light":
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
        break;
      case "dark":
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
        break;
      default:
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
        break;
    }
  }

  private void applyLang(String langTag) {
    // e.g. "tr", "es", "zh-CN", "hi", "en"
    AppCompatDelegate.setApplicationLocales(LocaleListCompat.forLanguageTags(langTag));
  }
}
