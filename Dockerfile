FROM ubuntu:16.04

ENV TEMPEST_TAG="17.2.0"
ENV HEAT_TAG="b4acd96ee35e8839c22ca6dc08034fca684a2a22"

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
    pip install -r requirements.txt && \
    pip install -r test-requirements.txt && \
    pip install -e /heat-tempest-plugin/ && \    
    apt install wget && \
    apt-get update -qq && \
    apt install python-openstackclient -y && \
    apt install python3-openstackclient -y && \
    pip install python-openstackclient==3.14.0 

COPY *.list /etc/tempest/mcp_skip.list 
COPY *.conf /etc/tempest/tempest.conf 
COPY run_tempest.sh /etc/tempest/run-tempest
COPY generate_resources.sh /etc/tempest/generate_resources
COPY prepare.sh /etc/tempest/prepare

#RUN bash /etc/tempest/prepare
#ENV LOG_DIR /home/rally/rally_reports/
#ENV SET smoke
#ENV CONCURRENCY 0
#ENV TEMPEST_CONF tempest_generated.conf
#ENV SKIP_LIST mcp_skip.list

WORKDIR /tempest



ENV SOURCE_FILE /home/ubuntu/keystonercv3

ENTRYPOINT ["run-tempest"]
