# Use an appropriate base image
FROM openjdk:8-jdk

# Set environment variables
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Install required packages
RUN apt-get update && apt-get install -y wget unzip

# Download and install Android SDK
RUN mkdir -p ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip -O /tmp/sdk-tools.zip && \
    unzip -q /tmp/sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/sdk-tools.zip

# Install SDK components
RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} --update && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-29" "build-tools;29.0.3" "emulator" "tools" && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses

# Install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-6.8.3-bin.zip -O /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    ln -s /opt/gradle-6.8.3/bin/gradle /usr/bin/gradle && \
    rm /tmp/gradle.zip

# Set the working directory
WORKDIR /workspace

# Copy the project files
COPY . .

# Set execute permissions for gradlew
RUN chmod +x gradlew

# Copy the google-services.json file (you should mount this file during Docker run or use Docker secrets)
COPY google-services.json app/google-services.json

# Run the build process
RUN ./gradlew clean assembleRelease

# Define the entry point
CMD ["./gradlew", "clean", "assembleRelease"]
