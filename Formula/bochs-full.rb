# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# Based on homebrew-core/bochs
# https://github.com/Homebrew/homebrew-core/blob/3da452e587aa6863865b1692e9ccb01d3f0befcf/Formula/b/bochs.rb

class BochsFull < Formula
  desc "Bochs - Cross Platform x86 Emulator Project"
  homepage ""https://bochs.sourceforge.io/
  license "LGPL-2.1 license"
  head "https://github.com/bochs-emu/Bochs"

  depends_on "pkg-config" => :build
  depends_on "libtool"

  option "with-debugger-internal", "Enables the Bochs internal debugger"
  option "with-debugger-gdb-stub", "Enables the Bochs GDB stub for debugging with GDB/LLDB"

  # SDL Display Library
  option "with-sdl", "Disables SDL display library"
  depends_on "sdl" => :optional

  # SDL2 Display Library
  option "without-sdl2", "Disables SDL2 display library"
  depends_on "sdl2" => :reccommended

  # nogui Display Library
  option "without-nogui", "Disables nogui display library"

  # X11 Display Library
  option "with-x11", "Enables X display library"
  depends_on "x11" => :optional

  # Carbon Display Library
  option "with-carbon", "Enables Carbon display library"

  # Term Display Library
  option "without-term", "Disables Term display library"

  uses_from_macos "ncurses"

    def install
      args = %W[
        --prefix=#{prefix}
        --disable-docbook
        --enable-a20-pin
        --enable-alignment-check
        --enable-all-optimizations
        --enable-avx
        --enable-evex
        --enable-cdrom
        --enable-clgd54xx
        --enable-cpu-level=6
        --enable-disasm
        --enable-fpu
        --enable-iodebug
        --enable-large-ramfile
        --enable-logging
        --enable-long-phy-address
        --enable-pci
        --enable-plugins
        --enable-readline
        --enable-show-ips
        --enable-usb
        --enable-vmx=2
        --enable-x86-64
      ]

      # Debug support
      if build.with?( 'debugger-internal' ) and build.with?( 'debugger-gdb-stub' )
          odie "Internal debugger and GDB stub are mutually exclusive!"
      end
      args << ( build.with?( 'debugger-internal' ) ? '--enable-debugger --enable-debugger-gui' : '')
      args << ( build.with?( 'debugger-gdb-stub' ) ? '--enable-gdb-stub' : '')

      # Display libraries
      args << ( build.with?( 'sdl' ) ? '--with-sdl' : '--without-sdl')
      args << ( build.without?( 'sdl2' ) ? '--without-sdl2' : '--with-sdl2')
      args << ( build.without?( 'nogui' ) ? '--without-nogui' : '--with-nogui')
      args << ( build.with?( 'x11' ) ? '--with-x11' : '--without-x11')
      args << ( build.with?( 'carbon' ) ? '--with-carbon' : '--without-carbon')
      args << ( build.without?( 'term' ) ? '--without-term' : '--with-term')


      system "./configure", *args

      system "make"
      system "make", "install"
    end

    test do
      require "open3"

      (testpath/"bochsrc.txt").write <<~EOS
        panic: action=fatal
        error: action=report
        info: action=ignore
        debug: action=ignore
        display_library: nogui
      EOS

      expected = <<~EOS
        Bochs is exiting with the following message:
        [BIOS  ] No bootable device.
      EOS

      command = "#{bin}/bochs -qf bochsrc.txt"

      # When the debugger is enabled, bochs will stop on a breakpoint early
      # during boot. We can pass in a command file to continue when it is hit.
      (testpath/"debugger.txt").write("c\n")
      command << " -rc debugger.txt"

      _, stderr, = Open3.capture3(command)
      assert_match(expected, stderr)
    end
  end
