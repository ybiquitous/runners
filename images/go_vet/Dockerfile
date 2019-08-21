# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_go:2.0.3

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


ARG LINT_TOOL_VERSION="3.0.0"

USER root
RUN curl -L https://github.com/alecthomas/gometalinter/releases/download/v${LINT_TOOL_VERSION}/gometalinter-${LINT_TOOL_VERSION}-linux-amd64.tar.gz | \
    tar -xzC . && \
    cd gometalinter-${LINT_TOOL_VERSION}-linux-amd64/ && \
    rm COPYING README.md && \
    mv * /usr/local/bin/ && \
    cd .. && \
    rm -r gometalinter-${LINT_TOOL_VERSION}-linux-amd64/
USER $RUNNER_USER

ENTRYPOINT ["node_harness", "--analyzer=go_vet"]
