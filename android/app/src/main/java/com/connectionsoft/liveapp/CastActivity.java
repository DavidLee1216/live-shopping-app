package com.connectionsoft.liveapp;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.view.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

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

import org.w3c.dom.Text;
import org.webrtc.SurfaceViewRenderer;

import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import java.text.SimpleDateFormat;
import java.util.*;
import android.util.Log;
import android.os.CountDownTimer;
public class CastActivity extends AppCompatActivity {

    //    private RemonCast castViewer = null;
    String channelName ="";
    String title = "";
    int liveTime = 0;
    long startTime = 0;
    String collapsedTime = "00:00:00";

    String serviceKey = "61a7c25f-6cd8-4e80-80f0-4dd23332c3a0";
    String key = "5ad3703f3582d137dabbde3d8808700280196e50de6c911835d1021d2a1c78a4";

    Button button;
    SurfaceViewRenderer surfaceView;
    RemonCast viewer;

    RemonCast caster;
    SurfaceViewRenderer castSurfaceView;
    ImageView playIcon;
    TextView castButton;
    Button returnButton;
    ImageView stopIcon;
    TextView stopButton;
    ImageView changeCameraView1;
    ImageView changeCameraView2;

    ImageView imageView;

    TextView twLiveShopping;
    TextView twStreaming;
    TextView twStartText;
    TextView twStopText;

    TextView txCloseScreen;
    TextView txOnAir;
    TextView txTimer;
//    TextView txLiveWarningText;

    private FlutterView flutterView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cast);

        channelName = getIntent().getExtras().getString("channelId");
        title = getIntent().getExtras().getString("title");
        startTime = getIntent().getExtras().getLong("startTime");

        playIcon = findViewById(R.id.play_button);
        castButton = findViewById(R.id.castButton);
        changeCameraView1 = findViewById(R.id.cameraChangeButton1);
        stopIcon = findViewById(R.id.stop_button);
        stopButton = findViewById(R.id.stopButton);
        returnButton = findViewById(R.id.returnButton);
        changeCameraView2 = findViewById(R.id.cameraChangeButton2);

        castSurfaceView = findViewById(R.id.local_video_view);
        imageView = findViewById(R.id.imageView);

        twLiveShopping = findViewById(R.id.liveShopping);
        twStreaming = findViewById(R.id.streamingText);
        twStreaming.setText(title);
        twStartText = findViewById(R.id.startText);
        twStopText = findViewById(R.id.stopText);

        txCloseScreen = findViewById(R.id.closeScreen);
        txOnAir = findViewById(R.id.onAir);
        txTimer = findViewById(R.id.timer);

//        txLiveWarningText = findViewById(R.id.liveWarningText);

        // set
        castSurfaceView.setVisibility(View.VISIBLE);
        imageView.setVisibility(View.VISIBLE);
        setPlayButtonsVisibility(1);
        twLiveShopping.setVisibility(View.VISIBLE);
        twStreaming.setVisibility(View.GONE);
        twStartText.setVisibility(View.VISIBLE);
        twStopText.setVisibility(View.GONE);
        txOnAir.setVisibility(View.GONE);
        txTimer.setVisibility(View.GONE);
        txCloseScreen.setVisibility(View.VISIBLE);
        returnButton.setVisibility(View.GONE);
//        txLiveWarningText.setVisibility(View.GONE);

        caster = RemonCast.builder()
                .context(CastActivity.this)
                .localView(castSurfaceView)        // 자신 Video Renderer
                .serviceId(serviceKey)    // RemoteMonster 사이트에서 등록했던 당신의 id를 입력하세요.
                .key(key)    // RemoteMonster로부터 받은 당신의 key를 입력하세요.
                .build();

        caster.showLocalVideo();

        new CountDownTimer(50000000, 1000) {
            public void onTick(long millisUntilFinished) {

                int[] collapsedTimeArray = getCollapsedTime();
                collapsedTime = String.format("%02d:%02d:%02d", collapsedTimeArray[0], collapsedTimeArray[1], collapsedTimeArray[2]);
                txTimer.setText(collapsedTime);
            }
            public void onFinish() {
                collapsedTime = "00:00:00";
            }
        }.start();

        changeCameraView1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });

        castButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // make ui changes accordingly
                castSurfaceView.setVisibility(View.VISIBLE);
                imageView.setVisibility(View.GONE);
                castButton.setVisibility(View.GONE);
                setPlayButtonsVisibility(2);
                twLiveShopping.setVisibility(View.GONE);
                twStreaming.setVisibility(View.VISIBLE);
                twStartText.setVisibility(View.GONE);
                twStopText.setVisibility(View.GONE);
                txOnAir.setVisibility(View.VISIBLE);
                txTimer.setVisibility(View.VISIBLE);
                txCloseScreen.setVisibility(View.GONE);
                returnButton.setVisibility(View.GONE);
//                txLiveWarningText.setVisibility(View.VISIBLE);
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
                        imageView.setVisibility(View.GONE);
                        twLiveShopping.setVisibility(View.GONE);
                        twStreaming.setVisibility(View.GONE);
                        twStartText.setVisibility(View.GONE);
                        twStopText.setVisibility(View.VISIBLE);
                        txOnAir.setVisibility(View.GONE);
                        txTimer.setVisibility(View.GONE);
                        imageView.setVisibility(View.GONE);
                        castButton.setVisibility(View.GONE);
                        txCloseScreen.setVisibility(View.VISIBLE);
                        playIcon.setVisibility(View.GONE);
                        castButton.setVisibility(View.GONE);
                        changeCameraView1.setVisibility(View.GONE);
                        stopIcon.setVisibility(View.GONE);
                        stopButton.setVisibility(View.GONE);
                        changeCameraView2.setVisibility(View.GONE);
                        returnButton.setVisibility(View.VISIBLE);
//                        txLiveWarningText.setVisibility(View.GONE);
                        //

                        caster.close();
                        alertDialog.dismiss();

//                        MethodChannel channel = MethodChannel(, MainActivity.CHANNEL);
//                        channel.invokeMethod("castStop", channelName);
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

        returnButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

    }

    private void setPlayButtonsVisibility(int kind){
        if(kind==1){
            playIcon.setVisibility(View.VISIBLE);
            castButton.setVisibility(View.VISIBLE);
            changeCameraView1.setVisibility(View.GONE);
            stopIcon.setVisibility(View.GONE);
            stopButton.setVisibility(View.GONE);
            changeCameraView2.setVisibility(View.GONE);
        }
        else if(kind==2){
            playIcon.setVisibility(View.GONE);
            castButton.setVisibility(View.GONE);
            changeCameraView1.setVisibility(View.GONE);
            stopIcon.setVisibility(View.VISIBLE);
            stopButton.setVisibility(View.VISIBLE);
            changeCameraView2.setVisibility(View.GONE);
        }
    }

    private int[] getCollapsedTime(){
        Date currentTime = Calendar.getInstance().getTime();
        long currNumberTime = currentTime.getTime();
        long passedTime = currNumberTime - startTime;
        int hour = (int)((passedTime / 3600000) % 24);
        int min = (int)((passedTime / 60000) % 60);
        int sec = (int)((passedTime / 1000) % 60);
        return new int[] {hour, min, sec};
    }
}