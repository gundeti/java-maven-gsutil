FROM openjdk:8-jdk

# installing maven
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

VOLUME "$USER_HOME_DIR/.m2"

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
# End of mvn installation


# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get -y install \
    wget \
    python \
    # for crcmod installation
    gcc python-dev python-setuptools

RUN easy_install -U pip && \
    pip install -U crcmod

RUN cd /root && \
    wget --no-verbose "https://storage.googleapis.com/pub/gsutil.tar.gz" && \
    tar -xf gsutil.tar.gz

RUN DEBIAN_FRONTEND=noninteractive; \
    apt-get -y purge wget gcc python-dev python-setuptools

ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/gsutil"
