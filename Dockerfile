FROM eclipse-temurin:25-jre

WORKDIR /minecraft

COPY server/server.jar /server/server.jar
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 25565

ENTRYPOINT ["/entrypoint.sh"]