# Use a base image with JDK installed
FROM openjdk:11-jdk

# Set the working directory
WORKDIR /app

# Copy the Gradle wrapper and project files
COPY gradlew /app/
COPY gradle /app/gradle/
COPY build.gradle /app/
COPY settings.gradle /app/
COPY src /app/src

# Make the Gradle wrapper executable
RUN chmod +x gradlew

# Build the project
RUN ./gradlew build

# Command to run the application (if needed)
CMD ["./gradlew", "run"]
