# Bochs (with options)
This repository is a tap for [Homebrew](https://brew.sh) for [Bochs](https://bochs.sourceforge.io) with options. If all you need is a basic Bochs installation it is available in homebrew-core and this tap isn't needed.  

## How do I install Bohcs using this formula?
To install without options use:
`brew install victorzimmer/bochs/bochs-full`

To install using options use:
`brew install victorzimmer/bochs/bochs-full --with-debugger-gdb-stub --with-x11`

## What options are available for the formula?
| Option                   | Description                                                                          |
|--------------------------|--------------------------------------------------------------------------------------|
| --with-debugger-internal | Enables the Bochs internal debugger (this is the default for Bochs in homebrew-core) |
| --with-debugger-gdb-stub | Enables the Bochs GDB stub for debugging with GDB/LLDB                               |
| --without-sdl2           | Disables SDL2 display library                                                        |
| --with-sdl               | Disables SDL display library                                                         |
| --without-nogui          | Disables nogui display library                                                       |
| --with-x11               | Enables X display library                                                            |
| --with-carbon            | Enables Carbon display library                                                       |
| --without-term           | Disables Term display library                                                        |

If other options are needed feel fre to create an issue or fork.
