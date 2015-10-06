require 'formula'

class Gqrx < Formula
  homepage 'https://github.com/csete/gqrx'
  head 'https://github.com/csete/gqrx.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'gnuradio'
  depends_on 'gr-osmosdr'

  patch :DATA

  def install
    system "qmake -set PKG_CONFIG /usr/local/bin/pkg-config"
    system "qmake -query"
    system "qmake gqrx.pro"
    system "make"
    bin.install 'gqrx.app/Contents/MacOS/gqrx'
  end
end

__END__

diff --git a/gqrx.pro b/gqrx.pro
index 2571518..5e9c600 100644
--- a/gqrx.pro
+++ b/gqrx.pro
@@ -233,7 +233,12 @@
 }

 macx {
-    LIBS += -lboost_system-mt -lboost_program_options-mt
+    LIBS += -lboost_system-mt -lboost_program_options-mt -lgnuradio-audio -lgnuradio-runtime -lgnuradio-osmosdr
+    QMAKE_LIBDIR += /usr/local/lib
+    INCLUDEPATH += /usr/local/include
+    INCLUDEPATH += /usr/local/include/gnuradio
+    INCLUDEPATH += /usr/local/include/osmosdr
+    INCLUDEPATH += /opt/local/include
 }

 OTHER_FILES += \
