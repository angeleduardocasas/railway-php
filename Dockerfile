FROM node:18-alpine

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install --omit=dev

# Copiar el código de la aplicación
COPY . .

# Crear directorio para vistas si no existe
RUN mkdir -p views

# Exponer el puerto
EXPOSE 3000

# Iniciar la aplicación
CMD ["node", "server.js"]