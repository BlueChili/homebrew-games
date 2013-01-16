require 'formula'

class Ninvaders < Formula
  homepage 'http://ninvaders.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ninvaders/ninvaders/0.1.1/ninvaders-0.1.1.tar.gz'
  sha1 '5ab825694b108cbfa988377ca216188fa9a76e89'

  def install
    ENV.j1 # this formula's build system can't parallelize
    inreplace 'Makefile' do |s|
      s.change_make_var! "CC", ENV.cc
    end
    system "make" # build the binary
    bin.install 'nInvaders'
  end
end
