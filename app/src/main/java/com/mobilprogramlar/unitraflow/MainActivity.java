package com.mobilprogramlar.unitraflow;

import android.content.Intent;
import android.os.Bundle;
import android.widget.FrameLayout;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.os.LocaleListCompat;
import androidx.appcompat.app.AppCompatDelegate;

import com.google.android.material.tabs.TabLayoutMediator;

import com.mobilprogramlar.unitraflow.ads.AdDisplayController;
import com.mobilprogramlar.unitraflow.databinding.ActivityMainBinding;
import com.mobilprogramlar.unitraflow.model.Category;
import com.mobilprogramlar.unitraflow.other.OtherAppsActivity;
import com.mobilprogramlar.unitraflow.settings.AppSettings;
import com.mobilprogramlar.unitraflow.settings.SettingsActivity;
import com.mobilprogramlar.unitraflow.ui.CategoryPagerAdapter;

public class MainActivity extends AppCompatActivity {

  private ActivityMainBinding b;

  @Override protected void onCreate(Bundle savedInstanceState) {
    applyThemeAndLang();

    super.onCreate(savedInstanceState);
    b = ActivityMainBinding.inflate(getLayoutInflater());
    setContentView(b.getRoot());

    setSupportActionBar(b.toolbar);

    Category[] cats = new Category[]{Category.LENGTH, Category.MASS, Category.TEMPERATURE, Category.VOLUME};
    b.viewPager.setAdapter(new CategoryPagerAdapter(this, cats));

    new TabLayoutMediator(b.tabLayout, b.viewPager, (tab, position) -> {
      tab.setText(getString(cats[position].titleRes));
    }).attach();

    b.toolbar.setOnMenuItemClickListener(item -> {
      int id = item.getItemId();
      if (id == R.id.action_settings) {
        startActivity(new Intent(this, SettingsActivity.class));
        return true;
      }
      if (id == R.id.action_other_apps) {
        startActivity(new Intent(this, OtherAppsActivity.class));
        return true;
      }
      return false;
    });
    b.toolbar.inflateMenu(R.menu.menu_main);

    FrameLayout ad = findViewById(R.id.ad_container);
    AdDisplayController.attachBanner(this, ad);
  }

  @Override protected void onStart() {
    super.onStart();
    AdDisplayController.maybeShowInterstitial(this);
  }

  private void applyThemeAndLang() {
    // Theme
    String mode = AppSettings.themeMode(this);
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

    // Language
    String lang = AppSettings.lang(this); // en,tr,es,zh-CN,hi
    AppCompatDelegate.setApplicationLocales(LocaleListCompat.forLanguageTags(lang));
  }
}
