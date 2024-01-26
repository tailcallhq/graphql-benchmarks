ThisBuild / scalaVersion     := "3.3.1"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

lazy val root = (project in file("."))
  .settings(
    name       := "scala-caliban",
    run / fork := true,
    run / javaOptions ++= Seq("-Xms4G", "-Xmx4G"),
    libraryDependencies ++= Seq(
      "com.github.ghostdogpr"                 %% "caliban-quick"         % "2.5.1",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-core"   % "2.27.7",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-macros" % "2.27.6" % Provided,
      "org.apache.httpcomponents.client5"      % "httpclient5"           % "5.3.1"
    )
  )

resolvers ++= Resolver.sonatypeOssRepos("snapshots")
