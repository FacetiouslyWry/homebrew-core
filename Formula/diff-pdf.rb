class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision OS.mac? ? 37 : 38

  bottle do
    cellar :any
    sha256 "8322363fc36c11bce277aad6c458fea9dae9ed58ad93aec6e9338aa44ff749ba" => :mojave
    sha256 "23c8bd76dc02050c0efdcd0ab09bfeff7fc0e7f59d491830bd0f95945f2bf340" => :high_sierra
    sha256 "65cc0d1f0b47fdbb0d5fa96d8b6001a35612e9076b8e1bbfe00cfe3afbe24655" => :sierra
    sha256 "672755fb43c29d9428d339cc5cac5a2a801c5c156f71339b04f013adf03df94b" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11 if OS.mac?
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
