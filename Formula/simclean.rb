class Simclean < Formula
  desc "CLI to clean iOS Simulator app data"
  homepage "https://github.com/sushantdsuwal/simclean"
  url "https://github.com/sushantdsuwal/simclean/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "de6ad67e76d1247c1e72103d50f2030044254699d08889956d0da8747311182d"
  version "1.0.0"

  def install
    bin.install "simclean.sh" => "simclean"
  end
end
