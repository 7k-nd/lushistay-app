plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

fun releaseKeystoreFile(): java.io.File? {
    if (!keystorePropertiesFile.exists()) return null
    val path = keystoreProperties.getProperty("storeFile") ?: return null
    if (path.isBlank()) return null
    val store = file(path)
    return if (store.isFile) store else null
}

fun requireReleaseKeystore() {
    if (!keystorePropertiesFile.exists()) {
        throw GradleException(
            "Release signing blocked: missing android/key.properties. " +
                "Copy android/key.properties.example and create a keystore."
        )
    }
    val required = listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
    val missing = required.filter { keystoreProperties.getProperty(it).isNullOrBlank() }
    if (missing.isNotEmpty()) {
        throw GradleException(
            "Release signing blocked: incomplete android/key.properties " +
                "(missing: ${missing.joinToString()})."
        )
    }
    val store = releaseKeystoreFile()
        ?: throw GradleException(
            "Release signing blocked: keystore file not found " +
                "(${keystoreProperties.getProperty("storeFile")}). " +
                "See android/key.properties.example."
        )
    logger.lifecycle("Using release keystore: ${store.absolutePath}")
}

android {
    namespace = "app.immotrust.client"
    // Play (dès 31 août 2026) : nouvelles apps / updates → API 36+.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "app.immotrust.client"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (releaseKeystoreFile() != null) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = releaseKeystoreFile()
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Never fall back to debug signing.
            val releaseStore = releaseKeystoreFile()
            if (releaseStore != null) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

// Fail fast on release packaging if the upload keystore is missing.
afterEvaluate {
    tasks.matching { task ->
        val n = task.name
        n == "assembleRelease" ||
            n == "bundleRelease" ||
            n == "assembleReleaseUnitTest" ||
            n.startsWith("signRelease") ||
            n.startsWith("packageRelease")
    }.configureEach {
        doFirst { requireReleaseKeystore() }
    }
}

flutter {
    source = "../.."
}
