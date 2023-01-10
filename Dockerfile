FROM tomcat:9.0.70-jdk8-corretto-al2
RUN mkdir /usr/local/tomcat/webapps/
COPY target/*.jar/usr/local/tomcat/webapps/zion-web-app.jar 
