# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.2.2

# Install the default version
ARG KTLINT_VERSION=0.34.2
USER root
RUN WORKDIR=/tmp/ktlint_work && \
    mkdir -p ${WORKDIR} && \
    cd ${WORKDIR} && \
    BASE_URL=https://github.com/pinterest/ktlint/releases/download/${KTLINT_VERSION} && \
    curl -fsSLO --compressed ${BASE_URL}/ktlint && \
    curl -fsSLO --compressed ${BASE_URL}/ktlint.asc && \
    curl -fsSL https://keybase.io/pinterestandroid/pgp_keys.asc | gpg --import && gpg --verify ktlint.asc && \
    chmod a+x ktlint && \
    mv ktlint /usr/local/bin/ && \
    ktlint --version && \
    rm -rf ${WORKDIR}

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners
COPY Gemfile* Rakefile ${RUNNERS_DIR}/
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNERS_DIR}
USER $RUNNER_USER

RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config && \
    bundle install --without='development test'
ENV PATH ${RUNNERS_DIR}/bin:${PATH}
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=ktlint"]
