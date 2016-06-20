ENV['PUPPET_INSTALL_VERSION']='4'
ENV['BEAKER_PUPPET_AGENT_VERSION']='1.5.1'
ENV['BEAKER_destroy']='no'

require 'rubygems'
require 'bundler/setup'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet/version'
require 'puppet/vendor/semantic/lib/semantic' unless Puppet.version.to_f < 3.6
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'
require 'rubocop/rake_task'

# http://razorconsulting.com.au/parallelising-rspec-puppet.html
require 'parallel_tests'

# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

RuboCop::RakeTask.new

exclude_paths = [
  "bundle/**/*",
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
  "hieradata/serverbeheer.yaml",
]

# Coverage from puppetlabs-spec-helper requires rcov which
# doesn't work in anything since 1.8.7
Rake::Task[:coverage].clear

Rake::Task[:lint].clear

PuppetLint.configuration.relative = true
PuppetLint.configuration.disable_class_inherits_from_params_class
PuppetLint.configuration.disable_class_parameter_defaults
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_140chars')

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
end

PuppetSyntax.exclude_paths = exclude_paths

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc "Run all acceptance tests"
task :ci_acceptance do
  FileList["profiles/*/Rakefile"].each do |profile|
    dir = profile.pathmap("%d")
    Dir.chdir(dir) do
      puts "Testing #{dir}"
      Rake::Task[:acceptance].execute()
    end
  end
end

desc "Run all rspec tests"
task :ci_spec do
  FileList["profiles/*/Rakefile"].each_with_index do |profile,i|
    dir = profile.pathmap("%d")
    Dir.chdir(dir) do
      puts "Testing #{dir}"
      if i == 0
        Rake::Task[:spec].execute()
      else
        # Allow sub-tasks to be invoked again
        Rake::Task[:spec_prep].reenable()
        Rake::Task[:spec_standalone].reenable()
        Rake::Task[:spec_clean].reenable()

        Rake::Task[:spec].execute()
      end
    end
  end
end

desc "Populate CONTRIBUTORS file"
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :metadata_lint,
  :syntax,
  :lint,
  :rubocop,
  :spec,
]

begin
  require 'parallel_tests/cli'
  desc 'Run spec tests in parallel'
  task :parallel_spec do
    Rake::Task[:spec_prep].invoke
    ParallelTests::CLI.new.run('-o "--format=documentation" -t rspec spec/classes spec/defines'.split)
    Rake::Task[:spec_clean].invoke
  end
  desc 'Run syntax, lint, spec and metadata tests in parallel'
  task :parallel_test => [
    :syntax,
    :lint,
    :parallel_spec,
    :metadata_lint,
  ]
rescue LoadError # rubocop:disable Lint/HandleExceptions
end
