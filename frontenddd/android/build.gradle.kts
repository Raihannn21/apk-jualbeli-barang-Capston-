allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// The following lines are used to customize the build directory location.
val newBuildDir: org.gradle.api.file.Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: org.gradle.api.file.Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// KODE YANG DIPERBAIKI: Menggunakan pendekatan yang lebih modern dan type-safe
// untuk menghindari error "Type mismatch" dan "Unresolved reference".
subprojects {
    plugins.withType<com.android.build.gradle.LibraryPlugin> {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            if (namespace == null) {
                // 'project' is available in this context
                namespace = "com.example.${project.name}"
            }
        }
    }
}