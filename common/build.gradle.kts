import org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget

plugins {
    id("com.android.library")
    kotlin("multiplatform")
    id("kotlinx-serialization")
    id("com.squareup.sqldelight")
}

android {
    compileSdkVersion(ProjectVersions.COMPILE_SDK)
    defaultConfig {
        minSdkVersion(ProjectVersions.MIN_SDK)
        targetSdkVersion(ProjectVersions.TARGET_SDK)
        versionCode = "git rev-list --first-parent --count HEAD".execute().text.trim().toInt()
        versionName = "git describe --tag".execute().text.trim()
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    packagingOptions {
        exclude("META-INF/kotlinx-coroutines-core.kotlin_module")
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/androidMain/kotlin")
            res.srcDirs("src/androidMain/res")
            manifest.srcFile("src/androidMain/AndroidManifest.xml")
        }
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        kotlinOptions.jvmTarget = "1.8"
    }
}

sqldelight {
    database("CuHackingDatabase") {
        packageName = "com.cuhacking.app.data.db"
    }
}

kotlin {
    // Select iOS target platform depending on the Xcode environment variables
    val iOSTarget: (String, KotlinNativeTarget.() -> Unit) -> KotlinNativeTarget =
        if (System.getenv("SDK_NAME")?.startsWith("iphoneos") == true)
            ::iosArm64
        else
            ::iosX64

    iOSTarget("ios") {
        binaries {
            framework {
                baseName = "common"
            }
        }
    }

    android("android")

    sourceSets["commonMain"].dependencies {
        implementation("org.jetbrains.kotlin:kotlin-stdlib-common")
        implementation("com.soywiz.korlibs.klock:klock:1.8.6")
        implementation("org.kodein.di:kodein-di-erased:6.5.1")
        implementation("io.ktor:ktor-client-core:${ProjectVersions.KTOR}")
        implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime-common:${ProjectVersions.SERIALIZATION}")
    }

    sourceSets["androidMain"].dependencies {
        implementation("org.jetbrains.kotlin:kotlin-stdlib")
        implementation("com.squareup.sqldelight:android-driver:${ProjectVersions.SQLDELIGHT}")
        implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime:${ProjectVersions.SERIALIZATION}")
        implementation("io.ktor:ktor-client-android:${ProjectVersions.KTOR}")
    }

    sourceSets["iosMain"].dependencies {
        implementation("com.squareup.sqldelight:ios-driver:${ProjectVersions.SQLDELIGHT}")
        implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime-native:${ProjectVersions.SERIALIZATION}")
        implementation("io.ktor:ktor-client-ios:${ProjectVersions.KTOR}")
    }
}

val packForXcode by tasks.creating(Sync::class) {
    val targetDir = File(buildDir, "xcode-frameworks")

    // Selecting the right configuration for the iOS
    // framework depending on the environment variables set by Xcode build
    val mode = System.getenv("CONFIGURATION") ?: "DEBUG"
    val framework = kotlin.targets
        .getByName<KotlinNativeTarget>("ios")
        .binaries.getFramework(mode)
    inputs.property("mode", mode)
    dependsOn(framework.linkTask)

    from({ framework.outputDirectory })
    into(targetDir)

    // Generate a helpful ./gradlew wrapper with embedded Java path
    doLast {
        val gradlew = File(targetDir, "gradlew")
        gradlew.writeText(
            "#!/bin/bash\n"
                    + "export 'JAVA_HOME=${System.getProperty("java.home")}'\n"
                    + "cd '${rootProject.rootDir}'\n"
                    + "./gradlew \$@\n"
        )
        gradlew.setExecutable(true)
    }
}

tasks.getByName("build").dependsOn(packForXcode)