class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easy-rpg.org/"
  url "https://github.com/EasyRPG/Player/archive/0.3.tar.gz"
  sha256 "5c1201a36c555d80b8f30af758b74e60314f0f35fe084fe785b39ead7e2eff49"
  head "https://github.com/EasyRPG/Player.git"

  bottle do
    cellar :any
    sha256 "f4b64852432ab4b694b51411a93708788c94b943bd2e61e74d0d0e4a5b9772af" => :yosemite
    sha256 "eabee1db9cb20db5fc091c77388e73b4ae2b7c2ceee24aebe38bc24a73c471bc" => :mavericks
    sha256 "a7e9b8c8df436ca437a521e905e7e13c0ace7595ddbdde430a72027795a0e2f1" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "sdl2_mixer" => "with-libvorbis"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/easyrpg-player", "-v"
  end
end
