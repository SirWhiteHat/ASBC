******
******
README
******
******

**********************
TL;DR, IT DOESN’T WORK
**********************

Common problems:

THERE ARE NO AUDIO FILES INCLUDED due to copyright reasons. Place 5 audio files named “Audio1.mp3”, “Audio2.mp3” through to “Audio5.mp3” to use the demo, or “0short.mp3” through “4short.mp3” in “Listening Tests” to try the listening tests. The song titles that remain in the UI are from my own test files :)

You may have to build the “Library/UATC” project before the other projects will build, depending on your version of Xcode or compiler. If in doubt, just know that the output of the “Library/UATC.xcodeproj” should be linked in with anything that includes UATC.h.

********
Overview
********

Thanks for downloading! Firstly, throughout the repository you will find references to ‘UATC’. This is an old name for the project, and it was deemed safer to keep the code so named for now, as there are lot of hidden references dotted about.

The most interesting part (IMO) resides in the MATLAB folder, the contents of which consists the majority of the AES paper. Run ‘UATCDemo.m’ to get a feel for how the model works, and ‘RenderUATC’ to write coefficients to a C++ file that can be read by the projects in either the “Demo” or “Listening Tests” projects.