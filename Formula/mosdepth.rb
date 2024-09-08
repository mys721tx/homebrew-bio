class Mosdepth < Formula
  # cite Pederson_2017: "https://doi.org/10.1093/bioinformatics/btx699"
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "9171ea9a6ddaccd0091db5b85fa9e6cb79516bbe005c47ffc8dcfe49c978eb69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28f0f2a6c62cd8543a9f85404c63f861562a25c62dd21bf5c2186d81198be791"
  end

  depends_on "nim" => :build
  depends_on "brewsci/bio/d4tools"
  depends_on "bwa"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # make nim.cfg for Homebrew
    rm buildpath/"nim.cfg"
    (buildpath/"nim.cfg").write <<~EOS
      passl:"-L#{Formula["htslib"].opt_lib} -lhts"
      passl:"-L#{Formula["brewsci/bio/d4tools"].opt_lib} -ld4binding"
      passl:"-L#{Formula["libdeflate"].opt_lib} -ldeflate"
      passl:"-L#{Formula["openssl@3"].opt_lib} -lcrypto -lssl"
      passl:"-llzma"
      passl:"-lz"
      passl:"-lbz2"
      passl:"-lcurl"
      passl:"-lpthread"
      passl:"-lm"
      dynlibOverride:"hts"
      dynlibOverride:"bz2"
      dynlibOverride:"pthread"
      define:release
      opt:speed
      threads:on
    EOS
    system "nimble", "build", "-Y", "mosdepth.nimble"
    bin.install "mosdepth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mosdepth --version 2>&1")
    assert_match "BAM-or-CRAM", shell_output("#{bin}/mosdepth -h 2>&1")
  end
end
