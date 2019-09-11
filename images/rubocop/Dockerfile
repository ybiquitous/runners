# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.1.0

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


RUN gem install rubocop -v 0.74.0

ENTRYPOINT ["node_harness", "--analyzer=rubocop"]
