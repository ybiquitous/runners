# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.0.3

# NOTE: The reason using Python image: when setting `MATCHCOMPILER=yes`, Python is used to optimise cppcheck.
#
# See https://github.com/danmar/cppcheck#gnu-make

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


ARG CPPCHECK_VERSION=1.89

USER root
RUN cd /tmp \
  && curl -sSL https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz \
  |  tar -xz \
  && cd cppcheck-${CPPCHECK_VERSION} \
  && make -s MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" \
  && make -s install MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck \
  && rm -rf cppcheck-${CPPCHECK_VERSION}
USER $RUNNER_USER

ENTRYPOINT ["node_harness", "--analyzer=cppcheck"]
