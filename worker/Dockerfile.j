FROM maven:3.5-jdk-8-alpine AS build

WORKDIR /code

# Copy source code
COPY pom.xml /code/pom.xml
COPY src/main /code/src/main

# Compile it
RUN ["mvn", "package"]

RUN cp /code/target/worker-jar-with-dependencies.jar /

CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "/worker-jar-with-dependencies.jar"]
