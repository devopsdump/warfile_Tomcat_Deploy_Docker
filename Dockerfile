# Ubuntu based container with Java and Tomcat
FROM ubuntu:latest
LABEL maintainer="devopsdump/chandrika"

# Install required dependencies
RUN apt-get update && \
    apt-get install -y wget tar sudo curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Tomcat
ENV TOMCAT_VERSION 9.0.87
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Download and extract Tomcat
RUN mkdir -p $CATALINA_HOME && \
    wget -q https://dlcdn.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -O /tmp/tomcat.tar.gz && \
    tar xfz /tmp/tomcat.tar.gz -C $CATALINA_HOME --strip-components=1 && \
    rm /tmp/tomcat.tar.gz

# Install OpenJDK 11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user and group for Tomcat
RUN groupadd -r tomcat && \
    useradd -r -g tomcat -d $CATALINA_HOME -s /bin/false tomcat && \
    chown -R tomcat:tomcat $CATALINA_HOME

# Add Tomcat manager app configuration
#ADD tomcat-users.xml $CATALINA_HOME/conf/
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml


# Download the war file
WORKDIR $CATALINA_HOME/webapps
RUN curl -O -L https://github.com/devopsdump/warfile_Tomcat_Deploy_Docker/raw/main/Lab6A.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
