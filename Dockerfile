FROM ubuntu:16.04

ENV TEMPEST_TAG="17.2.0"
ENV HEAT_TAG="b4acd96ee35e8839c22ca6dc08034fca684a2a22"
ENV BARBICAN_TAG = "ecce1f64f76ac2121091ec4310e715b392bcc678"
ENV DESIGNATE_TAG = "a8e643ed7944700aa78ace7d0b47beeaeae11a9a"

RUN apt-get update 
RUN apt-get install git -y
RUN apt-get install -y git python-setuptools curl
RUN easy_install pip
RUN apt-get install -y libxml2-dev libxslt-dev lib32z1-dev
RUN apt-get install -y python2.7-dev python-dev libssl-dev
RUN apt-get install -y python-libxml2 libxslt1-dev libsasl2-dev 
RUN apt-get install -y libsqlite3-dev libldap2-dev libffi-dev git
RUN pip install -U pyopenssl
RUN apt install vim -y 


    # TBD define plugins tag/branch 

RUN git clone https://github.com/openstack/tempest.git -b $TEMPEST_TAG && \
    pip install tempest==$TEMPEST_TAG && cd tempest && \
    testr init && \
    cd .. && \
    git clone https://github.com/openstack/heat-tempest-plugin.git && cd heat-tempest-plugin && \
    git checkout $HEAT_TAG && \
    pip install -e /heat-tempest-plugin/ && \
    cd .. && \
    git clone https://github.com/openstack/designate-tempest-plugin.git && cd designate-tempest-plugin && \
    git checkout $DESIGNATE_TAG && \
    pip install -e /designate-tempest-plugin/ && \
    cd .. && \
    git clone https://github.com/openstack/barbican-tempest-plugin.git && cd barbican-tempest-plugin && \
    git checkout $BARBICAN_TAG && \
    pip install -e /barbican-tempest-plugin/ && \  
    cd .. && \  
    apt install wget && \
    apt-get update -qq && \
    apt install python-openstackclient -y && \
    apt install python3-openstackclient -y && \
    pip install python-openstackclient==3.14.0 

COPY docker-tempest-plugins/*.list /etc/tempest/mcp_skip.list
COPY rally_reports/tempest_generated.conf /etc/tempest/tempest.conf
COPY docker-tempest-plugins/run_tempest.sh /etc/tempest/run-tempest
COPY docker-tempest-plugins/generate_resources.sh /etc/tempest/generate_resources
COPY docker-tempest-plugins/prepare.sh /etc/tempest/prepare

WORKDIR /tempest



ENV SOURCE_FILE /home/ubuntu/keystonercv3

ENTRYPOINT ["/bin/bash"]
