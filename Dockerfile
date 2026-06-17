FROM eclipse-temurin:21
LABEL authors="juliodesarrollo"

# Recibe la versión desde GitHub Actions
ARG APP_VERSION=0.0.0-LOCAL

# CREA UN DIRECTORIO TEMPORAL (Opcional, útil para Tomcat/Spring)
VOLUME /tmp

# COPIA EL .JAR GENERADO USANDO LA VARIABLE DE VERSIÓN
COPY build/libs/apiGatewayMicroservicio-${APP_VERSION}.jar app.jar

# Establece un perfil predeterminado como dev (Kubernetes lo puede sobrescribir)
ARG PROFILE=dev
ENV SPRING_PROFILES_ACTIVE=$PROFILE

# El punto de entrada ahora es limpio y estándar
ENTRYPOINT ["java", "-Duser.timezone=America/Bogota", "-jar", "app.jar"]
