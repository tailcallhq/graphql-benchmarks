ThisBuild / scalaVersion     := "3.3.1"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

lazy val root = (project in file("."))
  .settings(
    name := "scala-caliban",
    libraryDependencies ++= Seq(
      "dev.zio"                               %% "zio-http"              % "3.0.0-RC3",
      "com.github.ghostdogpr"                 %% "caliban"               % "2.4.3",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-core"   % "2.24.4",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-macros" % "2.24.4" % Provided
    )
  )
