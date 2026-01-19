buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Use a modern AGP version compatible with Flutter 3+
        classpath("com.android.tools.build:gradle:8.2.2")
        // Kotlin plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10")
    }
}

plugins {
    // No plugins here; app-level plugins are applied in app/build.gradle.kts
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Change build directories (optional, you already had this)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
