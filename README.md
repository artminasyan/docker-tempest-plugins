For running tests on env you shoud check that api of nessesary plugin was run on your environment
# ps aux | grep $NAME OF PLUGIN
 
If plugin is not running you should you use salt formula , for example: 
# salt-call state.sls $NAME OF PLUGIN 

Execute : 
# docker build -f docker-tempest-plugins/Dockerfile .
# docker run --net host -v /root/:/home/ubuntu -tid -u root $image_id
# docker exec -ti $docker_id bash

For heat-tempest-plugin tests , please source run-tempest intro container:
# . /etc/tempest/run-tempest

For running tests: 
# tempest run NAME_OF_TEST or testr run NAME_OF_TEST

Test should be run from after building container from tempest repository.  
