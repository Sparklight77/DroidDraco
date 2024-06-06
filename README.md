# Auto-Draco-Injector

A bash script designed for Termux to simplify the process of patching Minecraft with Draco-Injector. This script is inspired by the [callmesoumya2063 repository](https://github.com/CallMeSoumya2063/draco-injector-script), which is based on the work of [mcbegamerxx9541](https://github.com/mcbegamerxx954/draco-injector). Special thanks to [callmesoumya2063](https://github.com/CallMeSoumya2063) for testing, fixing issues, and providing the Minecraft scanner script.

I must mention that I'm not well-versed in bash scripting. However, by studying various repositories and with the help of ChatGPT, I was able to create this script.

# 💠 Supported Architectures
arm64-v8a (aarch64)

armabi-v7a (armv7l)

Intel x86_64

# ⚠️ Important
1. Beta patching is not supported currently. Only stable releases can be patched.
2. IOS is not supported 

# ✏️ Tutorial
1. Install [Termux](https://github.com/termux/termux-app/releases).
2. Place the Minecraft APK file in the Downloads folder (ensure the APK file name contains "Minecraft" for the script to detect it).
3. Open Termux and run the following command:
   ```bash
   curl -o install.sh https://raw.githubusercontent.com/Sparklight77/auto-draco-injector/main/install.sh && bash install.sh
   ```
4. Follow the on-screen instructions.
5. After patching once, simply use `bash draco-injector.sh` to start the injector.
6. After patching the Minecraft APK, you can find the patched APK in the `MCPatch` folder in the home directory.

> [!Note]  
> You need to be connected to the internet during the patch process. The Playstore version of Minecraft contains both 64-bit and 32-bit code in a single APK. To separate them, use [ApkTool M](https://maximoff.su/apktool/?lang=en) with the antisplit feature and place the resulting APK in the Downloads folder. Then run the injector start command. Note that patching and installing a 32-bit Minecraft APK on a 64-bit device may result in performance issues, so it's recommended to use the appropriate APK for your device.

> [!important]  
> If you encounter any issues, report them in the [mcbegamerxx9541 repository](https://github.com/mcbegamerxx954/draco-injector/issues). Open an issue, describe your problem, and mention that you used this script for patching Minecraft.

# 📝 Note
If you find any issues with this script or have suggestions, please open an issue. I am always looking for ways to improve.