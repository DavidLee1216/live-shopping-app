package com.connectionsoft.liveapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.remotemonster.sdk.RemonCast;
import androidx.appcompat.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import org.webrtc.SurfaceViewRenderer;

public class CastActivity extends AppCompatActivity {

    //    private RemonCast castViewer = null;
    String channelName ="";

    String serviceKey = "61a7c25f-6cd8-4e80-80f0-4dd23332c3a0";
    String key = "5ad3703f3582d137dabbde3d8808700280196e50de6c911835d1021d2a1c78a4";

    Button button;
    SurfaceViewRenderer surfaceView;
    RemonCast viewer;

    RemonCast caster;
    SurfaceViewRenderer castSurfaceView;
    Button castButton;
    Button stopButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cast);

        channelName = getIntent().getExtras().getString("channelId");

        castButton = findViewById(R.id.castButton);
        stopButton = findViewById(R.id.stopButton);
        castSurfaceView = findViewById(R.id.local_video_view);

        caster = RemonCast.builder()
                .context(CastActivity.this)
                .localView(castSurfaceView)        // 자신 Video Renderer
                .serviceId(serviceKey)    // RemoteMonster 사이트에서 등록했던 당신의 id를 입력하세요.
                .key(key)    // RemoteMonster로부터 받은 당신의 key를 입력하세요.
                .build();

        caster.showLocalVideo();

        castButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                caster.create(channelName);
            }
        });

        stopButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                caster.close();
            }
        });

    }
}