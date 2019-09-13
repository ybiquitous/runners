# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.2.0

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


RUN gem install rails_best_practices -v 1.19.4 && \
    gem install slim -v 4.0.1 && \
    gem install haml -v 5.0.4 && \
    gem install sass -v 3.7.3 && \
    gem install sassc -v 2.0.1 && \
    gem install require_all:1.5.0 require_all:2.0.0

COPY images/rails_best_practices/sider_rails_best_practices.yml $RUNNER_USER_HOME/
ENTRYPOINT ["node_harness", "--analyzer=rails_best_practices"]
