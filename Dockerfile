FROM openjdk:8

RUN apt-get update && apt-get install lsb-release
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" &&\
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&\
    apt-get update && apt-get install -y google-cloud-sdk
    
    
ENV MAVEN_VERSION 3.3.3

# Install dev tools.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# install maven
RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# install git
RUN \
  add-apt-repository ppa:git-core/ppa -y && \
  apt-get update -y && \
  apt-get install git -y

# install javadoc
RUN \
  JAVADOC_PATH=$JAVA_HOME/bin/javadoc && \
  wget https://github.com/rest4hub/docker-oracle-java8-mvn-3.3.3/raw/master/javadoc -O $JAVADOC_PATH && \
  chmod +x $JAVADOC_PATH && \
  chown uucp:143 $JAVADOC_PATH && \
  update-alternatives --install "/usr/bin/javadoc" "javadoc" "${JAVADOC_PATH}" 1

ENV MAVEN_HOME /usr/share/maven

CMD ["bash"]    
