class Fasttree < Formula
  # cite Price_2010: "https://doi.org/10.1371/journal.pone.0009490"
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  url "http://microbesonline.org/fasttree/FastTree-2.1.11.c"
  sha256 "9026ae550307374be92913d3098f8d44187d30bea07902b9dcbfb123eaa2050f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "cf6541872936ca28dba6186f57ea237e62715a47632a147eec3ef3f687a0ec22" => :catalina
    sha256 "d31e0a4e16dfa3c8ab2695d335eed25b70e0e67bd959d432e7cb360a9ae4f232" => :x86_64_linux
  end

  # 26 Aug 2017; Community mostly wants USE_DOUBLE; make it default now
  # http://www.microbesonline.org/fasttree/#BranchLen
  # http://darlinglab.org/blog/2015/03/23/not-so-fast-fasttree.html

  option "without-double", "Disable double precision floating point. Use single precision floating point & enable SSE"
  option "without-openmp", "Disable multithreading support"
  option "without-sse", "Disable SSE parallel instructions"

  if build.with? "openmp"
    fails_with :clang # needs OpenMP
    depends_on "gcc" if OS.mac? # needs OpenMP
  end

  def install
    opts = %w[-O3 -finline-functions -funroll-loops]
    opts << "-DOPENMP" << "-fopenmp" if build.with? "openmp"
    opts << "-DUSE_DOUBLE" if build.with? "double"
    opts << "-DNO_SSE" if build.without? "sse"
    system ENV.cc, "-o", "FastTree", "FastTree-#{version}.c", "-lm", *opts
    bin.install "FastTree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/FastTree -expert 2>&1")
    (testpath/"test.fa").write <<~EOS
      >1
      LCLYTHIGRNIYYGSYLYSETWNTTTMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >2
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >3
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGTTLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOS
    assert_match /1:0.\d+,2:0.\d+,3:0.\d+/, shell_output("#{bin}/FastTree test.fa 2>&1")
  end
end
