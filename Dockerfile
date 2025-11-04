FROM eclipse-temurin:21
LABEL authors="juliodesarrollo"

# CREA UN DIRECTORIO TEMPORAL
VOLUME /tmp

# COPIA EL .JAR GENERADO
COPY build/libs/apiGatewayMicroservicio-0.0.1-SNAPSHOT.jar app.jar

# Establece un perfil predeterminado como dev
ARG PROFILE=dev
ENV SPRING_PROFILES_ACTIVE=$PROFILE

# MONTA EL ARCHIVO env.properties EN LA RAIZ DEL CONTENEDOR
VOLUME /env.properties

# establece el punto de entada con el perfil activo
ENTRYPOINT ["java", "-Duser.timezone=America/Bogota", "-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-Dspring.config.import=file:/env.properties", "-jar", "app.jar"]