package com.hogangnono.cordova.systembrowser;

import android.content.Intent;
import android.net.Uri;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class SystemBrowser extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("openExternal".equals(action)) {
            openExternal(args.getString(0), callbackContext);
            return true;
        }
        if ("openSheet".equals(action)) {
            callbackContext.error("openSheet is not supported on Android");
            return true;
        }
        return false;
    }

    private void openExternal(String url, CallbackContext callbackContext) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            cordova.getActivity().startActivity(intent);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error("Failed to open URL: " + e.getMessage());
        }
    }
}
