#!/usr/bin/env bash
set -euo pipefail

APP_ID="com.mobilprogramlar.unitraflow"
APP_NS="com.mobilprogramlar.unitraflow"

echo "==> Writing .gitignore"
cat > .gitignore <<'GITIGNORE'
.gradle/
.local/
**/build/
**/.idea/
**/*.iml
.DS_Store
local.properties
captures/
.externalNativeBuild/
.cxx/
GITIGNORE

echo "==> Root Gradle files"
cat > settings.gradle <<'SETTINGS'
pluginManagement {
  repositories {
    google()
    mavenCentral()
    gradlePluginPortal()
  }
}
dependencyResolutionManagement {
  repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
  repositories {
    google()
    mavenCentral()
  }
}
rootProject.name = "UnitraFlow"
include(":app")
SETTINGS

cat > build.gradle <<'ROOTBUILD'
plugins {
  id 'com.android.application' version '8.2.2' apply false
}
ROOTBUILD

cat > gradle.properties <<'GRADLEPROPS'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.nonTransitiveRClass=true
GRADLEPROPS

echo "==> App module Gradle"
mkdir -p app
cat > app/build.gradle <<'APPBUILD'
plugins {
  id 'com.android.application'
}

android {
  namespace "com.mobilprogramlar.unitraflow"
  compileSdk 34

  defaultConfig {
    applicationId "com.mobilprogramlar.unitraflow"
    minSdk 23
    targetSdk 34
    versionCode 1
    versionName "1.0"
  }

  buildTypes {
    release {
      minifyEnabled false
      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
  }

  compileOptions {
    sourceCompatibility JavaVersion.VERSION_17
    targetCompatibility JavaVersion.VERSION_17
  }

  buildFeatures {
    viewBinding true
  }
}

dependencies {
  implementation "androidx.core:core:1.12.0"
  implementation "androidx.appcompat:appcompat:1.6.1"
  implementation "com.google.android.material:material:1.11.0"
  implementation "androidx.constraintlayout:constraintlayout:2.1.4"

  implementation "androidx.activity:activity:1.8.2"
  implementation "androidx.fragment:fragment:1.6.2"
  implementation "androidx.viewpager2:viewpager2:1.0.0"
  implementation "androidx.recyclerview:recyclerview:1.3.2"

  implementation "androidx.preference:preference:1.2.1"

  // AdMob (TEST IDs are in strings.xml by default)
  implementation "com.google.android.gms:play-services-ads:23.0.0"
}
APPBUILD

cat > app/proguard-rules.pro <<'PRO'
# Add your ProGuard rules here (release is minifyEnabled=false for now).
PRO

echo "==> Android source structure"
mkdir -p app/src/main/java/com/mobilprogramlar/unitraflow/{ads,convert,model,other,settings,ui}
mkdir -p app/src/main/res/{layout,menu,xml,values,values-night,values-tr,values-es,values-zh-rCN,values-hi,drawable}

cat > app/src/main/AndroidManifest.xml <<'MANIFEST'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

  <uses-permission android:name="android.permission.INTERNET" />

  <application
      android:allowBackup="true"
      android:label="@string/app_name"
      android:icon="@drawable/ic_unitraflow_logo"
      android:roundIcon="@drawable/ic_unitraflow_logo"
      android:supportsRtl="true"
      android:theme="@style/Theme.UnitraFlow">

    <!-- AdMob App ID (TEST by default). For production, replace in strings.xml and rebuild. -->
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="@string/admob_app_id" />

    <activity
        android:name=".settings.SettingsActivity"
        android:exported="false" />

    <activity
        android:name=".other.OtherAppsActivity"
        android:exported="false" />

    <activity
        android:name=".MainActivity"
        android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>
    </activity>

  </application>

</manifest>
MANIFEST

echo "==> Resources"
cat > app/src/main/res/drawable/ic_unitraflow_logo.xml <<'LOGO'
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="64dp"
    android:height="64dp"
    android:viewportWidth="64"
    android:viewportHeight="64">
  <path
      android:fillColor="#FF1A73E8"
      android:pathData="M12,10h40a6,6 0 0 1 6,6v32a6,6 0 0 1 -6,6H12a6,6 0 0 1 -6,-6V16a6,6 0 0 1 6,-6z"/>
  <path
      android:fillColor="#FFFFFFFF"
      android:pathData="M20,22h24v4H20zM20,30h24v4H20zM20,38h16v4H20z"/>
</vector>
LOGO

cat > app/src/main/res/values/strings.xml <<'STR'
<resources>
  <string name="app_name">UnitraFlow</string>

  <!-- Categories -->
  <string name="cat_length">Length</string>
  <string name="cat_mass">Mass</string>
  <string name="cat_temperature">Temperature</string>
  <string name="cat_volume">Volume</string>

  <!-- UI -->
  <string name="menu_settings">Settings</string>
  <string name="menu_other_apps">Other Apps</string>
  <string name="hint_value">Value</string>
  <string name="hint_from_unit">From unit</string>
  <string name="hint_to_unit">To unit</string>
  <string name="btn_swap">Swap</string>
  <string name="result">Result</string>

  <!-- Settings -->
  <string name="settings_title">Settings</string>
  <string name="pref_ads">Ads</string>
  <string name="pref_enable_ads">Enable ads</string>
  <string name="pref_banner_id">Banner Ad Unit ID</string>
  <string name="pref_interstitial_id">Interstitial Ad Unit ID</string>
  <string name="pref_interstitial_prob">Interstitial probability (0–100)</string>
  <string name="pref_theme">Theme</string>
  <string name="pref_language">Language</string>
  <string name="theme_system">System</string>
  <string name="theme_light">Light</string>
  <string name="theme_dark">Dark</string>

  <!-- Other Apps -->
  <string name="other_apps_title">Other Apps</string>
  <string name="open_developer_page">Open developer page</string>

  <!-- AdMob TEST defaults -->
  <string name="admob_app_id">ca-app-pub-3940256099942544~3347511713</string>
  <string name="admob_banner_test">ca-app-pub-3940256099942544/6300978111</string>
  <string name="admob_interstitial_test">ca-app-pub-3940256099942544/1033173712</string>
</resources>
STR

# TR/ES/ZH/HI minimal (you can extend later)
cat > app/src/main/res/values-tr/strings.xml <<'TR'
<resources>
  <string name="app_name">UnitraFlow</string>
  <string name="cat_length">Uzunluk</string>
  <string name="cat_mass">Kütle</string>
  <string name="cat_temperature">Sıcaklık</string>
  <string name="cat_volume">Hacim</string>
  <string name="menu_settings">Ayarlar</string>
  <string name="menu_other_apps">Diğer Uygulamalarımız</string>
  <string name="hint_value">Değer</string>
  <string name="hint_from_unit">Birim (Kaynak)</string>
  <string name="hint_to_unit">Birim (Hedef)</string>
  <string name="btn_swap">Değiştir</string>
  <string name="result">Sonuç</string>
  <string name="settings_title">Ayarlar</string>
  <string name="pref_ads">Reklam</string>
  <string name="pref_enable_ads">Reklamları aç</string>
  <string name="pref_banner_id">Banner Reklam ID</string>
  <string name="pref_interstitial_id">Geçiş Reklam ID</string>
  <string name="pref_interstitial_prob">Geçiş reklam olasılığı (0–100)</string>
  <string name="pref_theme">Tema</string>
  <string name="pref_language">Dil</string>
  <string name="theme_system">Sistem</string>
  <string name="theme_light">Açık</string>
  <string name="theme_dark">Koyu</string>
  <string name="other_apps_title">Diğer Uygulamalarımız</string>
  <string name="open_developer_page">Geliştirici sayfasını aç</string>
</resources>
TR

cat > app/src/main/res/values-es/strings.xml <<'ES'
<resources>
  <string name="app_name">UnitraFlow</string>
  <string name="cat_length">Longitud</string>
  <string name="cat_mass">Masa</string>
  <string name="cat_temperature">Temperatura</string>
  <string name="cat_volume">Volumen</string>
  <string name="menu_settings">Ajustes</string>
  <string name="menu_other_apps">Otras apps</string>
  <string name="hint_value">Valor</string>
  <string name="hint_from_unit">Unidad origen</string>
  <string name="hint_to_unit">Unidad destino</string>
  <string name="btn_swap">Cambiar</string>
  <string name="result">Resultado</string>
  <string name="settings_title">Ajustes</string>
  <string name="pref_ads">Anuncios</string>
  <string name="pref_enable_ads">Activar anuncios</string>
  <string name="pref_banner_id">Banner Ad Unit ID</string>
  <string name="pref_interstitial_id">Interstitial Ad Unit ID</string>
  <string name="pref_interstitial_prob">Probabilidad intersticial (0–100)</string>
  <string name="pref_theme">Tema</string>
  <string name="pref_language">Idioma</string>
  <string name="theme_system">Sistema</string>
  <string name="theme_light">Claro</string>
  <string name="theme_dark">Oscuro</string>
  <string name="other_apps_title">Otras apps</string>
  <string name="open_developer_page">Abrir página del desarrollador</string>
</resources>
ES

cat > app/src/main/res/values-zh-rCN/strings.xml <<'ZH'
<resources>
  <string name="app_name">UnitraFlow</string>
  <string name="cat_length">长度</string>
  <string name="cat_mass">质量</string>
  <string name="cat_temperature">温度</string>
  <string name="cat_volume">体积</string>
  <string name="menu_settings">设置</string>
  <string name="menu_other_apps">其他应用</string>
  <string name="hint_value">数值</string>
  <string name="hint_from_unit">原单位</string>
  <string name="hint_to_unit">目标单位</string>
  <string name="btn_swap">交换</string>
  <string name="result">结果</string>
  <string name="settings_title">设置</string>
  <string name="pref_ads">广告</string>
  <string name="pref_enable_ads">启用广告</string>
  <string name="pref_banner_id">Banner 广告位 ID</string>
  <string name="pref_interstitial_id">插屏广告位 ID</string>
  <string name="pref_interstitial_prob">插屏概率 (0–100)</string>
  <string name="pref_theme">主题</string>
  <string name="pref_language">语言</string>
  <string name="theme_system">跟随系统</string>
  <string name="theme_light">浅色</string>
  <string name="theme_dark">深色</string>
  <string name="other_apps_title">其他应用</string>
  <string name="open_developer_page">打开开发者页面</string>
</resources>
ZH

cat > app/src/main/res/values-hi/strings.xml <<'HI'
<resources>
  <string name="app_name">UnitraFlow</string>
  <string name="cat_length">लंबाई</string>
  <string name="cat_mass">द्रव्यमान</string>
  <string name="cat_temperature">तापमान</string>
  <string name="cat_volume">आयतन</string>
  <string name="menu_settings">सेटिंग्स</string>
  <string name="menu_other_apps">अन्य ऐप्स</string>
  <string name="hint_value">मान</string>
  <string name="hint_from_unit">स्रोत इकाई</string>
  <string name="hint_to_unit">लक्ष्य इकाई</string>
  <string name="btn_swap">बदलें</string>
  <string name="result">परिणाम</string>
  <string name="settings_title">सेटिंग्स</string>
  <string name="pref_ads">विज्ञापन</string>
  <string name="pref_enable_ads">विज्ञापन चालू करें</string>
  <string name="pref_banner_id">Banner Ad Unit ID</string>
  <string name="pref_interstitial_id">Interstitial Ad Unit ID</string>
  <string name="pref_interstitial_prob">Interstitial संभावना (0–100)</string>
  <string name="pref_theme">थीम</string>
  <string name="pref_language">भाषा</string>
  <string name="theme_system">सिस्टम</string>
  <string name="theme_light">लाइट</string>
  <string name="theme_dark">डार्क</string>
  <string name="other_apps_title">अन्य ऐप्स</string>
  <string name="open_developer_page">डेवलपर पेज खोलें</string>
</resources>
HI

cat > app/src/main/res/values/colors.xml <<'COL'
<resources>
  <color name="seed">#1A73E8</color>
</resources>
COL

cat > app/src/main/res/values/styles.xml <<'STY'
<resources>
  <style name="Theme.UnitraFlow" parent="Theme.MaterialComponents.DayNight.NoActionBar">
    <item name="colorPrimary">@color/seed</item>
    <item name="colorSecondary">@color/seed</item>
  </style>
</resources>
STY

cat > app/src/main/res/values-night/styles.xml <<'STYN'
<resources>
  <style name="Theme.UnitraFlow" parent="Theme.MaterialComponents.DayNight.NoActionBar">
    <item name="colorPrimary">@color/seed</item>
    <item name="colorSecondary">@color/seed</item>
  </style>
</resources>
STYN

cat > app/src/main/res/menu/menu_main.xml <<'MENU'
<menu xmlns:android="http://schemas.android.com/apk/res/android">
  <item
      android:id="@+id/action_settings"
      android:title="@string/menu_settings"
      android:showAsAction="never" />
  <item
      android:id="@+id/action_other_apps"
      android:title="@string/menu_other_apps"
      android:showAsAction="never" />
</menu>
MENU

cat > app/src/main/res/layout/activity_main.xml <<'MAINXML'
<?xml version="1.0" encoding="utf-8"?>
<androidx.coordinatorlayout.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

  <com.google.android.material.appbar.AppBarLayout
      android:layout_width="match_parent"
      android:layout_height="wrap_content">

    <com.google.android.material.appbar.MaterialToolbar
        android:id="@+id/toolbar"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:title="@string/app_name" />

    <com.google.android.material.tabs.TabLayout
        android:id="@+id/tabLayout"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />
  </com.google.android.material.appbar.AppBarLayout>

  <androidx.viewpager2.widget.ViewPager2
      android:id="@+id/viewPager"
      android:layout_width="match_parent"
      android:layout_height="match_parent"
      android:layout_marginBottom="64dp"
      app:layout_behavior="@string/appbar_scrolling_view_behavior" />

  <FrameLayout
      android:id="@+id/ad_container"
      android:layout_width="match_parent"
      android:layout_height="64dp"
      android:layout_gravity="bottom" />

</androidx.coordinatorlayout.widget.CoordinatorLayout>
MAINXML

cat > app/src/main/res/layout/fragment_unit_converter.xml <<'FRAGXML'
<?xml version="1.0" encoding="utf-8"?>
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

  <LinearLayout
      android:layout_width="match_parent"
      android:layout_height="wrap_content"
      android:padding="16dp"
      android:orientation="vertical">

    <com.google.android.material.textfield.TextInputLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="@string/hint_value">
      <com.google.android.material.textfield.TextInputEditText
          android:id="@+id/etValue"
          android:inputType="numberDecimal"
          android:layout_width="match_parent"
          android:layout_height="wrap_content" />
    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.textfield.TextInputLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="12dp"
        android:hint="@string/hint_from_unit">
      <AutoCompleteTextView
          android:id="@+id/acFrom"
          android:layout_width="match_parent"
          android:layout_height="wrap_content" />
    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.textfield.TextInputLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="12dp"
        android:hint="@string/hint_to_unit">
      <AutoCompleteTextView
          android:id="@+id/acTo"
          android:layout_width="match_parent"
          android:layout_height="wrap_content" />
    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.button.MaterialButton
        android:id="@+id/btnSwap"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="12dp"
        android:text="@string/btn_swap" />

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="16dp"
        android:text="@string/result" />

    <TextView
        android:id="@+id/tvResult"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="28sp"
        android:text="—"
        android:paddingTop="6dp" />

  </LinearLayout>
</ScrollView>
FRAGXML

cat > app/src/main/res/layout/activity_other_apps.xml <<'OTHERXML'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:padding="16dp"
    android:orientation="vertical">

  <TextView
      android:layout_width="match_parent"
      android:layout_height="wrap_content"
      android:text="@string/other_apps_title"
      android:textSize="20sp"
      android:paddingBottom="12dp"/>

  <com.google.android.material.button.MaterialButton
      android:id="@+id/btnOpenDev"
      android:layout_width="match_parent"
      android:layout_height="wrap_content"
      android:text="@string/open_developer_page"/>

  <FrameLayout
      android:id="@+id/ad_container"
      android:layout_width="match_parent"
      android:layout_height="64dp"
      android:layout_marginTop="16dp"/>

</LinearLayout>
OTHERXML

cat > app/src/main/res/xml/prefs.xml <<'PREFS'
<PreferenceScreen xmlns:android="http://schemas.android.com/apk/res/android">

  <PreferenceCategory android:title="@string/pref_theme">
    <ListPreference
        android:key="theme_mode"
        android:title="@string/pref_theme"
        android:defaultValue="system"
        android:entries="@array/theme_entries"
        android:entryValues="@array/theme_values" />

    <ListPreference
        android:key="lang"
        android:title="@string/pref_language"
        android:defaultValue="en"
        android:entries="@array/lang_entries"
        android:entryValues="@array/lang_values" />
  </PreferenceCategory>

  <PreferenceCategory android:title="@string/pref_ads">
    <SwitchPreferenceCompat
        android:key="ads_enabled"
        android:title="@string/pref_enable_ads"
        android:defaultValue="true" />

    <EditTextPreference
        android:key="banner_id"
        android:title="@string/pref_banner_id"
        android:defaultValue="@string/admob_banner_test" />

    <EditTextPreference
        android:key="interstitial_id"
        android:title="@string/pref_interstitial_id"
        android:defaultValue="@string/admob_interstitial_test" />

    <SeekBarPreference
        android:key="interstitial_prob"
        android:title="@string/pref_interstitial_prob"
        android:defaultValue="20"
        android:max="100" />
  </PreferenceCategory>

</PreferenceScreen>
PREFS

cat > app/src/main/res/values/arrays.xml <<'ARR'
<resources>
  <string-array name="theme_entries">
    <item>@string/theme_system</item>
    <item>@string/theme_light</item>
    <item>@string/theme_dark</item>
  </string-array>
  <string-array name="theme_values">
    <item>system</item>
    <item>light</item>
    <item>dark</item>
  </string-array>

  <string-array name="lang_entries">
    <item>English</item>
    <item>Türkçe</item>
    <item>Español</item>
    <item>中文(简体)</item>
    <item>हिन्दी</item>
  </string-array>
  <string-array name="lang_values">
    <item>en</item>
    <item>tr</item>
    <item>es</item>
    <item>zh-CN</item>
    <item>hi</item>
  </string-array>
</resources>
ARR

echo "==> Java code"
cat > app/src/main/java/com/mobilprogramlar/unitraflow/model/Category.java <<'CAT'
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
CAT

cat > app/src/main/java/com/mobilprogramlar/unitraflow/model/UnitDef.java <<'UNIT'
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
UNIT

cat > app/src/main/java/com/mobilprogramlar/unitraflow/convert/UnitConverter.java <<'CONV'
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
CONV

cat > app/src/main/java/com/mobilprogramlar/unitraflow/settings/AppSettings.java <<'SET'
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
SET

cat > app/src/main/java/com/mobilprogramlar/unitraflow/settings/SettingsActivity.java <<'SA'
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
SA

cat > app/src/main/java/com/mobilprogramlar/unitraflow/settings/SettingsFragment.java <<'SF'
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
SF

cat > app/src/main/java/com/mobilprogramlar/unitraflow/ads/AdDisplayController.java <<'ADS'
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
ADS

cat > app/src/main/java/com/mobilprogramlar/unitraflow/other/OtherAppsActivity.java <<'OA'
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
OA

cat > app/src/main/java/com/mobilprogramlar/unitraflow/ui/CategoryPagerAdapter.java <<'ADP'
package com.mobilprogramlar.unitraflow.ui;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.viewpager2.adapter.FragmentStateAdapter;

import com.mobilprogramlar.unitraflow.model.Category;

public class CategoryPagerAdapter extends FragmentStateAdapter {

  private final Category[] categories;

  public CategoryPagerAdapter(@NonNull FragmentActivity fa, Category[] categories) {
    super(fa);
    this.categories = categories;
  }

  @NonNull @Override public Fragment createFragment(int position) {
    return UnitConverterFragment.newInstance(categories[position].name());
  }

  @Override public int getItemCount() {
    return categories.length;
  }
}
ADP

cat > app/src/main/java/com/mobilprogramlar/unitraflow/ui/UnitConverterFragment.java <<'FRAG'
package com.mobilprogramlar.unitraflow.ui;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.mobilprogramlar.unitraflow.R;
import com.mobilprogramlar.unitraflow.convert.UnitConverter;
import com.mobilprogramlar.unitraflow.databinding.FragmentUnitConverterBinding;
import com.mobilprogramlar.unitraflow.model.Category;
import com.mobilprogramlar.unitraflow.model.UnitDef;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class UnitConverterFragment extends Fragment {

  private static final String ARG_CAT = "cat";

  private FragmentUnitConverterBinding b;
  private Category category;

  private List<UnitDef> units = new ArrayList<>();
  private UnitDef fromU;
  private UnitDef toU;

  public static UnitConverterFragment newInstance(String catName) {
    UnitConverterFragment f = new UnitConverterFragment();
    Bundle args = new Bundle();
    args.putString(ARG_CAT, catName);
    f.setArguments(args);
    return f;
  }

  @Nullable @Override public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    b = FragmentUnitConverterBinding.inflate(inflater, container, false);
    return b.getRoot();
  }

  @Override public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    String catName = getArguments() != null ? getArguments().getString(ARG_CAT, Category.LENGTH.name()) : Category.LENGTH.name();
    category = Category.valueOf(catName);

    units = UnitConverter.units(category);

    setupDropdown(b.acFrom, true);
    setupDropdown(b.acTo, false);

    b.btnSwap.setOnClickListener(v -> {
      UnitDef tmp = fromU;
      fromU = toU;
      toU = tmp;
      if (fromU != null) b.acFrom.setText(fromU.label, false);
      if (toU != null) b.acTo.setText(toU.label, false);
      compute();
    });

    b.etValue.addTextChangedListener(new SimpleTextWatcher(this::compute));
    compute();
  }

  private void setupDropdown(AutoCompleteTextView ac, boolean isFrom) {
    List<String> labels = new ArrayList<>();
    for (UnitDef u : units) labels.add(u.label);

    ArrayAdapter<String> adapter = new ArrayAdapter<>(requireContext(), android.R.layout.simple_list_item_1, labels);
    ac.setAdapter(adapter);

    // default selection
    if (!units.isEmpty()) {
      UnitDef def = units.get(0);
      if (isFrom) fromU = def; else toU = def;
      ac.setText(def.label, false);
    }
    if (units.size() > 1 && !isFrom) {
      toU = units.get(1);
      ac.setText(toU.label, false);
    }

    ac.setOnItemClickListener((parent, view, position, id) -> {
      UnitDef chosen = units.get(position);
      if (isFrom) fromU = chosen; else toU = chosen;
      compute();
    });
  }

  private void compute() {
    if (fromU == null || toU == null) return;

    String raw = b.etValue.getText() != null ? b.etValue.getText().toString().trim() : "";
    if (raw.isEmpty()) {
      b.tvResult.setText("—");
      return;
    }

    // support comma decimals
    raw = raw.replace(",", ".");
    double v;
    try {
      v = Double.parseDouble(raw);
    } catch (Exception e) {
      b.tvResult.setText("—");
      return;
    }

    double out = UnitConverter.convert(category, fromU.id, toU.id, v);
    if (Double.isNaN(out) || Double.isInfinite(out)) {
      b.tvResult.setText("—");
      return;
    }

    b.tvResult.setText(String.format(Locale.US, "%.6f", out).replaceAll("\\.?0+$", ""));
  }

  @Override public void onDestroyView() {
    super.onDestroyView();
    b = null;
  }

  private static class SimpleTextWatcher implements TextWatcher {
    private final Runnable r;
    SimpleTextWatcher(Runnable r) { this.r = r; }
    @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
    @Override public void onTextChanged(CharSequence s, int start, int before, int count) { r.run(); }
    @Override public void afterTextChanged(Editable s) {}
  }
}
FRAG

cat > app/src/main/java/com/mobilprogramlar/unitraflow/MainActivity.java <<'MAIN'
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
MAIN

echo "==> Update README"
cat > README.md <<'README'
# UnitraFlow

Modern unit converter (Java + Material + Dark/Light + multi-language + Ads settings).

## Open in Android Studio
- Download ZIP from GitHub: **Code → Download ZIP**
- Extract
- Android Studio → **Open** → select the folder
- Let Gradle sync finish, then Run ▶️

## Notes
- `applicationId`: `com.mobilprogramlar.unitraflow`
- AdMob uses TEST IDs by default.
README

echo "==> Gradle Wrapper (downloads Gradle and generates wrapper files)"
GRADLE_VERSION="8.2.2"
curl -L -o /tmp/gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
unzip -q /tmp/gradle.zip -d /tmp
/tmp/gradle-${GRADLE_VERSION}/bin/gradle wrapper --gradle-version "${GRADLE_VERSION}"

chmod +x gradlew || true

echo "==> Done. Run: git status"
