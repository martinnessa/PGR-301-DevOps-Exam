FROM maven:3.9.9-amazoncorretto-17-alpine as AppBuilder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package

FROM amazoncorretto:17.0.13-al2023-headless
COPY --from=AppBuilder /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]