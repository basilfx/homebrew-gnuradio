require 'formula'

class GrBaz < Formula
  homepage 'http://wiki.spench.net/wiki/Gr-baz'
  head 'https://github.com/balint256/gr-baz.git', :branch => "master"

  depends_on 'cmake' => :build
  depends_on 'gnuradio'

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
