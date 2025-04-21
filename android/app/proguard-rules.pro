# Mapbox rules
-keep class com.mapbox.api.directions.v5.** { *; }
-keep class com.mapbox.geojson.** { *; }

# AutoValue Gson rules
-keep class com.ryanharter.auto.value.gson.** { *; }
-keep class com.ryanharter.auto.value.gson.GsonTypeAdapterFactory*
-keep class **$$AutoValue_* { *; }

# Retrofit (nếu dùng)
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.mapbox.api.directions.v5.AutoValue_MapboxDirections$1
-dontwarn com.ryanharter.auto.value.gson.GsonTypeAdapterFactory