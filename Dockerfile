FROM maven
WORKDIR /app
RUN mkdir -p /app
COPY app/target/my-app-war.jar /app
CMD java -jar /app/my-app-1.0-SNAPSHOT.jar
