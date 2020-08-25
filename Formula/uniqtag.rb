class Uniqtag < Formula
  # cite Jackman_2015: "https://doi.org/10.1371/journal.pone.0128026"
  desc "Abbreviate strings to short unique identifiers"
  homepage "https://github.com/sjackman/uniqtag"
  url "https://github.com/sjackman/uniqtag/archive/1.0.tar.gz"
  sha256 "8ff0dd850c15ff3468707ae38a171deb6518866a699964a1aeeec9c90ded7313"
  license "MIT"
  head "https://github.com/sjackman/uniqtag.git"

  uses_from_macos "ruby"

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uniqtag --version 2>&1")
  end
end
