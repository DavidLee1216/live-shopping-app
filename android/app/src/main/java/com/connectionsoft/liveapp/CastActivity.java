package com.connectionsoft.liveapp;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

import com.remotemonster.sdk.RemonCast;
import androidx.appcompat.app.AppCompatActivity;

import com.androidnetworking.AndroidNetworking;
import com.androidnetworking.interfaces.JSONObjectRequestListener;
import com.androidnetworking.common.Priority;
import org.json.JSONObject;
import com.androidnetworking.error.ANError;

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
    String token = "";
    String liveId = "";
    String collapsedTime = "00:00:00";
    boolean isCast = false;

    String serviceKey = "61a7c25f-6cd8-4e80-80f0-4dd23332c3a0";
    String key = "5ad3703f3582d137dabbde3d8808700280196e50de6c911835d1021d2a1c78a4";

    Button button;
    SurfaceViewRenderer surfaceView;
    RemonCast viewer;

    RemonCast caster;
    SurfaceViewRenderer castSurfaceView;

    ImageView liveBackground;
    ImageView playIcon;
    TextView castButton;
    Button returnButton;
    ImageView stopIcon;
    TextView stopButton;
    ImageView changeCameraView1;
    ImageView changeCameraView2;

    ImageView LiveLogoView;

    TextView twLiveShopping;
    TextView twStreaming;
    TextView twStartText;
    TextView twStopText;

    ImageView txCloseScreen;
    TextView txOnAir;
    TextView txTimer;
//    TextView txLiveWarningText;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cast);

        AndroidNetworking.initialize(getApplicationContext());

//        channelName = getIntent().getExtras().getString("channelId");
        title = getIntent().getExtras().getString("title");
        startTime = getIntent().getExtras().getLong("startTime");
        token = getIntent().getExtras().getString("token");
        liveId = getIntent().getExtras().getString("liveId");

        playIcon = findViewById(R.id.play_icon);
        castButton = findViewById(R.id.castButton);
        changeCameraView1 = findViewById(R.id.cameraChangeButton1);
        stopIcon = findViewById(R.id.stop_icon);
        stopButton = findViewById(R.id.stopButton);
        returnButton = findViewById(R.id.returnButton);
        changeCameraView2 = findViewById(R.id.cameraChangeButton2);

        castSurfaceView = findViewById(R.id.local_video_view);
//        castRemoteView = findViewById(R.id.remote_video_view);
        liveBackground = findViewById(R.id.live_background);
        LiveLogoView = findViewById(R.id.LiveLogoView);

        twLiveShopping = findViewById(R.id.liveShopping);
        twStreaming = findViewById(R.id.streamingText);
        twStreaming.setText(title);
        twStartText = findViewById(R.id.startText);
        twStopText = findViewById(R.id.stopText);

        txCloseScreen = findViewById(R.id.closeScreen);
        txOnAir = findViewById(R.id.onAir);
        txTimer = findViewById(R.id.timer);

        castSurfaceView.setVisibility(View.VISIBLE);
        liveBackground.setVisibility(View.VISIBLE);
        LiveLogoView.setVisibility(View.VISIBLE);
        setPlayButtonsVisibility(1);
        twLiveShopping.setVisibility(View.VISIBLE);
        twStreaming.setVisibility(View.GONE);
        twStartText.setVisibility(View.VISIBLE);
        twStopText.setVisibility(View.GONE);
        txOnAir.setVisibility(View.GONE);
        txOnAir.setText("On Air");
        txTimer.setVisibility(View.GONE);
        txCloseScreen.setVisibility(View.VISIBLE);
        returnButton.setVisibility(View.GONE);
//        txLiveWarningText.setVisibility(View.GONE);

        channelName = GenerateRandomString.randomString(10);

        caster = RemonCast.builder()
                .context(CastActivity.this)
                .localView(castSurfaceView)        // 자신 Video Renderer
                .serviceId(serviceKey)    // RemoteMonster 사이트에서 등록했던 당신의 id를 입력하세요.
                .key(key)    // RemoteMonster로부터 받은 당신의 key를 입력하세요.
                .build();

        caster.setMicMute(false);
//        caster.showLocalVideo();

        caster.onCreate((channelName) -> {
            postStartRequest(channelName);
        });

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
                caster.switchCamera();
            }
        });
        changeCameraView2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                caster.switchCamera();
            }
        });

        castButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // make ui changes accordingly
                castSurfaceView.setVisibility(View.VISIBLE);
                liveBackground.setVisibility(View.GONE);
                LiveLogoView.setVisibility(View.GONE);
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

                try {
                    caster.create(channelName);
                    isCast = true;
                } catch (Exception e) {
                    e.printStackTrace();
                }
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
                ImageView alertClose = (ImageView) dialogView.findViewById(R.id.alertClose);

                builder.setView(dialogView);
                AlertDialog alertDialog = builder.create();


                button1.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {

                        // make ui changes accordingly
                        castSurfaceView.setVisibility(View.GONE);
                        liveBackground.setVisibility(View.VISIBLE);
                        LiveLogoView.setVisibility(View.GONE);
                        twLiveShopping.setVisibility(View.GONE);
                        twStreaming.setVisibility(View.GONE);
                        twStartText.setVisibility(View.GONE);
                        twStopText.setVisibility(View.VISIBLE);
                        txOnAir.setVisibility(View.GONE);
                        txTimer.setVisibility(View.GONE);
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
                        postStopRequest();
                        alertDialog.dismiss();
                        isCast = false;

                    }
                });
                button2.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        // DO SOMETHINGS
//                       dialogBuilder.dismiss();
                        alertDialog.dismiss();
                        isCast = true;
                    }
                });
                alertClose.setOnClickListener(new View.OnClickListener(){
                    @Override
                    public void onClick(View view) {
                        alertDialog.dismiss();
                        isCast = true;
                    }
                });
                alertDialog.show();
            }
        });


        txCloseScreen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if(isCast){
                    AlertDialog.Builder builder = new AlertDialog.Builder(CastActivity.this);
                    ViewGroup viewGroup = findViewById(android.R.id.content);
                    View dialogView = LayoutInflater.from(view.getContext()).inflate(R.layout.customview, viewGroup, false);

                    Button button1 = (Button) dialogView.findViewById(R.id.buttonOk);
                    Button button2 = (Button) dialogView.findViewById(R.id.buttonNo);
                    ImageView alertClose = (ImageView) dialogView.findViewById(R.id.alertClose);

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
                    alertClose.setOnClickListener(new View.OnClickListener(){
                        @Override
                        public void onClick(View view) {
                            alertDialog.dismiss();
                            isCast = true;
                        }
                    });

                    alertDialog.show();
                }
                else{
                    finish();
                }
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
            changeCameraView1.setVisibility(View.VISIBLE);
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
            changeCameraView2.setVisibility(View.VISIBLE);
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

    private void postStopRequest(){
        AndroidNetworking.post("http://108.160.134.86:3000/liveEnd")
                .addBodyParameter("liveId", liveId)
                .addHeaders("authorization", "Bearer " + token)
                .setTag("stopCast")
                .setPriority(Priority.MEDIUM)
                .build()
                .getAsJSONObject(new JSONObjectRequestListener() {
                    @Override
                    public void onResponse(JSONObject response) {
                    }
                    @Override
                    public void onError(ANError error) {
                    }
                });
    }

    private void postStartRequest(String channelName){
        AndroidNetworking.post("http://108.160.134.86:3000/liveStart")
                .addBodyParameter("liveId", liveId)
                .addBodyParameter("solutionId", channelName)
                .addHeaders("authorization", "Bearer " + token)
                .setTag("startCast")
                .setPriority(Priority.MEDIUM)
                .build()
                .getAsJSONObject(new JSONObjectRequestListener() {
                    @Override
                    public void onResponse(JSONObject response) {
                    }
                    @Override
                    public void onError(ANError error) {
                        Toast.makeText(getApplicationContext(), "서버 연결 실패", Toast.LENGTH_SHORT).show();                    }
                });
    }

    public static class GenerateRandomString {

        public static final String DATA = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        public static Random RANDOM = new Random();

        public static String randomString(int len) {
            StringBuilder sb = new StringBuilder(len);

            for (int i = 0; i < len; i++) {
                sb.append(DATA.charAt(RANDOM.nextInt(DATA.length())));
            }

            return sb.toString();
        }

    }

}