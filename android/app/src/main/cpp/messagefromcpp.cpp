#include <jni.h>
//
//extern "C" JNIEXPORT jstring JNICALL
//Java_com_example_hourly_NativeLib_getWelcomeMessage(JNIEnv *env, jobject) {
//    const char* welcomeMessage = "Welcome";
//    return env->NewStringUTF(welcomeMessage);
//}

//double get_temperature()
//{
//    return 86.0f;
//}

extern "C" JNIEXPORT double JNICALL
Java_com_example_hourly_NativeLib_getTemperature(JNIEnv *env, jobject) {
return 250503.0;
}
