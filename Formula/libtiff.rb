class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.10.tar.gz"
  sha256 "2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"

  bottle do
    cellar :any
    sha256 "9fc324e360e2b5fe46ce13bd97bc1a338cf08c8d60dca4241bcc8c2efcadb99a" => :mojave
    sha256 "59a22ff44e382d59b062a0cd03336f0ec4b8846a3eb8b1ca777150ca703dd0cd" => :high_sierra
    sha256 "57c7e27e610ed62652678ccc9162dc27c5cc197aab4d16e0ea425acf8f33bb17" => :sierra
    sha256 "4249b949ad551f16f7fcba0f0a32e61254045a806d2f966d7df6fd0837caef8d" => :x86_64_linux
  end

  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional
  depends_on "zlib" unless OS.mac?

  # Patches are taken from latest Fedora package, which is currently
  # libtiff-4.0.10-1.fc30.src.rpm and whose changelog is available at
  # https://apps.fedoraproject.org/packages/libtiff/changelog/

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
    ]
    if build.with? "xz"
      args << "--with-lzma-include-dir=#{Formula["xz"].opt_include}"
      args << "--with-lzma-lib-dir=#{Formula["xz"].opt_lib}"
    else
      args << "--disable-lzma"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
