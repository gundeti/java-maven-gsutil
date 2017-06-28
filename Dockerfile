FROM taivokasper/debian-maven3:latest


RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip \
    && unzip google-cloud-sdk.zip \
    && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options

VOLUME ["/root/.config"]
ENV PATH /google-cloud-sdk/bin:$PATH

RUN yes | gcloud components update
RUN yes | gcloud components update preview
VOLUME ["/files"]

ENTRYPOINT ["/google-cloud-sdk/bin/gcloud"]
