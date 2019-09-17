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


ARG STYLELINT_VERSION=10.1.0
ARG STYLELINT_CONFIG_RECOMMENDED_VERSION=2.2.0

# Install stylelint globally
USER root
RUN npm install -g stylelint@${STYLELINT_VERSION} stylelint-config-recommended@${STYLELINT_CONFIG_RECOMMENDED_VERSION}
USER $RUNNER_USER

COPY images/stylelint/sider_recommended_config.yaml images/stylelint/sider_recommended_stylelintignore $RUNNER_USER_HOME/

ENTRYPOINT ["runners", "--analyzer=stylelint"]
