class Gatk < Formula
  include Language::Python::Shebang

  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk"
  url "https://github.com/broadinstitute/gatk/releases/download/4.1.8.1/gatk-4.1.8.1.zip"
  sha256 "42e6de5059232df1ad5785c68c39a53dc1b54afe7bb086d0129f4dc95fb182bc"
  license "BSD-3-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fc14b1d8b41bb370fa56e50cc50b83e5e73c317d658e1d36d0ba974e029409a0" => :catalina
    sha256 "e623b8e92370031f256c19b11a22b240e56f02633cf45c1e847184c451df818c" => :x86_64_linux
  end

  depends_on java: "1.8"
  depends_on "python@3.8"

  resource "count_reads.bam" do
    url "https://github.com/broadinstitute/gatk/blob/626c88732c02b0fd5f395db20c91bf2784ec54b9/src/test/resources/org/broadinstitute/hellbender/tools/count_reads.bam?raw=true"
    sha256 "656e36331a39a3641565ef7810a529ac51270b4132007d7b94e6efff99133a2c"
  end

  def install
    prefix.install "gatk"
    prefix.install "scripts/dataproc-cluster-ui"
    prefix.install "gatk-package-#{version}-spark.jar"
    prefix.install "gatk-package-#{version}-local.jar"
    bash_completion.install "gatk-completion.sh"
    bins = ["#{prefix}/gatk", "#{prefix}/dataproc-cluster-ui"]
    bins.find { |f| rewrite_shebang detected_python_shebang, f }
    bin.install_symlink "#{prefix}/gatk"
    bin.install_symlink "#{prefix}/dataproc-cluster-ui"
  end

  def caveats
    <<~EOS
      This brew installation does not include the necessary python dependencies to run certain gatk tools.
      Similarly, it does not install the necessary version of R and its packages for certain plotting functions to work.

      See the GATK readme for detailed installation instructions.
         https://github.com/broadinstitute/gatk

      The recommended way of running the tools with complex python dependencies is to use the pre-built docker images instead of attempting to install them locally.
      Gatk dockers are available on docker hub:
         https://hub.docker.com/r/broadinstitute/gatk/tags/
    EOS
  end
  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1")
    testpath.install resource("count_reads.bam")
    assert_equal "Tool returned:\n8",
                  shell_output("#{bin}/gatk CountReads -I count_reads.bam --tmp-dir #{testpath}").strip
  end
end
