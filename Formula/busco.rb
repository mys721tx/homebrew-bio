class Busco < Formula
  include Language::Python::Virtualenv

  # cite Seppey_2019: "https://doi.org/10.1007/978-1-4939-9173-0_14"
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/4.0.0/archive.tar.gz"
  sha256 "de1a6069ea660aee81dca4950b7f4203a42f074d7ef22e853765156fc75e649f"
  revision 1
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "26206163c9eee9a1db507c71efe29d29c51223fcf7ea9238f725d1c5c3066d75" => :catalina
    sha256 "9d9cf66b0c7d8b9992d4c35528be9f8076659c1650a731cf1db8a2ac461d5ab3" => :x86_64_linux
  end

  depends_on "augustus"
  depends_on "blast"
  depends_on "hmmer"
  depends_on "numpy"
  depends_on "prodigal"
  depends_on "python"
  depends_on "sepp"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/33/55/becf2b99556588d22b542f3412990bfc79b674e198d9bc58f7bbc333439e/biopython-1.75.tar.gz"
    sha256 "5060e4ef29c2bc214749733634051be5b8d11686c6590fa155c3443dcaa89906"
  end

  def install
    virtualenv_install_with_resources
    # Save the original config with options, etc.
    mv libexec/"config/config.ini", libexec/"config/config.default.ini"
    (libexec/"config/config.ini").write <<~EOS
      [busco_run]
      [tblastn]
      path = #{Formula["blast"].bin}
      command = tblastn
      [makeblastdb]
      path = #{Formula["blast"].bin}
      command = makeblastdb
      [augustus]
      path = #{Formula["augustus"].bin}
      command = augustus
      [etraining]
      path = #{Formula["augustus"].bin}
      command = etraining
      [gff2gbSmallDNA.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      command = gff2gbSmallDNA.pl
      [new_species.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      command = new_species.pl
      [optimize_augustus.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      command = optimize_augustus.pl
      [hmmsearch]
      path = #{Formula["hmmer"].bin}
      command = hmmsearch
      [sepp]
      path = #{Formula["sepp"].bin}
      command = run_sepp.py
      [prodigal]
      path = #{Formula["prodigal"].bin}
      command = prodigal
    EOS
  end

  def caveats; <<~EOS
    R must be installed to generate graphs.
      brew install r
    #{"Or:\n  brew cask install r" if OS.mac?}
  EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/busco --help")
  end
end
