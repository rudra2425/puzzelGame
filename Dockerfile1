# Use an appropriate base image with OpenJDK
FROM openjdk:11-jdk-slim

# Install necessary packages and dependencies
RUN apt-get update && \
    apt-get install -y wget unzip

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Download and install the Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O tools.zip && \
    unzip tools.zip -d latest && \
    rm tools.zip

# Move the tools to the correct directory and set up PATH
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/latest/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ && \
    rm -rf ${ANDROID_SDK_ROOT}/cmdline-tools/latest/cmdline-tools

# Install Android SDK packages
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-29" "build-tools;29.0.2"

# Copy your project files into the container
COPY . /app

# Set the working directory
WORKDIR /app

# Set executable permissions for gradlew
RUN chmod +x gradlew

# Build the project
RUN ./gradlew clean assembleRelease

# Specify the command to run your application (if applicable)
CMD ["./gradlew", "assembleDebug"]

# Optional: Expose port if your app runs a server or needs to be accessed externally
EXPOSE 8080
