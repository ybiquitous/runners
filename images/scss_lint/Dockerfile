# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.5.0

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

# Install the default version
COPY images/scss_lint/Gemfile ${RUNNER_USER_HOME}/scss_lint_Gemfile
RUN cd ${RUNNER_USER_HOME} && \
    mkdir scss_lint && \
    mv scss_lint_Gemfile scss_lint/Gemfile && \
    cd scss_lint && \
    bundle install --system --gemfile=Gemfile && \
    rbenv rehash && \
    cd ${RUNNER_USER_HOME} && \
    rm -rf scss_lint && \
    gem list scss_lint

COPY images/scss_lint/scss-lint.default.yml $RUNNER_USER_HOME/.scss-lint.yml

# Copy the main source code
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib

# Change owner and group of all files
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=scss_lint"]
