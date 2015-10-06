require 'formula'

class GrFosphor < Formula
  homepage 'http://sdr.osmocom.org/trac/wiki/fosphor'
  head 'git://git.osmocom.org/gr-fosphor', :shallow => false

  depends_on 'cmake' => :build
  depends_on 'gnuradio'
  depends_on 'librtlsdr'
  depends_on 'glfw3'

  def install
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args << "-DPYTHON_LIBRARY=#{python_path}/Frameworks/Python.framework/"
      system 'make'
      system 'make install'
    end
  end

  def python_path
    python = Formula.factory('python')
    kegs = python.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end
end
