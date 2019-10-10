class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/archive/v3.0.6.tar.gz"
  sha256 "fd2404a3df42390268e9fb804ef9f235e429b6f0da8992a148cbb3614946d99b"

  bottle do
    cellar :any
    sha256 "157441819058ccbb5ca028b55f1fb28f917f49bfe298a5656368565499715cf4" => :mojave
    sha256 "791780b56d00c1dbf11c907be3ee76412100f42299c4a21cd55a2226e679263f" => :high_sierra
    sha256 "09cd5f376db3ed6e3f894f56c563e1ebb96d7783208cd696635e95a53bff2303" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
