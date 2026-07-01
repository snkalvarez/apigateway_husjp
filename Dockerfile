FROM gradle:8.7-jdk21-jammy AS builder
WORKDIR /app

# 1. Copiar primero el envoltorio de Gradle correctamente
COPY gradle/ gradle/
COPY gradlew ./
COPY gradlew.bat ./

# 2. Corregir posibles saltos de línea de Windows (CRLF) a Linux (LF)
RUN sed -i 's/\r$//' gradlew

# 3. Dar permisos de ejecución inmediatamente
RUN chmod +x gradlew

# 4. Copiar configuraciones y descargar dependencias
COPY build.gradle.kts settings.gradle.kts ./
RUN ./gradlew dependencies --no-daemon || true

# 5. Copiar código fuente y compilar
COPY src ./src
ARG APP_VERSION=0.0.0-LOCAL
RUN ./gradlew clean bootJar -Pversion=$APP_VERSION --no-daemon

# =========================

FROM eclipse-temurin:21-jre-jammy
LABEL authors="juliodesarrollo"

WORKDIR /app

RUN useradd -ms /bin/bash appuser

COPY --from=builder /app/build/libs/*.jar app.jar

RUN chown appuser:appuser app.jar

VOLUME /tmp

ARG PROFILE=dev
ENV SPRING_PROFILES_ACTIVE=$PROFILE

USER appuser

ENTRYPOINT ["java", "-Duser.timezone=America/Bogota", "-jar", "app.jar"]