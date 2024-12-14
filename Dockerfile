FROM tomcat:9.0
COPY target/demo-app.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
