FROM ubuntu:16.04

ENV TEMPEST_TAG="17.2.0"
ENV HEAT_TAG="87d66da2beffd3eb884d516cf45a31e55a19758d"
ENV BARBICAN_TAG="c2d9b66975d3606379eec9f01f055847693c6949"
ENV DESIGNATE_TAG="6e03c58b7f4525b70fc447c2286e5b34bde624b0"
ENV MANILA_TAG="2aea7c344faaba11f19ce905be5467f448730e4c"

RUN apt-get update 
RUN apt-get install git -y
RUN apt-get install -y git python-setuptools curl
RUN easy_install pip
RUN apt-get install -y libxml2-dev libxslt-dev lib32z1-dev
RUN apt-get install -y python2.7-dev python-dev libssl-dev
RUN apt-get install -y python-libxml2 libxslt1-dev libsasl2-dev 
RUN apt-get install -y libsqlite3-dev libldap2-dev libffi-dev git
RUN pip install -U pyopenssl
RUN pip install junitxml
RUN pip install xunit2testrail
RUN apt install vim -y 


    # TBD define plugins tag/branch 

RUN git clone https://github.com/openstack/tempest.git -b $TEMPEST_TAG && \
    pip install tempest==$TEMPEST_TAG && cd tempest && \
    testr init && \
    cd .. && \
    git clone https://gerrit.mcp.mirantis.net/packaging/sources/heat-tempest-plugin && cd heat-tempest-plugin && \
    git checkout $HEAT_TAG && \
    pip install -e /heat-tempest-plugin/ && \
    cd .. && \
    git clone https://gerrit.mcp.mirantis.net/packaging/sources/designate-tempest-plugin && cd designate-tempest-plugin && \
    git checkout $DESIGNATE_TAG && \
    pip install -e /designate-tempest-plugin/ && \
    cd .. && \
    git clone https://gerrit.mcp.mirantis.net/packaging/sources/barbican-tempest-plugin && cd barbican-tempest-plugin && \
    git checkout $BARBICAN_TAG && \
    pip install -e /barbican-tempest-plugin/ && \  
    cd .. && \
    git clone https://gerrit.mcp.mirantis.net/packaging/sources/manila-tempest-plugin && cd manila-tempest-plugin && \
    git checkout $MANILA_TAG && \
    pip install -e /manila-tempest-plugin/ && \
    cd .. && \
    git clone https://gerrit.mcp.mirantis.net/packaging/sources/ironic-tempest-plugin && cd ironic-tempest-plugin && \
    pip install -e /ironic-tempest-plugin/ && \ 
    cd .. && \
    apt install wget && \
    apt-get update -qq && \
    apt install python-openstackclient -y && \
    apt install python3-openstackclient -y && \
    pip install python-openstackclient==3.14.0 

COPY *.list /var/lib/
COPY run_tempest.sh /usr/bin/run-tempest
COPY generate_resources.sh /etc/tempest/generate_resources
COPY prepare.sh /etc/tempest/prepare

RUN chmod +x /usr/bin/run-tempest

ENV LOG_DIR /home/ubuntu/rally_reports/all/
ENV SOURCE_FILE /home/ubuntu/keystonercv3
ENV TEMPEST_CONF /home/ubuntu/rally_reports/tempest_generated.conf
ENV SKIP_LIST mcp_skip.list
ENV PATH $PATH:/usr/bin/run-tempest


WORKDIR /tempest




ENTRYPOINT ["run-tempest"]

