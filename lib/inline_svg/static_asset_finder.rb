# Naive fallback asset finder for when sprockets >= 3.0 &&
# config.assets.precompile = false
# Thanks to @ryanswood for the original code:
# https://github.com/AbleHealth/inline_svg/commit/661bbb3bef7d1b4bd6ccd63f5f018305797b9509
module InlineSvg
  class StaticAssetFinder
    def self.find_asset(filename)
      new(filename)
    end

    def initialize(filename)
      @filename = filename
    end

    def pathname
      if previously_compiled?
        compiled_pathname
      elsif manifest_pathname.exist?
        manifest_pathname
      elsif engine_root.present?
        engine_pathname
      end
    end

    private

    def previously_compiled?
      ::Rails.application.config.assets.compile && compiled_pathname.exist?
    end

    def compiled_pathname
      ::Rails.application.assets[@filename].pathname
    end

    def manifest_pathname
      manifest = ::Rails.application.assets_manifest
      asset_path = manifest.assets[@filename]
      unless asset_path.nil?
        ::Rails.root.join(manifest.directory, asset_path)
      end
    end

    def engine_pathname
      engine_root.join(@filename)
    end

    def engine_root
      engine_paths.find { |path| path.join(@filename).exist? }
    end

    def engine_paths
      ::Rails.configuration.assets.paths.map { |path| Pathname.new(path) }
    end
  end
end
