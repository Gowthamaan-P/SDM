package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new io.flutter.plugins.camera.CameraPlugin());
      io.github.edufolly.flutterbluetoothserial.FlutterBluetoothSerialPlugin.registerWith(shimPluginRegistry.registrarFor("io.github.edufolly.flutterbluetoothserial.FlutterBluetoothSerialPlugin"));
      com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.registerWith(shimPluginRegistry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    flutterEngine.getPlugins().add(new com.github.rmtmckenzie.native_device_orientation.NativeDeviceOrientationPlugin());
      io.flutter.plugins.pathprovider.PathProviderPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
      de.florianweinaug.system_settings.SystemSettingsPlugin.registerWith(shimPluginRegistry.registrarFor("de.florianweinaug.system_settings.SystemSettingsPlugin"));
      sq.flutter.tflite.TflitePlugin.registerWith(shimPluginRegistry.registrarFor("sq.flutter.tflite.TflitePlugin"));
  }
}
