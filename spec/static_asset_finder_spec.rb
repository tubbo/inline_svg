require 'spec_helper'

module InlineSvg
  describe StaticAssetFinder do
    it 'finds precompiled asset' do
      asset = StaticAssetFinder.find_asset('foo.svg')
      allow(asset).to receive(:previously_compiled?).and_return(true)

      expect(asset.pathname).to eq(asset.send(:compiled_pathname))
    end

    it 'finds manifested asset' do
      asset = StaticAssetFinder.find_asset('foo.svg')

      expect(asset.pathname).to eq(asset.send(:manifest_pathname))
    end

    it 'finds asset from engine' do
      asset = StaticAssetFinder.find_asset('foo.svg')

      expect(asset.pathname).to eq(asset.send(:engine_pathname))
    end
  end
end
