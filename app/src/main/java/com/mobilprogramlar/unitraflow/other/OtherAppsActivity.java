package com.mobilprogramlar.unitraflow.other;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.FrameLayout;

import androidx.appcompat.app.AppCompatActivity;

import com.mobilprogramlar.unitraflow.R;
import com.mobilprogramlar.unitraflow.ads.AdDisplayController;

public class OtherAppsActivity extends AppCompatActivity {

  private static final String DEV_URL =
      "https://play.google.com/store/apps/dev?id=7525788731933934956&hl=tr";

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setTitle(R.string.other_apps_title);
    setContentView(R.layout.activity_other_apps);

    findViewById(R.id.btnOpenDev).setOnClickListener(v -> {
      startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(DEV_URL)));
    });

    FrameLayout ad = findViewById(R.id.ad_container);
    AdDisplayController.attachBanner(this, ad);
  }

  @Override protected void onStart() {
    super.onStart();
    AdDisplayController.maybeShowInterstitial(this);
  }
}
