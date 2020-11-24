package com.connectionsoft.liveapp;

import io.flutter.embedding.android.FlutterActivity;

import io.flutter.embedding.android.FlutterActivity;
import android.content.Intent;
import android.widget.Toast;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    // define the CHANNEL with the same name as the one in Flutter
    private static final String CHANNEL = "com.connectionsoft.liveapp/cast";
    String channelId = "";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        // define the MethodChannel and set a MethodCallHandler
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {

                    if (call.method.equals("startStreaming")) {

                        channelId = call.argument("channelId");
                        runCode();
                        result.success("Code runs");
                        Toast.makeText(this, result.toString(), Toast.LENGTH_SHORT).show();
                        Toast.makeText(this, channelId, Toast.LENGTH_SHORT).show();
                    }
                });
    }



    public void runCode() {

        Toast.makeText(this, "Activity is being opened", Toast.LENGTH_SHORT).show();

        Intent intent = new Intent(getApplicationContext(),CastActivity.class);//Start your special native stuff
        intent.putExtra("channelId",channelId );
        startActivity(intent);
    }

}
