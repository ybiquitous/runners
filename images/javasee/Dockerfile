# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.2.0

ARG NODE_HARNESS_DIR=$RUNNER_USER_HOME/node_harness
COPY Gemfile* Rakefile $NODE_HARNESS_DIR/
COPY bin ${NODE_HARNESS_DIR}/bin
COPY lib ${NODE_HARNESS_DIR}/lib
USER root
RUN chown -R $RUNNER_USER: $NODE_HARNESS_DIR
USER $RUNNER_USER

RUN cd $NODE_HARNESS_DIR && bundle install --without development test
ENV BUNDLE_GEMFILE $NODE_HARNESS_DIR/Gemfile
ENV PATH $NODE_HARNESS_DIR/bin:$PATH


ENV JAVASEE_VERSION 0.1.1
USER root
RUN curl -O -L https://github.com/sider/JavaSee/releases/download/${JAVASEE_VERSION}/JavaSee-bin-${JAVASEE_VERSION}.zip \
  && unzip JavaSee-bin-${JAVASEE_VERSION}.zip \
  && mv JavaSee-${JAVASEE_VERSION} /usr/local/JavaSee \
  && ln -s /usr/local/JavaSee/bin/javasee /usr/local/bin/javasee \
  && rm -rf *.zip

USER $RUNNER_USER

ENTRYPOINT ["node_harness", "--analyzer=javasee"]
