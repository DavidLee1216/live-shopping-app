package com.connectionsoft.liveapp;

import io.flutter.embedding.android.FlutterActivity;
import android.content.Intent;
import android.widget.Toast;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.text.SimpleDateFormat;
import java.util.*;
import android.util.Log;

public class MainActivity extends FlutterActivity {

    // define the CHANNEL with the same name as the one in Flutter
    public static final String CHANNEL = "com.connectionsoft.liveapp/cast";
    String channelId = "";
    String title = "";
    String liveDateTime = "";
    long startTime = 0;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        // define the MethodChannel and set a MethodCallHandler
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {

                    if (call.method.equals("startStreaming")) {

                        channelId = call.argument("channelId");
                        title = call.argument("title");
                        String liveTime = call.argument("liveDateTime");
                        try {
                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US);
                            Date time = dateFormat.parse(liveTime);
                            startTime = time.getTime();
                        } catch (Exception e) {
                            Date currentTime = Calendar.getInstance().getTime();
                            startTime = currentTime.getTime();
                        }
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
        intent.putExtra("title", title);
        intent.putExtra("startTime", startTime);
        startActivity(intent);
    }

}
