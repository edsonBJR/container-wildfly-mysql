# Use latest jboss/base-jdk:8 image as the base
FROM jboss/base-jdk:8

# Set the WILDFLY_VERSION env variable 
ENV WILDFLY_VERSION 16.0.0.Final 
ENV WILDFLY_SHA1 b2039cc4979c7e50a0b6ee0e5153d13d537d492f
ENV JBOSS_HOME /opt/programas/server/wildfly-16.0.0.Final
ENV JBOSS_HOME_PARENT /opt/programas/server

USER root

# Add the WildFly distribution to /usr, and make wildfly the owner of the extracted tar content 
# Make sure the distribution is available from a well-known place 
# RUN cd $HOME \
#     && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
#     && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
#     && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
#     && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
#     && rm wildfly-$WILDFLY_VERSION.tar.gz \
#     && chown -R jboss:0 ${JBOSS_HOME} \
#     && chmod -R g+rw ${JBOSS_HOME}

RUN cd $HOME
RUN curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz
# RUN sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1
RUN cd $HOME
RUN tar xf wildfly-$WILDFLY_VERSION.tar.gz
RUN mkdir -p $JBOSS_HOME_PARENT

# RUN mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME - this did not work... it always extracted in /opt/jboss instead of /root
RUN mv /opt/programas/jboss/wildfly-$WILDFLY_VERSION $JBOSS_HOME_PARENT

RUN rm wildfly-$WILDFLY_VERSION.tar.gz
RUN chown -R jboss:0 ${JBOSS_HOME}
RUN chmod -R g+rw ${JBOSS_HOME}
    
    
# Ensure signals are forwarded to the JVM process correctly for graceful shutdown 
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/programas/server/wildfly-16.0.0.Final/bin/standalone.sh", "-b", "0.0.0.0"]
