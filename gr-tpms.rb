require 'formula'

class GrTpms < Formula
  homepage 'https://github.com/jboone/gr-tpms'
  head 'https://github.com/jboone/gr-tpms.git', :branch => "master"

  depends_on 'cmake' => :build
  depends_on 'gnuradio'
  depends_on 'librtlsdr'
  depends_on 'fftw'

  patch :DATA
  
  resource "crcmod" do
    url "https://pypi.python.org/packages/source/c/crcmod/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin" if build.with? "documentation"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    
    res = %w[crcmod]
    
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
      
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args << "-DPYTHON_LIBRARY=#{python_path}/Frameworks/Python.framework/"
      system 'make'
      system 'make install'
    end
    
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def python_path
    python = Formula.factory('python')
    kegs = python.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end
end

__END__
diff --git a/lib/burst_detector_impl.cc b/lib/burst_detector_impl.cc
index 2b72a9c..3b7b7d8 100644
--- a/lib/burst_detector_impl.cc
+++ b/lib/burst_detector_impl.cc
@@ -69,13 +69,13 @@ namespace gr {
       d_hysteresis_count = 0;

       d_fft_window = (float*)volk_malloc(d_block_size * sizeof(float), 256);
-      assert((d_fft_window & 0xff) == 0);
+      //assert((d_fft_window & 0xff) == 0);

       std::vector<float> window = fft::window::hanning(d_block_size);
       std::copy(window.begin(), window.end(), d_fft_window);

       d_temp_f = (float*)volk_malloc(d_block_size * sizeof(float), 256);
-      assert((d_temp_f * 0xff) == 0);
+      //assert((d_temp_f * 0xff) == 0);

       d_fft_in = (gr_complex*)fftwf_malloc(sizeof(gr_complex) * d_block_size);
       d_fft_out = (gr_complex*)fftwf_malloc(sizeof(gr_complex) * d_block_size);