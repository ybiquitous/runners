# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.2.0

# NOTE: RuboCop 0.60.0 does not work on Ruby 2.6, so install and use Ruby 2.5 instead.
#       See https://github.com/sider/runners/issues/57#issuecomment-530858769
ENV GLOBAL_RUBY_VERSION 2.5.6
RUN rbenv install $GLOBAL_RUBY_VERSION && \
    rbenv global $GLOBAL_RUBY_VERSION && \
    rbenv versions && \
    test $(ruby -e 'puts RUBY_VERSION') = "$GLOBAL_RUBY_VERSION" && \
    gem install bundler --version $BUNDLER1_VERSION && \
    gem install bundler --version $BUNDLER2_VERSION && \
    bundle -v | grep -q "$BUNDLER2_VERSION"

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
