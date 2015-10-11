require 'formula'

class RtlEntropy < Formula
  homepage 'https://github.com/pwarren/rtl-entropy'
  head 'https://github.com/pwarren/rtl-entropy.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'librtlsdr'
  depends_on 'openssl'

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index f74a266..c2e7fe5 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -81,9 +81,6 @@ find_package(PkgConfig)
 find_package(LibRTLSDR)
 find_package(LibbladeRF)
 find_package(OpenSSL)
-IF(NOT (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"))
-  find_package(LibCAP)
-ENDIF(NOT (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"))

 ########################################################################
 # Setup the include and linker paths
@@ -92,21 +89,11 @@ include_directories(
   ${OPENSSL_INCLUDE_DIRS}
   ${LIBRTLSDR_INCLUDE_DIRS}
 )
-IF(NOT (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"))
-  include_directories(
-    ${LibCAP_INCLUDE_DIR}
-  )
-ENDIF(NOT (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"))

 link_directories(
   ${OPENSSL_LIBRARIES}
   ${LIBRTLSDR_LIBRARIES}
 )
-IF(NOT (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"))
-  link_directories(
-    ${LibCAP_LIBRARY}
-  )
-ENDIF(NOT (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"))

 add_subdirectory(src)
