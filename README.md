
# LightningCrop
A small image cropping utility

## How do I use it?

Launch the program and you will be greeted by a window asking you to choose an image. Simply make a selection and accept. The program will load the image, resizing if it's too large, and you will be ready to start cropping.

## What is Processing? All I have is a .pde file and I can't run that

A Java-based, visual-focused program/language. You will need Java to run it and any programs you create.
See [here](https://processing.org/) for details and to download the IDE needed to write and build programs.

### I don't need to write anything, I just want to run this!

Alright, great. Open Processing and open the .pde file. You now have two options:

 1. Run the program once, using the play button at the top of the editor.
 2. Create an executable.
	 - File > Export Application (CTRL + SHIFT + E)
	 - Choose any platform you want to export to. Note that **OS X output is only available on a Mac**.
	 - Embed Java if you expect that your target machine will not have it installed

### Why don't you provide builds of the program?

I work on Linux. This means I can make good builds for Linux, *usually* good builds for Windows, and no builds for OS X.

 1. It isn't worth my time to build and test every release.
 2. I'd rather not be responsible for bad/missing builds.
 3. It's easy enough to build a copy yourself and you get a chance to look at the source code in the process.

## General
### What buttons do I need to know?

 - O: Load a new image
 - M: Next display mode
 - R: Toggle ratio display (ratio will not appear in output either way)
 - Q: Switch crop mode (Ratio or Free)
 - SPACE: Reset free crop without saving
 - ENTER: Confirm free crop
 - PLUS: Increase zoom [Experimental]
 - MINUS: Decrease zoom [Experimental]
 - LMB: Output cropped image from selection, drag to select/move free crop selection
 - SCROLL: Change ratio selection box size
 - CTRL + SCROLL: Change ratio selection ratio

----------

### I zoomed and the program crashed, wat do?
This is why this is experimental. Zooming is not done in a traditional way as the image loaded is set as a background, and Processing requires the background and window size be **exactly** the same. In order to make the feature *kinda* work, zooming increases the size of the window with the image. However, if the window becomes larger or smaller than the operating system can handle, it will crash the program. On Windows, this is very strict; it's much more flexible on Linux, but even still, if the window becomes larger than the display, it will crash the program. This is not something I can fix without rewriting most of the program, and at that point it isn't a simple program anymore.

**tl;dr**: This is how Processing works

----------

### The program crashed before I even saw my image displayed/before I even chose an image?
Another classic Processing problem, related to the zooming issue above. When processing starts, it needs a size for it to make it's main window, which can't be provided because it doesn't know how large the image will be. In order to make this work, the window uses a placeholder size, the image is loaded and then very quickly the window size is changed, before Processing realises what's happening. However, very rarely, it doesn't happen in time, and the program crashes.

#### OK, that's nice, how do I fix it?
Start the program and try again, it's a rare issue and shouldn't happen a second time.