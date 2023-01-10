FROM tomcat:9.0.70-jdk8-corretto-al2
COPY --from=build /app/target/react-and-spring-data-rest-0.0.1-SNAPSHOT*.jar/usr/local/tomcat/webapps/zion-web-app.jar 
