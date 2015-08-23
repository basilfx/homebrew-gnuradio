require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
# from: https://github.com/xlfe/homebrew-gnuradio

class Gqrx < Formula
  homepage 'https://github.com/csete/gqrx'
  head 'https://github.com/csete/gqrx.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'qt'
#brew install --with-c+11 --universal boost
  depends_on 'boost'
  depends_on 'gnuradio'

  def patches
    #patch to compile to binary, comment out pulse audio and link boost correctly
    DATA
  end

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
@@ -11,17 +11,13 @@ contains(QT_MAJOR_VERSION,5) {
 
 TEMPLATE = app
 
-macx {
-    TARGET = Gqrx
-    ICON = icons/scope.icns
-    DEFINES += GQRX_OS_MACX
-} else {
-    TARGET = gqrx
-}
+
+TARGET = gqrx
+
 
 linux-g++|linux-g++-64 {
     # Comment out to use gr-audio (gr 3.6.5.1 or later recommended)
-    AUDIO_BACKEND = pulse
+    #AUDIO_BACKEND = pulse
 }
 
 RESOURCES += icons.qrc
@@ -155,28 +151,19 @@ contains(AUDIO_BACKEND, pulse): {
 
 # dependencies via pkg-config
 # FIXME: check for version?
-unix {
-    CONFIG += link_pkgconfig
-
-    contains(AUDIO_BACKEND, pulse): {
-        PKGCONFIG += libpulse libpulse-simple
-    } else {
-        PKGCONFIG += gnuradio-audio
-    }
-    PKGCONFIG += gnuradio-core gnuradio-osmosdr
-}
 
 unix:!macx {
     LIBS += -lboost_system -lboost_program_options
     LIBS += -lrt  # need to include on some distros
 }
 
-macx-g++ {
-     LIBS += -lboost_system-mt -lboost_program_options-mt
-#    INCLUDEPATH += /usr/local/include
-#    INCLUDEPATH += /usr/local/include/gnuradio
-#    INCLUDEPATH += /usr/local/include/osmosdr
-#    INCLUDEPATH += /opt/local/include
+macx {
+     LIBS += -lboost_system-mt -lboost_program_options-mt -lgnuradio-audio -lgnuradio-core -lgnuradio-osmosdr -lgruel
+     LIBPATH += /usr/loca/lib
+     INCLUDEPATH += /usr/local/include
+     INCLUDEPATH += /usr/local/include/gnuradio
+     INCLUDEPATH += /usr/local/include/osmosdr
+     INCLUDEPATH += /opt/local/include
 }
 
 OTHER_FILES += \diff --git a/dsp/rx_agc_xx.cpp b/dsp/rx_agc_xx.cpp
index 0b2ce61..2157266 100644
--- a/dsp/rx_agc_xx.cpp
+++ b/dsp/rx_agc_xx.cpp
@@ -83,8 +83,7 @@ int rx_agc_cc::work(int noutput_items,
     d_agc->ProcessData(noutput_items, &ib[0], &ob[0]);
 
     for (i = 0; i < noutput_items; i++) {
-        out[i].real() = ob[i].re;
-        out[i].imag() = ob[i].im;
+        out[i] = gr_complex(ob[i].re, ob[i].im);
     }
 
     return noutput_items;
diff --git a/dsp/rx_noise_blanker_cc.cpp b/dsp/rx_noise_blanker_cc.cpp
index f52ffa3..cbdc9c6 100644
--- a/dsp/rx_noise_blanker_cc.cpp
+++ b/dsp/rx_noise_blanker_cc.cpp
@@ -74,8 +74,7 @@ int rx_nb_cc::work(int noutput_items,
     // copy data into output buffer then perform the processing on that buffer
     for (i = 0; i < noutput_items; i++)
     {
-        out[i].imag() = in[i].imag();
-        out[i].real() = in[i].real();
+        out[i] = in[i];
     }
 
     if (d_nb1_on)
diff --git a/applications/gqrx/receiver.cpp b/applications/gqrx/receiver.cpp
index c856fb7..1d7700b 100644
--- a/applications/gqrx/receiver.cpp
+++ b/applications/gqrx/receiver.cpp
@@ -173,7 +173,7 @@ void receiver::set_input_device(const std::string device)
 /*! \brief Select new audio output device. */
 void receiver::set_output_device(const std::string device)
 {
-    if (output_devstr.compare(device) == 0)
+    if (false && output_devstr.compare(device) == 0)
     {
 #ifndef QT_NO_DEBUG_OUTPUT
         std::cout << "No change in output device:" << std::endl
