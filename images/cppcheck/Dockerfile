# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.4.0 AS builder

# NOTE: The reason using Python image: when setting `MATCHCOMPILER=yes`, Python is used to optimise cppcheck.
#
# See https://github.com/danmar/cppcheck#gnu-make

ARG CPPCHECK_VERSION=1.89
USER root
RUN cd /tmp && \
    curl -sSL https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz | tar -xz && \
    cd cppcheck-${CPPCHECK_VERSION} && \
    make install -s \
      MATCHCOMPILER=yes \
      FILESDIR=/usr/share/cppcheck \
      HAVE_RULES=yes \
      CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" && \
    rm -rf cppcheck-${CPPCHECK_VERSION}

FROM sider/devon_rex_base:2.4.0

COPY --from=builder /usr/share/cppcheck /usr/share/cppcheck
COPY --from=builder /usr/bin/cppcheck /usr/bin/cppcheck

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

ENTRYPOINT ["/usr/bin/timeout", "--kill-after=10s", "30m", "runners", "--analyzer=cppcheck"]
