# Step 1: Build the project using Maven (with OpenJDK 17)
FROM maven:3.8.5-openjdk-17 AS build

# Copy the project files into the container
COPY . .

# Run Maven to clean, compile, and package the application, skipping tests
RUN mvn clean package -DskipTests

# Step 2: Prepare the runtime image with OpenJDK 17
FROM openjdk:17-slim

# Copy the generated JAR file (account for the renaming)
# If Maven renames it to myproject-0.0.1-SNAPSHOT.jar.original, use that name.
COPY --from=build /target/myproject-0.0.1-SNAPSHOT.jar.original /myproject.jar

# Expose port 8080 for the Spring Boot application
EXPOSE 8080

# Set the entrypoint to run the JAR file
ENTRYPOINT ["java", "-jar", "/myproject.jar"]
