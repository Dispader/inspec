# encoding: utf-8
# author: Dominik Richter
# author: Christoph Hartmann

module Fetchers
  class Local < Inspec.fetcher(1)
    name 'local'
    priority 0

    def self.resolve(target)
      local_path = if target.is_a?(String)
                     resolve_from_string(target)
                   elsif target.is_a?(Hash)
                     resolve_from_hash(target)
                   end

      if local_path
        new(local_path)
      end
    end

    def self.resolve_from_hash(target)
      if target.key?(:path)
        local_path = target[:path]
        if target.key?(:cwd)
          local_path = File.expand_path(local_path, target[:cwd])
        end
        local_path
      end
    end

    def self.resolve_from_string(target)
      # Support "urls" in the form of file://
      if target.start_with?('file://')
        target = target.gsub(%r{^file://}, '')
      else
        # support for windows paths
        target = target.tr('\\', '/')
      end

      if File.exist?(target)
        target
      end
    end

    def initialize(target)
      @target = target
    end

    def fetch(_path)
      archive_path
    end

    def archive_path
      @target
    end

    def resolved_source
      { path: @target }
    end
  end
end
