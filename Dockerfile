FROM rest4hub/oracle-java-mvn

RUN sudo apt-get update && sudo apt-get -y install apt-transport-https && \ 
	export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
	echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
	sudo apt-get update && \
	sudo apt-get -y install google-cloud-sdk

