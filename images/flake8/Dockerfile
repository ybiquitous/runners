# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.0.3

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


ARG LINT_TOOL_VERSION=3.7.7
RUN PYTHON2_VERSION=`pyenv versions --bare | grep '^2' --color=none` && \
    PYTHON3_VERSION=`pyenv versions --bare | grep '^3' --color=none` && \
    pyenv global $PYTHON2_VERSION && \
    pip install flake8==$LINT_TOOL_VERSION && \
    pyenv global $PYTHON3_VERSION && \
    pip install flake8==$LINT_TOOL_VERSION

USER root
COPY images/flake8/sider_config.ini $RUNNER_USER_HOME/.config/flake8
COPY images/flake8/ignored-config.ini $RUNNER_USER_HOME/.config/ignored-config.ini
RUN chown -R $RUNNER_USER $RUNNER_USER_HOME/.config
USER $RUNNER_USER

ENTRYPOINT ["node_harness", "--analyzer=flake8"]
