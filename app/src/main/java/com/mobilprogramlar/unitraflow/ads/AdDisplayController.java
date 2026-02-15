package com.mobilprogramlar.unitraflow.ads;

import android.app.Activity;
import android.content.Context;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.interstitial.InterstitialAd;
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback;

import com.mobilprogramlar.unitraflow.R;
import com.mobilprogramlar.unitraflow.settings.AppSettings;

import java.util.Random;

public class AdDisplayController {

  private static final Random RNG = new Random();
  private static long lastShownMs = 0L;
  private static final long COOLDOWN_MS = 60_000L; // 60 sec

  private static InterstitialAd cachedInterstitial = null;
  private static long lastLoadMs = 0L;

  public static void attachBanner(Activity a, FrameLayout container) {
    if (container == null) return;
    if (!AppSettings.adsEnabled(a)) return;

    MobileAds.initialize(a);

    container.removeAllViews();

    AdView adView = new AdView(a);
    adView.setAdSize(AdSize.BANNER);

    String bannerId = AppSettings.bannerId(a, a.getString(R.string.admob_banner_test));
    adView.setAdUnitId(bannerId);

    container.addView(adView, new FrameLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.WRAP_CONTENT
    ));

    adView.loadAd(new AdRequest.Builder().build());
  }

  public static void maybeShowInterstitial(Activity a) {
    if (!AppSettings.adsEnabled(a)) return;

    int p = AppSettings.interstitialProb(a); // 0..100
    int r = RNG.nextInt(101);
    long now = System.currentTimeMillis();

    if (now - lastShownMs < COOLDOWN_MS) return;
    if (r > p) return;

    loadIfNeeded(a.getApplicationContext());

    if (cachedInterstitial != null) {
      cachedInterstitial.show(a);
      cachedInterstitial = null;
      lastShownMs = now;
    }
  }

  private static void loadIfNeeded(Context c) {
    long now = System.currentTimeMillis();
    if (cachedInterstitial != null) return;
    if (now - lastLoadMs < 20_000L) return; // avoid spamming loads

    lastLoadMs = now;

    String unitId = AppSettings.interstitialId(c, c.getString(R.string.admob_interstitial_test));
    MobileAds.initialize(c);

    InterstitialAd.load(
        c,
        unitId,
        new AdRequest.Builder().build(),
        new InterstitialAdLoadCallback() {
          @Override public void onAdLoaded(InterstitialAd ad) { cachedInterstitial = ad; }
        }
    );
  }
}
