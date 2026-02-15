package com.mobilprogramlar.unitraflow.settings;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.mobilprogramlar.unitraflow.R;
import com.mobilprogramlar.unitraflow.ads.AdDisplayController;

public class SettingsActivity extends AppCompatActivity {
  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setTitle(R.string.settings_title);
    getSupportFragmentManager()
        .beginTransaction()
        .replace(android.R.id.content, new SettingsFragment())
        .commit();
  }

  @Override protected void onStart() {
    super.onStart();
    AdDisplayController.maybeShowInterstitial(this);
  }
}
