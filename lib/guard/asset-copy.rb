require 'guard'
require 'guard/guard'

module Guard
  class AssetCopy < Guard

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      options = {
        :assets_src    => [ 'app/assets', 'vendor/assets' ],
        :assets_dest   => 'public/assets',
        :notifications => true
      }.merge(options)

      options[:assets_src].each do |src|
        watchers << ::Guard::Watcher.new(%r{^#{src}/.+\.(js|css|png|jpg|jpeg)$})
      end

      super(watchers, options)
      @watchers, @options = watchers, options
    end

    # Call once when Guard starts.
    # @raise [:task_has_failed] when start has failed
    def start
      run_all
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob(File.join('**', '*.*'))))
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      paths.each do |file|
        output_file = get_output(file)
        FileUtils.mkdir_p File.dirname(output_file)

        FileUtils.cp(file, output_file)
        ::Guard::UI.info "# copied '#{file}' to '#{output_file}'"
        ::Guard::Notifier.notify("# copied #{file}", :title => "Guard::Copy", :image => :success) if @options[:notifications]
      end
      notify paths
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_deletion(paths)
      paths.each do |file|
        output_file = get_output(file)
        FileUtils.mkdir_p File.dirname(output_file)

        FileUtils.rm(output_file)
        ::Guard::UI.info "# removed '#{output_file}'"
        ::Guard::Notifier.notify("# removed #{optionsfile}", :title => "Guard::Copy", :image => :success) if @options[:notifications]
      end
      notify paths
    end

    # Get the file path to output the html based on the file being
    # built.  The output path is relative to where guard is being run.
    #
    # @param file [String] path to file being built
    # @return [String] path to file where output should be written
    #
    def get_output(file)
      file_dir = File.dirname(file)+'/'
      file_name = File.basename(file)

      file_dir = file_dir.gsub(Regexp.new("(#{@options[:assets_src].join('|')})/[\\w-]+?/"), '')
      file_dir = File.join(@options[:assets_dest], file_dir)

      if file_dir == ''
        file_name
      else
        File.join(file_dir, file_name)
      end
    end

    def notify(changed_files)
      ::Guard.guards.reject{ |guard| guard == self }.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_change paths unless paths.empty?
      end
    end

  end
end
