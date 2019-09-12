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
  # FIXME: Must check all files.
  files = Dir.glob("lib/**/*.rb").reject { |f| f.include? "processor/" }
  files += Dir.glob("lib/**/cppcheck/**/*.rb")
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

desc "Release"
task :release, [:version] do |_task, args|
  new_version = args[:version] or abort "Required version!"

  sh "git checkout master --quiet"
  sh "git pull origin master --quiet"
  sh "bundle install --quiet"

  current_version = `git describe --abbrev=0 --tags`.chomp
  unless Gem::Version.new(current_version) < Gem::Version.new(new_version)
    abort "Invalid version! current=#{current_version} new=#{new_version}"
  end

  sh "git diff --exit-code --quiet" do |ok|
    abort "Uncommitted changes found!" unless ok
  end

  sh "git --no-pager log --oneline #{current_version}...HEAD"

  if ENV["DRYRUN"]
    puts "This is a dry-run mode. No actual changes."
  else
    update_changelog current_version, new_version
    sh "git commit -a -m 'Version #{new_version}' --quiet"
    sh "git tag -a #{new_version} -m 'Version #{new_version}'"
    puts "The tag '#{new_version}' is added. Run 'git push --follow-tags'."
  end
end

def update_changelog(current_version, new_version)
  file = "CHANGELOG.md"
  new_lines = File.readlines(file, chomp: true).map do |line|
    case
    when line == "## Unreleased"
      "## #{new_version}"
    when line.include?("#{current_version}...HEAD")
      line.sub("#{current_version}...HEAD", "#{current_version}...#{new_version}")
    else
      line
    end
  end
  new_lines.insert(4,
    "## Unreleased",
    "",
    "[Full diff](https://github.com/sider/runners/compare/#{new_version}...HEAD)",
    "",
  )
  File.write(file, new_lines.join("\n") + "\n")
end
