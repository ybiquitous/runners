require 'rake/testtask'

module NodeHarness
  module Tasks
    extend Rake::DSL

    def self.define(runner_name:)
      namespace :test do
        Rake::TestTask.new(:units) do |t|
          t.libs << "test/units"
          t.libs << "lib"
          t.test_files = FileList['test/units/**/*_test.rb']
        end

        desc "Run smoke test"
        task :smoke do
          sh "bundle", "exec", "node_harness_smoke", "lib/entrypoint.rb", "test/smokes/expectations.rb"
        end
      end

      desc "Push to remote and tag"
      task :publish do

      end

      namespace :docker do
        desc "Build docker image"
        task :build do
          sh "docker", "build", "-t", "quay.io/actcat/#{runner_name}:dev", "."
        end

        desc "Run unit test on Docker"
        task :test do
          sh 'docker', 'run', '--rm', '--entrypoint=bundle', "quay.io/actcat/#{runner_name}:dev", 'exec', 'rake', 'test:units'
        end

        desc "Run smoke test on Docker"
        task :smoke do
          sh "bundle", "exec", "node_harness_smoke", "--docker", "quay.io/actcat/#{runner_name}:dev", "test/smokes/expectations.rb"
        end

        desc "Run interactive shell on Docker"
        task :shell do
          sh "docker", "run", "--rm", "-it", "--entrypoint=/bin/bash", "quay.io/actcat/#{runner_name}:dev"
        end
      end
    end
  end
end
