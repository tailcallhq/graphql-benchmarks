ThisBuild / scalaVersion     := "3.5.0"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

lazy val root = (project in file("."))
  .settings(
    name       := "scala-caliban",
    run / fork := true,
    run / javaOptions ++= Seq("-Xms4G", "-Xmx4G"),
    libraryDependencies ++= Seq(
      "com.github.ghostdogpr"                 %% "caliban-quick"         % "2.8.1",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-core"   % "2.30.8",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-macros" % "2.30.8" % Provided,
      "org.apache.httpcomponents.client5"      % "httpclient5"           % "5.3.1",
      "dev.zio"                               %% "zio"                   % "2.1.8"
    )
  )

resolvers ++= Resolver.sonatypeOssRepos("snapshots")
