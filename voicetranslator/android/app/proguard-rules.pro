# Flutter specific rules
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Google Play Services & ML
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# TTS (TextToSpeech) - native Android
-keep class android.speech.tts.TextToSpeech { *; }
-keep class android.speech.tts.TextToSpeech$* { *; }

# STT (SpeechRecognizer) - native Android
-keep class android.speech.SpeechRecognizer { *; }
-keep class android.speech.SpeechRecognizer$* { *; }

# Kotlin (if you use any Kotlin code/plugins)
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.*

# JSON (for Translator API responses, if using any JSON parsing lib like Gson)
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Reflection safe
-keepnames class * {
    @androidx.annotation.Keep *;
}
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}