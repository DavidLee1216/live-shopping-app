package com.connectionsoft.liveapp;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

import com.remotemonster.sdk.RemonCast;
import androidx.appcompat.app.AppCompatActivity;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import org.webrtc.SurfaceViewRenderer;

import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;

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
    ImageView imageView;

    TextView twLiveShopping;
    TextView twStreaming;
    TextView twStartText;
    TextView twStopText;

    TextView txCloseScreen;
    TextView txOnAir;
    TextView txTimer;
    TextView txLiveWarningText;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cast);

        channelName = getIntent().getExtras().getString("channelId");

        castButton = findViewById(R.id.castButton);
        stopButton = findViewById(R.id.stopButton);
        castSurfaceView = findViewById(R.id.local_video_view);
        imageView = findViewById(R.id.imageView);

        twLiveShopping = findViewById(R.id.liveShopping);
        twStreaming = findViewById(R.id.streamingText);
        twStartText = findViewById(R.id.startText);
        twStopText = findViewById(R.id.stopText);

        txCloseScreen = findViewById(R.id.closeScreen);
        txOnAir = findViewById(R.id.onAir);
        txTimer = findViewById(R.id.timer);
        txLiveWarningText = findViewById(R.id.liveWarningText);

        // set
        castSurfaceView.setVisibility(View.GONE);
        imageView.setVisibility(View.VISIBLE);
        stopButton.setVisibility(View.GONE);
        twLiveShopping.setVisibility(View.VISIBLE);
        twStreaming.setVisibility(View.GONE);
        twStartText.setVisibility(View.VISIBLE);
        twStopText.setVisibility(View.GONE);
        txOnAir.setVisibility(View.GONE);
        txTimer.setVisibility(View.GONE);
        txCloseScreen.setVisibility(View.VISIBLE);
        txLiveWarningText.setVisibility(View.GONE);



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
                // make ui changes accordingly
                castSurfaceView.setVisibility(View.VISIBLE);
                imageView.setVisibility(View.GONE);
                castButton.setVisibility(View.GONE);
                stopButton.setVisibility(View.VISIBLE);
                twLiveShopping.setVisibility(View.GONE);
                twStreaming.setVisibility(View.VISIBLE);
                twStartText.setVisibility(View.GONE);
                twStopText.setVisibility(View.VISIBLE);
                txOnAir.setVisibility(View.VISIBLE);
                txTimer.setVisibility(View.VISIBLE);
                txCloseScreen.setVisibility(View.GONE);
                txLiveWarningText.setVisibility(View.VISIBLE);
                //

                caster.create(channelName);
            }
        });

        stopButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                AlertDialog.Builder builder = new AlertDialog.Builder(CastActivity.this);
                ViewGroup viewGroup = findViewById(android.R.id.content);
                View dialogView = LayoutInflater.from(view.getContext()).inflate(R.layout.customview, viewGroup, false);

                Button button1 = (Button) dialogView.findViewById(R.id.buttonOk);
                Button button2 = (Button) dialogView.findViewById(R.id.buttonNo);

                builder.setView(dialogView);
                AlertDialog alertDialog = builder.create();


                button1.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {

                        // make ui changes accordingly
                        castSurfaceView.setVisibility(View.GONE);
                        imageView.setVisibility(View.VISIBLE);
                        castButton.setVisibility(View.VISIBLE);
                        stopButton.setVisibility(View.GONE);
                        twLiveShopping.setVisibility(View.VISIBLE);
                        twStreaming.setVisibility(View.GONE);
                        twStartText.setVisibility(View.VISIBLE);
                        twStopText.setVisibility(View.GONE);
                        txOnAir.setVisibility(View.GONE);
                        txTimer.setVisibility(View.GONE);
                        txCloseScreen.setVisibility(View.VISIBLE);
                        txLiveWarningText.setVisibility(View.GONE);
                        //

                        caster.close();
                        alertDialog.dismiss();

                    }
                });
                button2.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        // DO SOMETHINGS
//                       dialogBuilder.dismiss();
                        alertDialog.dismiss();
                    }
                });



                alertDialog.show();


            }
        });


        txCloseScreen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                AlertDialog.Builder builder = new AlertDialog.Builder(CastActivity.this);
                ViewGroup viewGroup = findViewById(android.R.id.content);
                View dialogView = LayoutInflater.from(view.getContext()).inflate(R.layout.customview, viewGroup, false);

                Button button1 = (Button) dialogView.findViewById(R.id.buttonOk);
                Button button2 = (Button) dialogView.findViewById(R.id.buttonNo);

                builder.setView(dialogView);
                AlertDialog alertDialog = builder.create();


                button1.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        finish();
                    }
                });
                button2.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        // DO SOMETHINGS
//                       dialogBuilder.dismiss();
                        alertDialog.dismiss();
                    }
                });

                alertDialog.show();


            }
        });


    }

}