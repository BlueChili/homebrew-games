class Stormlib < Formula
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.10.tar.gz"
  sha256 "c3aca98b5a95649dfb2110eaf475eb6dd87119db62c3564f8b09b3d1d1f63f96"

  head "https://github.com/ladislav-zezula/StormLib.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-games"
    cellar :any
    sha256 "21dc183f56bd9652902191f6926a2742941434d8857c6647a4e1f0ddfef83a0a" => :yosemite
    sha256 "c3c8c3ac7ac27f8ab04a33d56cabc8f2c6b30f30d23099c0fd45b1068e952021" => :mavericks
    sha256 "e9c78128750bf0982d4296a94c396a6f16af923a2754d619f9e9229159e92a8f" => :mountain_lion
  end

  depends_on "cmake" => :build

  # prevents cmake from trying to write to /Library/Frameworks/
  patch :DATA

  def install
    system "cmake", "CMakeLists.txt", "-DWITH_STATIC=YES", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <StormLib.h>

      int main(int argc, char *argv[]) {
        printf("%s", STORMLIB_VERSION_STRING);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c"
    system "./test", "-v"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3b22069..03ed2c6 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -288,7 +288,6 @@ if(WITH_STATIC)
 endif()

 if(APPLE)
-    set_target_properties(storm PROPERTIES FRAMEWORK true)
     set_target_properties(storm PROPERTIES PUBLIC_HEADER "src/StormLib.h src/StormPort.h")
     set_target_properties(storm PROPERTIES LINK_FLAGS "-framework Carbon")
 endif()
