# Use an appropriate base image with OpenJDK
FROM openjdk:11-jdk-slim

# Install necessary packages and dependencies
RUN apt-get update && \
    apt-get install -y wget unzip

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin

# Download and install the Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    cd ${ANDROID_SDK_ROOT} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O tools.zip && \
    unzip tools.zip && \
    rm tools.zip && \
    mv cmdline-tools latest

# Install Android SDK packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-29" "build-tools;29.0.2"

# Copy your project files into the container
COPY . /app

# Set the working directory
WORKDIR /app

# Set executable permissions for gradlew
RUN chmod +x gradlew

# Build the project
RUN ./gradlew assembleDebug

# Specify the command to run your application (if applicable)
CMD ["./gradlew", "assembleDebug"]

# Optional: Expose port if your app runs a server or needs to be accessed externally
EXPOSE 8080
