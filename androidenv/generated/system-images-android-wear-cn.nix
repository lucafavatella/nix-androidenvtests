
{fetchurl}:

{
  

    "25".android-wear."armeabi-v7a".all = {
      name = "system-image-25-android-wear-armeabi-v7a";
      path = "system-images/android-25/android-wear-cn/armeabi-v7a";
      revision = "25-android-wear-armeabi-v7a";
      displayName = "China version of Android Wear ARM EABI v7a System Image";
      archives.all = fetchurl {
        url = 
        https://dl.google.com/android/repository/sys-img/android-wear-cn/armeabi-v7a-25_r04.zip;
        sha1 = "02d7bc86df054d1e89fe5856b3af1d2c142cab41";
      };
    };
  

    "25".android-wear."x86".all = {
      name = "system-image-25-android-wear-x86";
      path = "system-images/android-25/android-wear-cn/x86";
      revision = "25-android-wear-x86";
      displayName = "China version of Android Wear Intel x86 Atom System Image";
      archives.all = fetchurl {
        url = 
        https://dl.google.com/android/repository/sys-img/android-wear-cn/x86-25_r04.zip;
        sha1 = "73eab14c7cf2f6941e1fee61e0038ead7a2c7f4d";
      };
    };
  

    "26".android-wear."x86".all = {
      name = "system-image-26-android-wear-x86";
      path = "system-images/android-26/android-wear-cn/x86";
      revision = "26-android-wear-x86";
      displayName = "China version of Android Wear Intel x86 Atom System Image";
      archives.all = fetchurl {
        url = 
        https://dl.google.com/android/repository/sys-img/android-wear-cn/x86-26_r04.zip;
        sha1 = "fdc8a313f889a2d6522de1fbc00ee9e13547d096";
      };
    };
  

    "28".android-wear."x86".all = {
      name = "system-image-28-android-wear-x86";
      path = "system-images/android-28/android-wear-cn/x86";
      revision = "28-android-wear-x86";
      displayName = "China version of Wear OS Intel x86 Atom System Image";
      archives.all = fetchurl {
        url = 
        https://dl.google.com/android/repository/sys-img/android-wear-cn/x86-28_r03.zip;
        sha1 = "2099d87709c5e064273925dbf2cf1fd081bf0262";
      };
    };
  
}
  