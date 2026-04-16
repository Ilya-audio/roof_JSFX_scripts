Hi everyone!
I'm a mixing engineer. In late 2025, I moved from Russia to Serbia, where I planned to build my new home studio. As is often the case, construction got delayed, and I was forced to switch to monitoring exclusively on headphones. Honestly, I’ve never been a fan of that idea, but I had no choice. Working "raw" in headphones felt impossible for me, so I started looking for a solution.
I own a license for Realphones, but I really wanted a native Linux solution. Ultimately, I took the algorithms that worked best for me, combined them into a single JSFX plugin, and added the specific features I needed for my daily workflow.
Here is the result:

<img width="1280" height="698" alt="GUI_ad" src="https://github.com/user-attachments/assets/b9e102aa-4416-4a51-a16f-ff310ec171f9" />

The plugin consists of three main modules:
1. Speaker Emulation Module
Allows you to quickly check your mix across various sound sources:
    • Main Monitors – Transparent mode with no processing. This is the primary mode for mixing.
    • Cubes – Emulation of the famous Auratone "mix cubes."
    • Vinyl – A faithful recreation of the mode found in AirWindows Monitoring 3.
    • Smartphone – Mobile speaker simulation (based on Monitoring 3).
    • SLEW – (The mysterious device on the right side of the desk) A detector for "fast" events in the mix. Great for identifying transient-related issues.
    • Subwoofer – A recreation of the Monitoring 3 mode for checking low-end conflicts.
    • Fullrange – A custom mode I built by combining modes 1 and 6. It mimics the feel of home theaters or club systems.
2. Headphone Correction Block
The plugin utilizes profiles from the AutoEQ project (though you are free to use your own measurements).
3. True-Stereo Block
Based on the well-known BS2B project, but with one significant modification. The original author of BS2B intentionally omitted a delay for the crossfeed signal. I have added an ITD (Interaural Time Difference) parameter, which significantly improves the naturalness and perceived width of the stereo image.
Note: This module is active only for the following modes: Main, Cubes, Vinyl, and Fullrange.

How to set it up:
To install the plugin, download the latest release from the following page: https://github.com/Ilya-audio/roof_JSFX_scripts/releases Extract the contents into your Reaper Resource Path.
But don't rush to run it just yet — there are a few steps required to make everything work perfectly:

    1. Go to autoeq.app.
    2. Find your headphone model in the database.
    3. In the Select Equalizer App dropdown, choose: Custom Parametric EQ.
    4. Adjust the number of "useful" filters using the Add Filter button. AutoEQ defaults to 5, but there are often more useful filters available—check and see!
    5. Download the profile and place the .txt file into: *reaper resource folder*/Data/roof_control/phones_eq.
    6. Important Step: Go to the "Actions" menu, then add and run the roof_bubrik.lua satellite script. Since JSFX has limited file-handling capabilities, the plugin relies on this script as its backend. Without it, the plugin won't be able to detect your profiles. If you use SWS, I highly recommend adding roof_bubrik to your REAPER startup actions.
    7. Now you can load the plugin (JS: roof_control). I strongly suggest placing it in the Monitoring FX section AFTER all your meters.

Fine-tuning:
    • Once loaded, click the headphone on the desk to enter the configuration menu, where your profile from Step 5 should appear.
    • Gain: AutoEQ gain values can be a bit hit-or-miss. I’ve added a Gain slider in the GUI: adjust it so that toggling the correction doesn't change the overall volume. Double-clicking the slider restores the value from the file, and the SAVE button writes your new value back to the profile.
    • True Stereo Setup (Recommended Order):
        1. Send only the Left or Right channel into the plugin.
        2. Adjust the cutoff parameter until you achieve a comfortable tone (700 Hz is the default).
        3. Switch back to a stereo signal and adjust suppression to your taste.
        4. You’ll notice the stage feels narrower. Now, return the width by gradually increasing the ITD (delay). You will hear the stage "open up" while maintaining the "speaker feel." Magic! :)
My personal sweet spot: cutoff: 800, suppression: 6 dB, ITD: 0.12 ms.

Known Features:
    1. File operations only work within REAPER due to the required backend script.
    2. The plugin includes a gmem-based external control mechanism. This allows you to switch modes using toolbar buttons without opening the UI. For this reason, if you open multiple instances of the plugin, they will stay synchronized.
P.S. What’s with the name "roof_bubrik"? I have a studio cat named Bubrik. She is in charge of comfort and constantly monitors the operating temperature of my gear. She’s a vital team member—without her, everything would fall apart. Since the background script performs a similar "maintenance" role, I decided to name it after her. :)
