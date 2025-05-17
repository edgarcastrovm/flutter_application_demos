plugins {

    // Asegúrate de que los plugins existentes (como los de Android/Kotlin) estén aquí.

    // Por ejemplo:

    // id("com.android.application") version "8.0.0" apply false

    // id("org.jetbrains.kotlin.android") version "1.8.20" apply false


    // ¡Añade esta línea para declarar el plugin google-services!

    id("com.google.gms.google-services") version "4.3.15" apply false // <-- Añade esto. ¡Verifica la versión!

}
// 

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
