FROM eclipse-temurin:25-jre

WORKDIR /minecraft

COPY server/server.jar /server/server.jar

EXPOSE 25565