# Conteneder con node que ejecuta el script server.js
FROM node:6.14.2
EXPOSE 8080
COPY server.js .
CMD [ "node", "server.js" ]
