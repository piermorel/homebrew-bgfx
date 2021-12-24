# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Bgfx < Formula
  desc "bgfx - Cross-platform rendering library"
  homepage "https://github.com/bkaradzic/bgfx"
  head "https://github.com/bkaradzic/bgfx.git"
  # depends_on "cmake" => :build

  option "with-debug"
  
  resource "bx" do
    url "https://github.com/bkaradzic/bx.git"
  end
  resource "bimg" do
    url "https://github.com/bkaradzic/bimg.git"
  end
  
  
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    #system "./configure", "--disable-debug",
    #                      "--disable-dependency-tracking",
    #                      "--disable-silent-rules",
    #                      "--prefix=#{prefix}"
    
    #Move the bgfx download in a bgfx folder
    (buildpath/"bgfx").install Dir["*"]

    #Download bx and bimg
    (buildpath/"bx").install resource("bx")
    (buildpath/"bimg").install resource("bimg")
    
    arch=`uname -m`
    if build.with? "debug"
      args = "osx-#{arch}-debug"
      suffix = "Debug"
    else
      args = "osx-#{arch}-release"
      suffix = "Release"
    end
    
    cd "bgfx" do
      system "make"
      system "make",args
      
      
      cd ".build/osx-#{arch}/bin" do
        
        lib.mkpath
        #lib.install Dir["lib*"]
        lib.install ("libbgfx"+suffix+".a") => "libbgfx.a"
        lib.install ("libbgfx-shared-lib"+suffix+".dylib") => "libbgfx-shared-lib.dylib"
        lib.install ("libbimg_decode"+suffix+".a") => "libbimg_decode.a"
        lib.install ("libbimg_encode"+suffix+".a") => "libbimg_encode.a"
        lib.install ("libbimg"+suffix+".a") => "libbimg.a"
        lib.install ("libbx"+suffix+".a") => "libbx.a"
        
        bin.mkpath
        bin.install ("geometryc"+suffix) => "geometryc"
        bin.install ("shaderc"+suffix) => "shaderc"
        bin.install ("texturec"+suffix) => "texturec"
        bin.install ("texturev"+suffix) => "texturev"
      end
    end
    
    include.mkpath
    include.install Dir["bgfx/include/*"]
    include.install Dir["bimg/include/*"]
    include.install Dir["bx/include/*"]
    (include/"bgfx_shaders").install "bgfx/src/bgfx_compute.sh"
    (include/"bgfx_shaders").install "bgfx/src/bgfx_shader.sh"
    #(include/"bgfx_shaders").install "bgfx/examples/common/shaderlib.sh"
    
    share.mkpath
    (share/"bgfx/examples").install Dir["bgfx/examples/*"]
    (share/"bgfx/examples/runtime").install ("bgfx/.build/osx-#{arch}/bin/examples.app/Contents/MacOS/examples"+suffix) => "examples"
    (share/"bgfx/examples/").install ("bgfx/.build/osx-#{arch}/bin/libexample-common"+suffix+".a") => "libexample-common.a"
    (share/"bgfx/examples/").install ("bgfx/.build/osx-#{arch}/bin/libexample-glue"+suffix+".a") => "libexample-glue.a"
    
    (share/"bgfx/scripts").install Dir["bgfx/scripts/*"]

    # system "cmake", ".", *std_cmake_args
    #system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test bgfx`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
