FROM tomcat:9.0.70-jdk8-corretto-al2
COPY target/*.war /usr/local/tomcat/webapps/zion-web-app.jar 
 
