class AescryptPacketizer < Formula
  desc "Encrypt and decrypt using 256-bit AES encryption"
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.13.tgz"
  sha256 "87cd6f6e15828a93637aa44f6ee4f01bea372ccd02ecf1702903f655fbd139a8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0065041f51f313cc89745778c7063171ab021ac844c238a1186c5b4e35d88323" => :mojave
    sha256 "0bc56edb35949f38807c5e64895875f9177c732c1b97d65146fe0ccd18fba434" => :high_sierra
    sha256 "271379b01ad1868a2b9270e987911694391824beea2f53a54d95eb989027fb58" => :sierra
    sha256 "ac2b8b700cf68b582b30c1cc004198a62d19b42cec9f03fe5344ec2c7e7e93ad" => :x86_64_linux
  end

  head do
    url "https://github.com/paulej/AESCrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :xcode => :build if OS.mac?

  def install
    if build.head?
      cd "linux"
      system "autoreconf", "-ivf"
      system "./configure", "prefix=#{prefix}", *("--enable-iconv" if OS.mac?),
              "--disable-gui"
      system "make", "install"
    else
      cd "src" do
        # https://www.aescrypt.com/mac_aes_crypt.html
        inreplace "Makefile", "#LIBS=-liconv", "LIBS=-liconv" if OS.mac?
        system "make"

        bin.install "aescrypt"
        bin.install "aescrypt_keygen"
      end
      man1.install "man/aescrypt.1"
    end

    # To prevent conflict with our other aescrypt, rename the binaries.
    mv "#{bin}/aescrypt", "#{bin}/paescrypt"
    mv "#{bin}/aescrypt_keygen", "#{bin}/paescrypt_keygen"
  end

  def caveats; <<~EOS
    To avoid conflicting with our other AESCrypt package the binaries
    have been renamed paescrypt and paescrypt_keygen.
  EOS
  end

  test do
    aescrypt = bin/"#{build.without?("default-names") ? "p" : ""}aescrypt"
    path = testpath/"secret.txt"
    original_contents = "What grows when it eats, but dies when it drinks?"
    path.write original_contents

    system bin/"paescrypt", "-e", "-p", "fire", path
    assert_predicate testpath/"#{path}.aes", :exist?

    system aescrypt, "-d", "-p", "fire", "#{path}.aes"
    assert_equal original_contents, path.read
  end
end
