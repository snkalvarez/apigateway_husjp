FROM eclipse-temurin:21
LABEL authors="juliodesarrollo"

# Recibe la versión desde GitHub Actions (por defecto usa la local si compilas a mano)
ARG APP_VERSION=0.0.0-LOCAL

# CREA UN DIRECTORIO TEMPORAL
VOLUME /tmp

# COPIA EL .JAR GENERADO USANDO LA VARIABLE DE VERSIÓN
COPY build/libs/apiGatewayMicroservicio-${APP_VERSION}.jar app.jar

# Establece un perfil predeterminado como dev
ARG PROFILE=dev
ENV SPRING_PROFILES_ACTIVE=$PROFILE

# MONTA EL ARCHIVO env.properties EN LA RAIZ DEL CONTENEDOR
VOLUME /env.properties

# establece el punto de entada con el perfil activo
ENTRYPOINT ["java", "-Duser.timezone=America/Bogota", "-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-Dspring.config.import=file:/env.properties", "-jar", "app.jar"]
