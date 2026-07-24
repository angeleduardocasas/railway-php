FROM node:18-alpine

# Crear directorio de trabajo
WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm ci --only=production

# Copiar el código
COPY . .

# Crear directorio para vistas
RUN mkdir -p views

# Exponer puerto
EXPOSE 3000

# Comando de inicio
CMD ["npm", "start"]