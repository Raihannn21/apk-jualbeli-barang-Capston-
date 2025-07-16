plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.frontenddd"
    compileSdk = flutter.compileSdkVersion

    // ===================================================================
    // >> PERUBAHAN DILAKUKAN DI SINI <<
    // Mengganti flutter.ndkVersion dengan versi spesifik yang dibutuhkan.
    ndkVersion = "27.0.12077973"
    // ===================================================================

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.frontenddd"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Tambahkan blok dependensi jika belum ada
dependencies {
    // Dependensi default Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:${project.findProperty("kotlin.version")}")
}