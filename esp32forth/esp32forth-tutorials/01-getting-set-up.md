---
title: Tammy's ESP32Forth Tutorial - 01 Getting Set Up
author: Tammy Cravit <tammymakesthings@gmail.com>
---

# Tammy's ESP32Forth Tutorial
## Tutorial 01 - Getting Set Up

### Introduction

This tutorial series will chronicle my early steps with ESP32Forth.
ESP32Forth is a Forth language interpreter for the Espressif ESP-32
microcontroller. It includes the ability to manipulate the hardware,
and an HTTP-based Forth environment you can access via a browser.

In this first tutorial, you'll learn how to get ESP32Forth set up on
your microcontroller and make sure things are set up for your 
explorations. In subsequent tutorials, we'll explore all the things
you can do with ESP32Forth on your microcontroller.

### What is Forth? Why use Forth?

[Forth][forth] is a procedural, stack-oriented programming language 
first developed in 1970 by [Charles H. "Chuck" Moore][moore].
Forth is a lightweight language that combines a development
environment --- a command shell (and sometimes an editor and other
tools --- into a very small, very efficient system that can run with
very limited memory and storage.

The [Philae spacecraft][philae], for example, is powered by a pair of
Harris [RTX2010][rtx2010] processors, which supports direct execution
of Forth code. The [Open Firmware][openfw] boot ROMs used by Apple, 
IBM, and others, and the Sun Microsystems [OpenBoot][openboot] firmware
on which they were based, use a Forth interpreter. So do many other
embedded systems and other applications.

Some of the advantages of Forth include:

- Forth is a relatively simple and lightweight language to implement,
  and can run on very limited/constrained hardware.
  
- Forth is standardized and has been implemented on a wide array of
  hardware. 
  
- Forth is very efficient. Some implementations compile Forth code 
  directly to native machine language, or to a bytecode which can be
  executed efficiently.
  
- Forth programs consist of "words", which are similar to subroutines
  or functions. However, in a Forth system, words can be redefined or
  modified, tested, and debugged while the Forth system is running.
  
These advantages make Forth ideal for the sorts of applications for
which we use microcontrollers. For these tutorials, we'll use ESP32Forth,
a capable and well-maintained Forth implementation for the ESP32
microcontrollers. I've chosen [ESP32Forth][esp32forth] because of its 
support for the I/O functions commonly needed in microcontroller 
programs, and for the fact that many [ESP32][esp32] microcontroller 
boards support Wi-Fi, which enables the use of the browser-based 
ESP32Forth environment.

The [Forth Standard][forthstd], and the older [ANSI X3.215-1994][dpans94]
standard (PDF) document the standard behavior of Forth systems. Within
these standards, many things are left to the implementors of each 
individual Forth system. The specific implementation details of 
[ESP32Forth][esp32forth], including the specific words ESP32Forth
implements to control hardware, are documented on the 
[ESP32Forth web site][esp32forth].

### Getting Set Up

Before we can start working with ESP32Forth, we'll need to get the
[ESP32Forth][esp32forth] environment set up on our microcontroller.

#### What You'll Need

In order to follow along with this tutorial, you'll need:

- An [ESP32][esp32] development board. I'm using the 
  [Heltec WIFI ESP32][heltec] development board, which combines an
  ESP32 processor with an 0.96 inch (24mm) OLED display. (We'll 
  learn more about the display in a future tutorial). 

- The [ESP32Forth][esp32forth] source distribution.

- The [Arduino Development Environment][arduino]. We'll use this to
  build and flash the source code, and we'll use the Serial Monitor
  to interact with the [ESP32Forth][esp32forth] environment until we
  get the HTTP interface set up.
  
Ready? Let's get started.
  
#### Downloading the Pieces

To begin with, you'll need to download the 
[Arduino Development Environment][arduino] and get it set up for 
your system. You'll also need to download the [ESP32Forth][esp32forth]
source distribution, which we'll build in the next step. This tutorial
assumes you have a UNIX-like environment on your computer, so Windows
users may want to install [WSL][wsl] and work in that environment.

#### Building ESP32Forth

To build [ESP32Forth][esp32forth], perform the following steps:

1. Using Git, clone the [source code][esp32forth] repository. From the 
   command line, `git clone https://github.com/flagxor/eforth` will do
   the job.
2. Change directory to the `eforth/ueforth` directory.
3. Edit the Makefile if neeeded. On a MacBookPro running macOS 11, I
   had to make these changes:
     - Remove the following options from the `CFLAGS_MINIMIZE` variable:
       - `-fno-ident -Wl,--build-id=none`
     - Remove the following options from the `CFLAGS` variable:
       - `-Wall`
       - `-Werror`
       - `-no-pie`
       - `-Wl,--gc-sections`
     - Remove _all_ of the options from `STRIP_ARGS` except for `-S`
   On a Linux system, the Makefile should work without modification.
4. Make sure you have [NodeJS][nodejs] in your path. The Makefile
   expects to be able to run the command `nodejs`; if your NodeJS
   binary is named something different, you'll need to modify the
   Makefile as appropriate.
5. Issue the `make` command. This will build Windows (if you're on 
   a Windows system), POSIX, and ESP32 versions of the ESP32Forth 
   system.
   
If everything succeeds, you'll find a file called `ESP32Forth.ino` in the
`out/esp32/ESP32Forth` subdirectory of your source tree. In the next 
section, we'll compile this file and use it to flash our ESP32 board.

#### Flashing Your Board

The `out/esp/ESP32Forth/ESP32Forth.ino` file created in the previous
section is an Arduino IDE "sketch" --- essentially, a C++ program with some
behind-the-scenes stuff supplied by the Arduino IDE. To build this
program and flash your board, perform the following steps:

1. Open the `out/esp/ESP32Forth/ESP32Forth.ino` file in the Arduino 
   IDE.
2. Add the ESP32 board support to your Arduino IDE:
   - Open the Arduino IDE preferences from the menu bar.
   - Click the button beside **Additional Board Manager URLs**
   - Add the following URL to the list:
     `https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/packages_esp32_dev_index.json`
   - Click OK to close the Board Manager URLs dialog box.
   - Click OK to close the Preferences dialog box.
   - From the menu bar, choose **Tools > Board: XXX: Boards Manager**. The
     XXX will be whatever board is currently selected in your Arduino
     IDE.
   - In the Boards Manager dialog, search for esp32. Select the `esp32`
     board support package, choose the latest version from the dropdown,
     and click "Install". This will take a few minutes, but will install
     the board definitions and compiler toolchain. 
3. Connect your ESP32 board to your computer with a MicroUSB cable.
4. Tell the Arduino IDE about your board:
   - From the **Tools > Board** menu, choose the development board you're
     using. If you're following along with me, this will be
     "ESP32 Arduino > Heltec WiFi Kit 32", but you should choose the
     board which matches the one you're using.
   - From the "**Tools > Port" menu, choose the serial port for your
     board. On my MacBook Pro, this is "/dev/cu.usbserial-0001", but 
     you'll have to find it for your system.
   - Leave all the other board settings at their defaults.
5. From the menu bar, choose **Sketch > Verify/Compile**. This will 
   compile the code. When we go to upload it to the board, the Arduino
   IDE will re-compile it, but this is a quick check to make sure 
   everything is working.
6. From the menu bar, choose **Sketch > Upload**. This will recompile the
   sketch and also upload it to your board.
7. From the menu bar, choose "**Tools > Serial Monitor* to open the Serial Monitor.
   We'll use this to interact with the ESP32Forth system while we get
   the browser-based interface configured.
9. In the Serial Monitor window, click the **XXX** button to clear the
   monitor.
9. Press the reset button on your board. You should see a message like this
   in the Serial Monitor window:
   
   ```
   ESP32forth v7.0.6.6 - rev [ssa hash]
   ok
   -->
   ```

If not 
#### Making Sure It Works

To make sure you can interact with the ESP32Forth system, type the 
following into the Serial Monitor window's input field:

```forth
2 3 + 5 * .s
```

Then click the Send button. You should see `<1> 25` in the Serial 
Monitor window.

Something important to notice here is that, as mentioned above, Forth
is a stack-based language. You pass "parameters" by pushing them onto 
the stack, and program words "pop" things off of the stack and then "push"
their results back onto the stack. 

It's common for Forth programmers to include comments in their word 
definitions showing the operands expected to be on the stack, and the 
results the word leaves on the stack. For example, the stack diagram 
comment for the `+` word might look like:

```forth
( a b -- a+b )
```

The final word we invoked in our sample above was `.s`. This word displays
the contents of the stack. The number in the triangular braces is the
current stack depth (i.e., the number of items on the stack). If there's
nothing on the stack, the output of `.s` will be `<0>'.

After each word executes, you'll see ESP32Forth print the word `ok`. This
tells you the Forth system is waiting for your next command.

If you've gotten this far, it's time to configure your board's Wi-Fi
settings and enable the ESP32Forth browser interface. Leave the Arduino
Serial Monitor open, because we'll need it in the next step.

#### Enabling Wi-Fi and the ESP32Forth Browser Interface

As mentioned above, [ESP32Forth] provides facilities to interact with the
hardware on, and attached to, your [ESP32 board][heltec]. We're going to 
use those facilities to enable your board's Wi-Fi interface and the 
browser-based Forth environment provided by [ESP32Forth][esp32forth].

Type the following into the Serial Monitor's input field, substituting
your Wi-Fi network's SSID and password:

```forth
z" NETWORK-SSID" z" NETWORK-PASSWORD" webui
```

A couple important things to note here:

- There needs to be a space between the start of the null-terminated strings
  (the `z"` word) and the parameter, but there needs to **not** be a space 
  before the closing `"` character. `z"` is a special kind of Forth word 
  called a *defining word*. It basically says to the Forth system, "the 
  next token, up to the closing quote mark, should be interpreted as a
  null-terminated string and not a Forth word". The reason there needs to be
  a space before it is to make it a separate token from the `z"` token.
- We're putting two null-terminated strings onto the stack, and then invoking
  the `webui` word. The stack diagram of this operation looks like this:
  
  `( network-z password-z -- )`
  
  The `-z` naming convention is an [ESP32Forth][esp32forth] convention
  indicating that the string is null-terminated. Many Forth systems also have
  Pascal-style strings (which encode the string length into the string). These
  are defined similarly, using an `s"` defining word.
  
If all goes well here, you'll receive a message from ESP32Forth like this:

```
192.168.1.10
MDNS started
Listening on port 80
```

You should be able to open that address (or the mDNS URL `http://forth/`) in 
your Web browser and interact with the Forth system, just as you did from 
the Serial Monitor.

#### Making Your Configuration Persistent

Because your Forth system is loaded from Flash storage, when you unplug or
reset your [ESP32][esp32], all the changes you've made and the words you've
defined are lost. (They just live in RAM). Fortunately, the [ESP32][esp32]
provides fairly plentiful Flash storage and we can save things to files. We
can also load files and execute their contents.

When [ESP32Forth][esp32forth] starts up, two of the things it does are:

1. Attach the ESP32's flash storage at the path `/spiffs` (SPI Flash File 
   Storage).
2. Look for a file called `/spiffs/autoexec.fs` and, if found, execute its
   contents.
   
We can use this to automatically start the WebUI when the board resets. To
do this, we're going to execute two sets of commands. I assume by now you know
how to execute commands in the Serial Monitor, so from here forward I'll just 
talk about the commands you need to execute.

The command we're going to run looks like this

```forth
r| z" NETWORK-SSID" z" NETWORK-PASSWORD" webui | s" /spiffs/autoexec.fs" dump-file
```

Let's look at what's happening here:

The first part of this command is:

```forth
r| z" NETWORK-SSID" z" NETWORK-PASSWORD" webui |
```

`r|` is another defining word, though this one is [ESP32Forth][esp32forth] specific.
It creates a "raw string", which exists for the duration of the current command but
does not consume heap memory. The raw string is ended by the `|` token. So, the first
thing we do is put a raw string onto the stack which contains our Wi-Fi setup and 
`webui` call.

We next put another string onto the stack. This one is a standard counted string,
and it contains the name of the file we're going to write to. In this case, the
file will be named `/spiffs/autoexec.fs`.

At this point, the stack looks like this:

```forth
( contents-str contents-len filename-str filename-len -- )
```

Notice that each string actually consists of two elements: The string's contents
(actually, a pointer to the location in memory where the string starts), and the
length of the string. If you put a `.s` call before the `dump-file` in our command,
you'd see a result something like this (depending on the length of your SSID and
password):

```
[4] 1073650315 58 1073709188 20
```

Finally, we call the `dump-file` word, which writes the first string into the file
named by the second string.

Leave the Serial Monitor open and hit your board's reset button. When the board
resets, you should see the message with the WebUI URL. Go to that URL and make sure
the browser-based UI is accessible.

You might be wondering how to remove the `autoexec.fs` file if you need to change
the Wi-Fi credentials. The answer depends on whether you have access to the 
browser-based UI. 

If you do, you can remove the `autoexec.fs` file by giving this command:

```forth
s" /spiffs/autoexec.fs" delete-file
```

Then you can create a new `autoexec.fs` file, or reset your board and interact with
[ESP32Forth][esp32forth] from the Serial Monitor interface.

If you **don't** have access to the browser-based interface (for example, if
your network credentials are incorrect), the process is a bit more complicated. 
Here's what you need to do:

1. Open the `ESP32Forth.ino` sketch in the Arduino IDE.
2. Search for the line which refers to `autoexec.fs`, and change the file name
   to something else.
3. Build and flash the new sketch.
4. Reset your board.
5. Connect via the Serial Monitor, and give the `delete-file` command as shown
   above.
6. Edit the `ESP32Forth.ino` sketch again. Change the startup filename back to 
   `autoexec.fs`. Rebuild and reflash.
   
#### Next Steps

Congratulations! You've learned a bit about Forth and gotten 
[ESP32Forth][esp32forth] up and running on your [development board][heltec].
In the next tutorial, we'll start to look at how we can build useful
programs for our microcontroller using Forth!

--- 
[forth]:        https://en.wikipedia.org/wiki/Forth_(programming_language
[moore]:        https://en.wikipedia.org/wiki/Charles_H._Moore
[philae]:       https://en.wikipedia.org/wiki/Philae_(spacecraft)
[rtx2010]:      https://en.wikipedia.org/wiki/RTX2010
[openfw]:       https://en.wikipedia.org/wiki/Open_Firmware
[openboot]:     https://www.openfirmware.info/OpenBOOT
[esp32]:        https://www.espressif.com/en/products/modules/esp32
[esp32forth]:   https://esp32forth.appspot.com/ESP32forth.html
[heltec]:       https://www.aliexpress.com/item/32835496547.html
[arduino]:      https://www.arduino.cc/en/Guide
[wsl]:          https://docs.microsoft.com/en-us/windows/wsl/about
[forthstd]:     https://forth-standard.org/
[dpans94]:      http://dl.forth.com/sitedocs/dpans94.pdf
