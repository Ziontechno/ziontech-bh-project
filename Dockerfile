FROM  tomcat:9.0.70-jdk8-corretto-al2
COPY target/node/node/usr/local/tomcat/webapps/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar

