-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

-keep class * extends androidx.work.ListenableWorker { <init>(...); }

-dontwarn com.google.android.play.core.**
