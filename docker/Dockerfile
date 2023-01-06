FROM openjdk:8-jre
#COPY application.yml application.yml
#COPY application-dev.yml application-dev.yml
#COPY application-test.yml application-test.yml
#COPY application-prod.yml application-prod.yml
COPY app.jar app.jar
COPY cacerts /usr/local/openjdk-8/lib/security/cacerts 
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","app.jar","--spring.config.location=file:/config/application.yml,/config/application-prod.yml"]
