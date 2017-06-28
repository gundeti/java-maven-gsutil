FROM taivokasper/debian-maven3:latest


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
