# ubuntu based container with Java and Tomcat
From ubuntu:latest
Maintainer devopsdump/chandrika

# Install prepare infrastructure
RUN apt-get -y update && \
 apt-get -y install wget && \
 apt-get -y install tar && \
 apt-get -y install sudo

#Tomcat
RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
ADD apache-tomcat-9.0.87.tar.gz /opt/tomcat
#RUN tar xvfz apache*.tar.gz
RUN mv  apache-tomcat-9.0.87/* /opt/tomcat/.
RUN yum -y install java
RUN java -version
#RUN echo "JAVA_HOME=/opt/java-1.8.0-openjdk/" >> /etc/default/tomcat8
#RUN groupadd tomcat
#RUN useradd -s /bin/bash -g tomcat tomcat
#RUN chown -Rf tomcat.tomcat /opt/tomcat/tomcat9



WORKDIR /opt/tomcat/webapps
RUN curl -O -L https://github.com/beardbytes/JavaCRUDRestWS/tree/master/dist/MyWebsite.war

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]



 

