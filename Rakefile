require "rake/testtask"
require 'erb'

ANALYZERS = begin
  Dir.chdir("images") do
    Dir.glob("*").select { |f| File.directory? f }.freeze
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb'].exclude(%r{^test/smokes})
end

task :default => [:test, :typecheck]

task :typecheck do
  files = %w(
    lib/node_harness/analyzer.rb
    lib/node_harness/changes.rb
    lib/node_harness/cli.rb
    lib/node_harness/harness.rb
    lib/node_harness/issues.rb
    lib/node_harness/location.rb
    lib/node_harness/processor.rb
    lib/node_harness/results.rb
    lib/node_harness/trace_writer.rb
    lib/node_harness/version.rb
    lib/node_harness/workspace.rb
    lib/node_harness/schema
    lib/node_harness/shell.rb
    lib/node_harness/ruby.rb
    lib/node_harness/ruby/gem_installer.rb
    lib/node_harness/ruby/gem_installer/spec.rb
    lib/node_harness/ruby/gem_installer/rubygems_source.rb
    lib/node_harness/ruby/gem_installer/git_source.rb
    lib/node_harness/ruby/lockfile_loader.rb
    lib/node_harness/ruby/lockfile_loader/lockfile.rb
    lib/node_harness/nodejs.rb
    lib/node_harness/nodejs/constraint.rb
    lib/node_harness/nodejs/default_dependencies.rb
    lib/node_harness/nodejs/dependency.rb
  )
  sh "steep", "check", *files
end

namespace :dockerfile do
  desc 'Generate Dockerfile from a template'
  task :generate do
    ANALYZERS.each do |analyzer|
      path = Pathname('images') / analyzer
      template = ERB.new((path / 'Dockerfile.erb').read)
      result = <<~EOD
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
        # PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #{template.result.chomp}
      EOD
      File.write(path / 'Dockerfile', result)
    end
  end

  desc 'Verify Dockerfile is committed'
  task :verify do
    begin
      sh 'git diff --exit-code'
    rescue
      STDERR.puts 'Run `bundle exec rake dockerfile:generate` and include the changes in commit'
      exit(1)
    end
  end
end

namespace :docker do
  def image_name
    "sider/runner_#{analyzer}:#{tag}"
  end

  def image_name_latest
    "sider/runner_#{analyzer}:latest"
  end

  def build_context
    Pathname('images') / analyzer
  end

  def analyzer
    key = 'ANALYZER'
    ENV.fetch(key).tap do |value|
      abort <<~MSG if value.empty?
        Error: `#{key}` environment variable must be required. For example, run as follow:

            $ #{key}=rubocop bundle exec rake docker:build
      MSG
    end
  end

  def tag
    key = 'TAG'
    ENV.fetch(key).tap do |value|
      abort <<~MSG if value.empty?
        Error: `#{key}` environment variable must be required. For example, run as follow:

            $ #{key}=dev bundle exec rake docker:build
      MSG
    end
  end

  def docker_user
    ENV.fetch('DOCKER_USER')
  end

  def docker_password
    ENV.fetch('DOCKER_PASSWORD')
  end

  desc 'Run docker build'
  task :build => 'dockerfile:generate' do
    sh "docker build -t #{image_name} -f #{build_context}/Dockerfile ."
  end

  desc 'Run smoke test on Docker'
  task :smoke do
    sh "ruby ./bin/node_harness_smoke #{image_name} test/smokes/#{analyzer}/expectations.rb"
  end

  desc 'Run docker push'
  task :push do
    sh "docker login -u #{docker_user} -p #{docker_password}"
    sh "docker tag #{image_name} #{image_name_latest}"
    sh "docker push #{image_name}"
    sh "docker push #{image_name_latest}"
  end
end
