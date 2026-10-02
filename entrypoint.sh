#!/bin/sh

MEMORY="${MEMORY:-2G}"
SERVER_PORT="${SERVER_PORT:-25565}"

if [ "${EULA}" != "true" ]; then
    echo "ERROR: You must accept the Minecraft EULA."
    echo "Set EULA=true in the .env file."
    exit 1
fi

if [ ! -f /minecraft/server.properties ]; then
    cat > /minecraft/server.properties <<EOF
server-port=${SERVER_PORT}
max-players=${MAX_PLAYERS:-10}
white-list=${WHITE_LIST:-false}
difficulty=${DIFFICULTY:-normal}
gamemode=${GAMEMODE:-survival}
motd=${MOTD:-Minecraft Server}
EOF
fi

if [ ! -f /minecraft/eula.txt ]; then
    printf 'eula=true\n' > /minecraft/eula.txt
fi

exec java \
    -Xmx"${MEMORY}" \
    -Xms"${MEMORY}" \
    -jar /server/server.jar \
    nogui