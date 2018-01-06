# Naive fallback asset finder for when sprockets >= 3.0 &&
# config.assets.precompile = false
# Thanks to @ryanswood for the original code:
# https://github.com/AbleHealth/inline_svg/commit/661bbb3bef7d1b4bd6ccd63f5f018305797b9509
module InlineSvg
  class StaticAssetFinder
    attr_reader :manifest, :assets, :asset_path

    def self.find_asset(filename)
      new(filename)
    end

    def initialize(filename)
      @filename = filename
      @manifest = ::Rails.application.assets_manifest
      @assets = ::Rails.application.config.assets
      @asset_path = manifest.assets[@filename]
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
      assets.compile && compiled_pathname.exist?
    end

    def compiled_pathname
      assets[@filename].pathname
    end

    def manifest_pathname
      ::Rails.root.join(manifest.directory, asset_path) unless asset_path.nil?
    end

    def engine_pathname
      engine_root.join(@filename)
    end

    def engine_root
      engine_paths.find { |path| path.join(@filename).exist? }
    end

    def engine_paths
      assets.paths.map { |path| Pathname.new(path) }
    end
  end
end
