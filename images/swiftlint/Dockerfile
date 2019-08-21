# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_swift:2.0.3

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


ENV SWIFTLINT_VERSION="0.34.0"
ARG SWIFTLINT_BUILD_DIR="/swiftlint_build"

# Build SwiftLint
USER root
RUN git clone --branch ${SWIFTLINT_VERSION} --single-branch https://github.com/realm/SwiftLint.git ${SWIFTLINT_BUILD_DIR} && \
    cd ${SWIFTLINT_BUILD_DIR} && \
    git submodule update --init --recursive && \
    make install && \
    cd / && \
    rm -rf "${SWIFTLINT_BUILD_DIR}"

USER $RUNNER_USER

ENTRYPOINT ["node_harness", "--analyzer=swiftlint"]
