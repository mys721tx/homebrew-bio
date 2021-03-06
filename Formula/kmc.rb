class Kmc < Formula
  # cite Deorowicz_2015: "https://doi.org/10.1093/bioinformatics/btv022"
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  url "https://github.com/refresh-bio/KMC/archive/v3.1.1.tar.gz"
  sha256 "d7cdf37d90a07d1a432b7427436f962914b5f63a1b6dbb9a116609a1c64d1324"
  head "https://github.com/marekkokot/KMC.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "357369318d5619a941285eca62a1b260ae2d519c4fe27f326b26277d70d97451"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a14014ca6943cd93069815a57e40ae2147d01c32e10109b8009e5198ef0aba32"
  end

  depends_on "gcc"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix error: 'ext/algorithm' file not found
  fails_with :clang

  def install
    args = %W[CC=#{ENV.cxx} KMC_BIN_DIR=#{bin}]
    args << (OS.mac? ? "-fmakefile_mac" : "-fmakefile")

    system "make", *args, "kmc", "kmc_dump", "kmc_tools"

    doc.install Dir["*.pdf"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kmc --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kmc_dump --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kmc_tools 2>&1")
  end
end
