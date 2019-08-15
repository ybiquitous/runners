# Select parent docker image for tool language and your name
FROM

COPY . /analyzer
RUN chown -R $RUNNER_USER /analyzer

RUN bundle install

# Install analyzer tool

# XXX: $RUNNER_USER is not available in ENTRYPOINT because it doesn't expand variables.
#      See https://docs.docker.com/v17.09/engine/reference/builder/#exec-form-entrypoint-example
ENTRYPOINT ["sudo", "-u", "analyzer_runner", "bundle", "exec", "node_harness", "--entrypoint=lib/entrypoint.rb"]
