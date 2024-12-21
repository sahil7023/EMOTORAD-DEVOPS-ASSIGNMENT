# Stage 1: Build the application
FROM openjdk:11-jdk-slim AS build

WORKDIR /app

COPY . .

RUN chmod +x mvnw

# Build the application
RUN ./mvnw clean install -DskipTests

# Stage 2: Run the application
FROM openjdk:11-jre-slim

WORKDIR /app

# Ensure the correct path to the JAR file
COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Health check
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

