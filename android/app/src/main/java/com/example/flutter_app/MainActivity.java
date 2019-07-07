package com.example.flutter_app;

import android.content.Intent;
import android.os.Bundle;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), "com.flutter.gotowebview").setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                // TODO
                if (call.method.equals("open") && call.arguments instanceof Map){
                    Map map= (Map) call.arguments;
                    String url= (String) map.get("url");
                    String title=(String) map.get("title");
                    Intent intent=new Intent();
                    intent.putExtra(WebViewActivity.URL,url);
                    intent.putExtra(WebViewActivity.TITLE,title);
                    intent.setClass(MainActivity.this,WebViewActivity.class);
                    MainActivity.this.startActivity(intent);
                }
              }
            });
  }
}
