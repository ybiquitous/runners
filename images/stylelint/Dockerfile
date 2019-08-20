# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:2.0.3

ARG NODE_HARNESS_DIR=$RUNNER_USER_HOME/node_harness
COPY Gemfile* Rakefile $NODE_HARNESS_DIR/
COPY bin ${NODE_HARNESS_DIR}/bin
COPY lib ${NODE_HARNESS_DIR}/lib
USER root
RUN chown -R $RUNNER_USER: $NODE_HARNESS_DIR
USER $RUNNER_USER

RUN cd $NODE_HARNESS_DIR && bundle install
ENV BUNDLE_GEMFILE $NODE_HARNESS_DIR/Gemfile
ENV PATH $NODE_HARNESS_DIR/bin:$PATH


ARG STYLELINT_VERSION=10.1.0
ARG STYLELINT_CONFIG_RECOMMENDED_VERSION=2.2.0

# Install stylelint globally
USER root
RUN npm install -g stylelint@${STYLELINT_VERSION} stylelint-config-recommended@${STYLELINT_CONFIG_STANDARD_VERSION}
USER $RUNNER_USER

COPY images/stylelint/sider_recommended_config.yaml images/stylelint/sider_recommended_stylelintignore $RUNNER_USER_HOME/

ENTRYPOINT ["node_harness", "--analyzer=stylelint"]
