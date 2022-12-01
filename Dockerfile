ARG version=latest
FROM squadproject/squad:${version}

USER root

ARG extra_packages=""
RUN apt -q update && \
    apt-get -q -y upgrade && \
    apt-get -q -y install \
        ${extra_packages} \
        rabbitmq-server \
        wget

COPY ./scripts/populate.sh /root/populate.sh
COPY ./scripts/create_project.py /root/create_project.py
COPY ./scripts/create_backend_lava.py /root/create_backend_lava.py
COPY ./scripts/entrypoint.sh /root/entrypoint.sh

ENV ENV production

ARG ampq_server="localhost"
ENV SQUAD_CELERY_BROKER_URL=amqp://${ampq_server}

ARG port_http=80
ENV SQUAD_PORT=${port_http}

ARG lava_server=""
ENV LAVA_SERVER=${lava_server}
ARG lava_username=""
ENV LAVA_USERNAME=${lava_username}
ARG lava_token=""
ENV LAVA_TOKEN=${lava_token}

ARG group=""
ENV SQUAD_GROUP=${group}
ARG projects=""
ENV SQUAD_PROJECTS=${projects}

ARG admin_username=root
ARG admin_password=password
ARG admin_email=$admin_password@localhost.com
ARG admin_token="2d703e793ea345efdbab52d95fe33ec715bcc2d4"
RUN /root/populate.sh ${admin_username} ${admin_password} ${admin_email} ${admin_token}

ENTRYPOINT ["/root/entrypoint.sh"]
