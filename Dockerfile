FROM stpork:bamboo-centos-base

MAINTAINER stpork from Mordor team

ENV BAMBOO_VERSION 		6.2.2

ENV BAMBOO_INSTALL 		/opt/atlassian/bamboo
ENV BAMBOO_HOME 		/var/atlassian/application-data/bamboo
ENV BAMBOO_USER         daemon
ENV BAMBOO_GROUP        daemon

ARG BAMBOO_URL=http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="Atlassian Bamboo"
LABEL io.k8s.display-name="Bamboo 6.2.2"
LABEL io.openshift.expose-services="8085:http"

# Install the nginx web server package and clean the yum cache
RUN set +x 
RUN mkdir -p ${BAMBOO_INSTALL}
RUN mkdir -p ${BAMBOO_HOME}
RUN curl -L --silent ${BAMBOO_URL} | tar -xz --strip-components=1 -C "$BAMBOO_INSTALL"
RUN echo -e "\nbamboo.home=$BAMBOO_HOME" >> "${BAMBOO_INSTALL}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
RUN chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_INSTALL} 
RUN chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_HOME} 

USER ${BAMBOO_USER}:${BAMBOO_GROUP}

EXPOSE 8085
EXPOSE 54663

VOLUME ["${BAMBOO_HOME}"]

WORKDIR ${BAMBOO_HOME}

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
ENTRYPOINT ["/sbin/tini", "--"]
