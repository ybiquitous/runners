# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_swift:2.6.0

ARG SWIFTLINT_VERSION=0.36.0

# Build SwiftLint
USER root
# HACK: Apply a patch to avoid "error: product dependency 'CryptoSwift' not found". See #315.
COPY images/swiftlint/fix-CryptoSwift-not-found.patch /tmp/
RUN SWIFTLINT_BUILD_DIR=/tmp/swiftlint_build && \
    git clone --branch ${SWIFTLINT_VERSION} --single-branch https://github.com/realm/SwiftLint.git ${SWIFTLINT_BUILD_DIR} && \
    cd ${SWIFTLINT_BUILD_DIR} && \
    git apply /tmp/fix-CryptoSwift-not-found.patch && \
    make install && \
    swiftlint version && \
    rm -rf ${SWIFTLINT_BUILD_DIR} && \
    rm /tmp/fix-CryptoSwift-not-found.patch
USER $RUNNER_USER

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=analyzer_runner:nogroup Gemfile* ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config && \
    bundle install --without='development test'
# Copy the main source code
COPY --chown=analyzer_runner:nogroup bin ${RUNNERS_DIR}/bin
COPY --chown=analyzer_runner:nogroup lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=swiftlint"]
