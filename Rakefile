require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => [:test, :typecheck]

Rake::Task['release'].clear
task "release", [:remote] => ["build", "release:guard_clean",
                              "release:source_control_push"] do
end

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
