class DwarfFortress < Formula
  desc "Open-ended rogelike game"
  homepage "http://bay12games.com/dwarves/"
  version "0.42.02"
  url "http://www.bay12games.com/dwarves/df_#{version.sub(%r{^0+\.},'').gsub('.','_')}_osx.tar.bz2"
  sha256 "653837ed073ffe2825d25bc80f0967d6a8ccb9bf869a188d4bd4320154630936"

  depends_on :x11

  def install
    # Dwarf Fortress uses freetype from X11, but hardcodes a path that
    # isn't installed by modern XQuartz. Point it at wherever XQuartz
    # happens to be on the user's system.
    system "install_name_tool", "-change",
                                "/usr/X11/lib/libfreetype.6.dylib",
                                "#{MacOS::XQuartz.prefix}/lib/libfreetype.6.dylib",
                                "libs/SDL_ttf.framework/SDL_ttf"

    (bin/"dwarffortress").write <<-EOS.undent
      #!/bin/sh
      exec #{libexec}/df
    EOS
    rm_rf "sdl" # only contains a readme
    libexec.install Dir["*"]
  end

  def caveats; <<-EOS.undent
      If you're using a retina display, the PRINT_MODE should
      be changed to STANDARD in #{libexec}/data/init/init.txt
    EOS
  end
end
