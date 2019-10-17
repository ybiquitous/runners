# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_base:master

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends file && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG SHELLCHECK_VERSION=0.7.0

# NOTE: Compiling via Cabal is too slow. See #296.
RUN cd /tmp && \
    baseurl="https://storage.googleapis.com/shellcheck/shellcheck-v${SHELLCHECK_VERSION}" && \
    curl -sSL "${baseurl}.linux.x86_64.tar.xz" | tar -xJ && \
    curl -sSL "${baseurl}.linux-x86_64.sha512sum" | \
      awk '{ print $1 }' | \
      xargs -I {} echo "{} *shellcheck-v${SHELLCHECK_VERSION}/shellcheck" | \
      sha512sum --check --strict && \
    cp "shellcheck-v${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/ && \
    shellcheck --version && \
    rm -r "shellcheck-v${SHELLCHECK_VERSION}"

USER $RUNNER_USER

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
# Copy the main source code
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib

# Change owner and group of all files
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=shellcheck"]
