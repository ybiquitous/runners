# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:2.2.0

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners
COPY Gemfile* Rakefile ${RUNNERS_DIR}/
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNERS_DIR}
USER $RUNNER_USER

RUN cd ${RUNNERS_DIR} && bundle install --without development test
ENV BUNDLE_GEMFILE ${RUNNERS_DIR}/Gemfile
ENV PATH ${RUNNERS_DIR}/bin:${PATH}


ARG ESLINT_VERSION=5.16.0

# Install eslint globally
USER root
RUN npm install -g eslint@${ESLINT_VERSION}
USER $RUNNER_USER

# NOTE: ESLint uses a configuration file in the home directory if no other configuration files are found.
#       See https://eslint.org/docs/user-guide/configuring#configuration-cascading-and-hierarchy
COPY images/eslint/sider_eslintrc.yml $RUNNER_USER_HOME/.eslintrc.yml

ENTRYPOINT ["runners", "--analyzer=eslint"]
