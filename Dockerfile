# ubuntu based container with Java and Tomcat
From ubuntu:latest
Maintainer devopsdump/chandrika

# Install prepare infrastructure
RUN groupadd tomcat && \
 apt-get -y update && \
 apt-get -y install wget && \
 apt-get -y install tar && \
 apt-get -y install sudo && \
 apt-get -y install curl 
 
#Tomcat
RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.87/bin/apache-tomcat-9.0.87.tar.gz /opt/tomcat
RUN tar xvfz apache*.tar.gz
RUN mv apache-tomcat-9.0.87/* /opt/tomcat/.
RUN apt-get install openjdk-11-jdk -y
RUN java --version

# Set environment variables for Tomcat
ENV CATALINA_HOME /usr/share/tomcat
ENV CATALINA_BASE /var/lib/tomcat

# Create a user and group for Tomcat
RUN useradd -r -m -U -d $CATALINA_HOME -s /bin/false -g tomcat tomcat && \
    chown -R tomcat:tomcat /usr/share/tomcat && \
    chown -R tomcat:tomcat /var/lib/tomcat

# Create a user for Tomcat (optional but recommended for security)
RUN chgrp -R tomcat /var/lib/tomcat && \
    chmod -R g+r /var/lib/tomcat/conf && \
    chmod g+x /var/lib/tomcat/conf && \
    chown -R tomcat /var/lib/tomcat/webapps/ /var/lib/tomcat/logs/ /var/lib/tomcat/temp/ /var/lib/tomcat/work/

    # Add manager app configuration
   ADD tomcat-users.xml /opt/tomcat/conf/

#RUN echo "JAVA_HOME=/opt/java-1.8.0-openjdk/" >> /etc/default/tomcat8
#RUN groupadd tomcat
#RUN useradd -s /bin/bash -g tomcat tomcat
#RUN chown -Rf tomcat.tomcat /opt/tomcat/tomcat9

WORKDIR /opt/tomcat/webapps
RUN curl -O -L https://github.com/devopsdump/warfile_Tomcat_Deploy_Docker/blob/main/Lab6A.war

# Managerapp configuration



EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
