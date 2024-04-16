# Ubuntu based container with Java and Tomcat
FROM ubuntu:latest
LABEL maintainer="devopsdump/chandrika"

# Install required dependencies
RUN apt-get update && \
    apt-get install -y wget tar sudo curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Install OpenJDK 11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Maven
ARG MAVEN_VERSION=3.6.3
ENV MAVEN_HOME /usr/share/maven
ENV PATH $MAVEN_HOME/bin:$PATH
VOLUME /root/.m2
RUN mkdir -p $MAVEN_HOME \
    && curl -fsSL "https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz" \
    | tar -xzC $MAVEN_HOME --strip-components=1 \
    && ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn
    
# Set up Tomcat
ARG TOMCAT_MAJOR_VERSION=9
ARG TOMCAT_MINOR_VERSION=9.0.87
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME
RUN curl -OL "https://dlcdn.apache.org/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_MINOR_VERSION/bin/apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz" \
    && tar -zxf "apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz" \
    && mv "apache-tomcat-$TOMCAT_MINOR_VERSION"/* . \
    && rm "apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz"
    
# Create a user and group for Tomcat
RUN groupadd -r tomcat && \
    useradd -r -g tomcat -d $CATALINA_HOME -s /bin/false tomcat && \
    chown -R tomcat:tomcat $CATALINA_HOME
    
# Add Tomcat admin user and configure permissions
#RUN mv tomcat-users.xml chmod +x /opt/tomcat/conf/tomcat-users.xml

# Add Tomcat manager app configuration
#ADD tomcat-users.xml $CATALINA_HOME/conf/
COPY tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
COPY context.xml /opt/tomcat/webapps/manager/META-INF/context.xml


# Download the war file
WORKDIR $CATALINA_HOME/webapps
RUN curl -O -L https://github.com/devopsdump/warfile_Tomcat_Deploy_Docker/raw/main/Lab6A.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
