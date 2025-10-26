# Use OpenJDK 21 base image
FROM eclipse-temurin:21-jdk-alpine

# Set working directory inside container
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Install Maven
RUN apk add --no-cache maven

# Build the app using Maven
RUN mvn clean package -DskipTests

# Copy the built jar to a clean image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the built jar from the builder image
COPY --from=0 /app/target/myapp-1.0-SNAPSHOT.jar app.jar

# Expose the port (optional)
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
