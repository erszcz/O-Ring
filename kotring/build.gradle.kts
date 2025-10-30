plugins {
    kotlin("multiplatform") version "2.2.21"
}

repositories {
    mavenCentral()
}

kotlin {
    macosArm64("native") {
        binaries {
            executable()
        }
    }

    sourceSets {
        val nativeMain by getting {
            dependencies {
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.0")
            }
        }
    }
}

tasks.withType<Wrapper> {
    gradleVersion = "8.14"
    distributionType = Wrapper.DistributionType.BIN
}
