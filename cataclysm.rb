class Cataclysm < Formula
  homepage 'http://www.cataclysmdda.com/'
  url 'https://github.com/CleverRaven/Cataclysm-DDA/archive/0.C.tar.gz'
  sha1 '37e317a75e7bf7e3425da86382551958d890e872'
  version '0.C'

  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    sha256 "d238e5fa398e9dba4b807108a5885025185f91269128b47690ce8422c7cd6d44" => :yosemite
    sha256 "2d8ab27ec069acecb344bfa2ab57f346352650de1877767dcb220af7129ae879" => :mavericks
    sha256 "b65caa16de5a82ef49ce723e2d8e9be800ee88fc5f8f22ad7c349518054b0ced" => :mountain_lion
  end

  needs :cxx11

  depends_on "gettext"
  # needs `set_escdelay`, which isn't present in system ncurses before 10.6
  depends_on "homebrew/dupes/ncurses" if MacOS.version < :snow_leopard

  option "with-tiles", "Enable tileset support"

  if build.with? "tiles"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_ttf"
  end

  def install
    ENV.cxx11

    # cataclysm tries to #import <curses.h>, but Homebrew ncurses installs no
    # top-level headers
    ENV.append_to_cflags "-I#{Formula['ncurses'].include}/ncursesw" if MacOS.version < :snow_leopard

    args = %W[
      NATIVE=osx RELEASE=1
      CXX=#{ENV.cxx} LD=#{ENV.cxx} CXXFLAGS=#{[ENV.cxxflags, ENV.cppflags].join(" ")}
    ]

    args << "TILES=1" if build.with? "tiles"
    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    # no make install, so we have to do it ourselves
    if build.with? "tiles"
      libexec.install "cataclysm-tiles", "data", "gfx"
    else
      libexec.install "cataclysm", "data"
    end

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! 'DIR', libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end
end
