ThisBuild / scalaVersion     := "3.6.3"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

lazy val root = (project in file("."))
  .settings(
    name       := "scala-caliban",
    run / fork := true,
    run / javaOptions ++= Seq("-Xms4G", "-Xmx4G"),
    assembly / mainClass := Some("Main"),
    assembly / assemblyMergeStrategy := {
      case PathList("META-INF", "MANIFEST.MF")                  => MergeStrategy.discard
      case PathList("META-INF", "io.netty.versions.properties") => MergeStrategy.first
      case x                                                    => MergeStrategy.first
    },
    libraryDependencies ++= Seq(
      "com.github.ghostdogpr"                 %% "caliban-quick"         % "2.9.1",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-core"   % "2.33.1",
      "com.github.plokhotnyuk.jsoniter-scala" %% "jsoniter-scala-macros" % "2.33.1" % Provided,
      "org.apache.httpcomponents.client5"      % "httpclient5"           % "5.4.1",
      "dev.zio"                               %% "zio"                   % "2.1.14"
    )
  )

resolvers ++= Resolver.sonatypeOssRepos("snapshots")
