FROM eclipse-temurin:21
LABEL authors="juliodesarrollo"

# CREA UN DIRECTORIO TEMPORAL
VOLUME /tmp

# ===== VERSIONADO =====
ARG APP_VERSION
ENV APP_VERSION=${APP_VERSION}

# COPIA EL .JAR VERSIONADO
COPY build/libs/apiGatewayMicroservicio-${APP_VERSION}.jar app.jar

# PERFIL SPRING
ARG PROFILE=dev
ENV SPRING_PROFILES_ACTIVE=${PROFILE}

# ENTRYPOINT
ENTRYPOINT exec java \
             -Duser.timezone=America/Bogota \
             -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE \
             -jar app.jar