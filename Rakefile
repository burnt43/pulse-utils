require 'rake/testtask'

namespace :pulse_utils do
  namespace :test do
    Rake::TestTask.new(:run) do |t|
      t.verbose = false
      t.test_files = FileList['./test/*_test.rb']
    end
  end
end
