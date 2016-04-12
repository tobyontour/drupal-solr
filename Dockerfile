FROM java:8
MAINTAINER  Toby Bettridge "toby.bettridge@stubside.com"

ENV SOLR_VERSION 5.1.0
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr
ENV SEARCH_API_SOLR_VERSION 1.8
ENV SOLR_CORE_NAME drupal

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install \
    curl \
    lsof \
    sudo \
    procps && \
  groupadd -r $SOLR_USER && \
  useradd -r -g $SOLR_USER $SOLR_USER && \
  mkdir -p /opt && \
  wget -nv --output-document=/opt/$SOLR.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -C /opt --extract --file /opt/$SOLR.tgz && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr /opt/$SOLR

RUN sudo -u $SOLR_USER /opt/solr/bin/solr start -p 8983 && \
  sudo -u $SOLR_USER /opt/solr/bin/solr create_core -p 8983 -c $SOLR_CORE_NAME && \
  wget -nv --output-document=/opt/search_api_solr.tgz http://ftp.drupal.org/files/projects/search_api_solr-7.x-$SEARCH_API_SOLR_VERSION.tar.gz && \
  tar -C /opt --extract --file /opt/search_api_solr.tgz && \
  rm /opt/search_api_solr.tgz && \
  rm -rf /opt/solr/server/solr/$SOLR_CORE_NAME/conf && \
  mv /opt/search_api_solr/solr-conf/5.x /opt/conf && \
  rm -rf /opt/search_api_solr && \
  ln -s /opt/conf /opt/solr/server/solr/$SOLR_CORE_NAME/conf && \
  (sudo -u $SOLR_USER /opt/solr/bin/solr stop -p 8983 || true)

EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER
CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
