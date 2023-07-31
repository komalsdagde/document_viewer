package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.pinciat.external_path.ExternalPathPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import dev.britto.pdf_viewer_plugin.PdfViewerPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ExternalPathPlugin.registerWith(registry.registrarFor("com.pinciat.external_path.ExternalPathPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PdfViewerPlugin.registerWith(registry.registrarFor("dev.britto.pdf_viewer_plugin.PdfViewerPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
