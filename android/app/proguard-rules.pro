# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Google Mobile Ads ProGuard rules
-keep class com.google.android.gms.ads.** {
   public *;
}

# Keep AdMob classes
-keep class com.google.android.gms.ads.AdRequest {
   public *;
}

-keep class com.google.android.gms.ads.AdSize {
   public *;
}

-keep class com.google.android.gms.ads.AdView {
   public *;
}

-keep class com.google.android.gms.ads.MobileAds {
   public *;
}

-keep class com.google.android.gms.ads.rewarded.RewardedAd {
   public *;
}

-keep class com.google.android.gms.ads.rewarded.RewardedAdLoadCallback {
   public *;
}

-keep class com.google.android.gms.ads.rewarded.OnUserEarnedRewardListener {
   public *;
}

-keep class com.google.android.gms.ads.FullScreenContentCallback {
   public *;
}

# Keep Flutter specific classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
