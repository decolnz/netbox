FROM python:2.7-wheezy

WORKDIR /opt/netbox

ARG BRANCH=master
ARG URL=https://github.com/digitalocean/netbox.git
RUN git clone --depth 1 $URL -b $BRANCH .  && \
    apt-get update -qq && apt-get install -y libldap2-dev libsasl2-dev libssl-dev graphviz && \
	pip install gunicorn==17.5 && \
	pip install django-auth-ldap && \
    pip install -r requirements.txt

ADD docker/docker-entrypoint.sh /docker-entrypoint.sh
ADD netbox/netbox/configuration.docker.py /opt/netbox/netbox/netbox/configuration.py

ENTRYPOINT [ "/docker-entrypoint.sh" ]

ADD docker/gunicorn_config.py /opt/netbox/
ADD docker/nginx.conf /etc/netbox-nginx/
VOLUME ["/etc/netbox-nginx/"]
