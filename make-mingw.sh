make TARGET_OS=windows clean
make TARGET_OS=windows \
     BLISS_CC="x86_64-w64-mingw32-g++ -static -static-libgcc -static-libstdc++" \
     STRIP=x86_64-w64-mingw32-strip \
     AR=x86_64-w64-mingw32-ar \
     RANLIB=x86_64-w64-mingw32-ranlib \
     JNI_H_PATH=jdk8/include \
     JNI_MD_H_PATH=jdk8/include/win32 \
     all
