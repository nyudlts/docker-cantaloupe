FROM redhat-openjdk-18/openjdk18-openshift:latest

ENV CANTALOUPE_VERSION=4.0.3

EXPOSE 8182

USER root

# Update packages and install tools
RUN yum install -y wget unzip curl

# Run non privileged
RUN adduser --system cantaloupe

WORKDIR /tmp

# Get and unpack Cantaloupe release archive
RUN curl -OL https://github.com/medusa-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/Cantaloupe-$CANTALOUPE_VERSION.zip \
 && cd /opt \
 && unzip /tmp/Cantaloupe-$CANTALOUPE_VERSION.zip \
 && ln -s cantaloupe-$CANTALOUPE_VERSION cantaloupe \
 && rm -rf /tmp/Cantaloupe-$CANTALOUPE_VERSION \
 && rm /tmp/Cantaloupe-$CANTALOUPE_VERSION.zip

COPY cantaloupe.properties /etc/cantaloupe.properties
RUN mkdir -p /var/log/cantaloupe /var/cache/cantaloupe \
 && touch /etc/cantaloupe.properties \
 && chown -R cantaloupe /var/log/cantaloupe /var/cache/cantaloupe /etc/cantaloupe.properties \
 && cp /opt/cantaloupe/deps/Linux-x86-64/lib/* /usr/lib/


USER cantaloupe
CMD ["sh", "-c", "java -Dcantaloupe.config=/etc/cantaloupe.properties -Xmx2g -jar /opt/cantaloupe/cantaloupe-$CANTALOUPE_VERSION.war"]
