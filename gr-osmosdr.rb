require 'formula'

class GrOsmosdr < Formula
  homepage 'http://sdr.osmocom.org/trac/wiki/GrOsmoSDR'
  head 'git://git.osmocom.org/gr-osmosdr', :branch => 'master',
    :shallow => false

  depends_on 'cmake' => :build
  depends_on 'gnuradio'
  depends_on 'librtlsdr'

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{gnuradio_path}/libexec/vendor/lib/python2.7/site-packages"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args << "-DPYTHON_LIBRARY=#{python_path}/Frameworks/Python.framework/"
      system "make"
      system "make", "install"
    end
  end

  def python_path
    python = Formula.factory('python')
    kegs = python.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end

  def gnuradio_path
    gnuradio = Formula.factory('gnuradio')
    kegs = gnuradio.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end
end
