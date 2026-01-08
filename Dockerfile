# ===== STAGE 1: BUILD =====
FROM gradle:8.5-jdk21 AS builder
WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts settings.gradle.kts ./
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon

COPY . .
ARG APP_VERSION
RUN APP_VERSION=${APP_VERSION} ./gradlew clean bootJar --no-daemon


# ===== STAGE 2: RUNTIME =====
FROM eclipse-temurin:21-jre
WORKDIR /app

ARG APP_VERSION
COPY --from=builder /app/build/libs/apiGatewayMicroservicio-${APP_VERSION}.jar app.jar

ENV SPRING_PROFILES_ACTIVE=dev

ENTRYPOINT ["java", "-Duser.timezone=America/Bogota", "-jar", "app.jar"]
