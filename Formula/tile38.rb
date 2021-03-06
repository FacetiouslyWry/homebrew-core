class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38/archive/1.14.4.tar.gz"
  sha256 "6db298c81b4df478f7edbc31f953d70fde7266c04b84c1ab0f08fa90bef68bb7"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c634695e5842b912aac7eaed86e9c1308fae922696197f5b7899ba774b6f2699" => :mojave
    sha256 "0a29163df762fe5b6ce6d4ae6fae53da15838ed6bf1266fe9c156da9b1242d25" => :high_sierra
    sha256 "c24d7322257af32c2488cc3a8d4bdfddbc513538e13b92f35ac90be6577dc8f9" => :sierra
    sha256 "0cb8371d9a3eb22b0468975c7a3ca7f760c1fa9f30ae696feab4571ae45107f5" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "make"

    bin.install "tile38-cli", "tile38-server"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats; <<~EOS
    To connect: tile38-cli
  EOS
  end

  plist_options :manual => "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/tile38-server</string>
          <string>-d</string>
          <string>#{datadir}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tile38.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tile38.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"tile38-cli", "-h"
  end
end
