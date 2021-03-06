class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.0.tar.xz"
  sha256 "3775ae0cfaa6dd8d886e5233c4826225cddcb88c99c2a08130d14e15fe58e378"
  revision 1
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "58eeb2b248a4f8c1a7767d8fe14100244523384597f8ac4b91fafc1a4a43361a" => :mojave
    sha256 "78fd255de2bf0386869a6608b47a08cd6cbaf2601f6c9e37f8b16d1e8d60a683" => :high_sierra
    sha256 "75e7f2f1bed7ebe2000d9baf3da8efd46cc8de19ac512d9aa7c0bcff01a8b673" => :sierra
    sha256 "38a407e797ca408b380494256a98e5939a4cbb86ed04ec73eeebae60f5139c61" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    system "make", "whois", *(OS.mac? ? "HAVE_ICONV=1" : "HAVE_ICONV=0")
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  def caveats; <<~EOS
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
  EOS
  end

  test do
    system "#{bin}/whois", "brew.sh" if Pathname.new("/etc/services").readable?
  end
end
