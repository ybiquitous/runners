# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_go:2.5.0

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY Gemfile* ${RUNNERS_DIR}/
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNERS_DIR}
USER $RUNNER_USER
RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config && \
    bundle install --without='development test'
ENV PATH ${RUNNERS_DIR}/bin:${PATH}

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

# Copy the main source code
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib

# Change owner and group of all files
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=golint"]
