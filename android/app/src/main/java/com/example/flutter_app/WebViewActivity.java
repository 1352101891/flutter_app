package com.example.flutter_app;

import android.annotation.TargetApi;
import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

public class WebViewActivity extends Activity implements View.OnClickListener {
    private WebView mWebView;
    private ProgressBar mBar;
    private String url;
    private String title;
    public final static String URL="URL";
    public final static String TITLE="TITLE";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview);

        parseIntent();
        InitOthers();
    }


    public void InitOthers() {
        initView();
        initWebView();
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR1)
    public void parseIntent() {
        Bundle bundle=getIntent().getExtras();
        if (bundle!=null){
            url=bundle.getString(URL,"");
            title=bundle.getString(TITLE,"");
        }
    }


    private void initView() {
        mBar=(ProgressBar) findViewById(R.id.process_bar);
        mWebView = (WebView) findViewById(R.id.webview);
    }

    @TargetApi(Build.VERSION_CODES.ECLAIR_MR1)
    private void initWebView() {
        WebSettings settings = mWebView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setUseWideViewPort(true);
        settings.setLoadWithOverviewMode(true);

        mWebView.loadUrl(url);
        setTitle(title);

        mWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                if (newProgress == 100) {
                    mBar.setVisibility(View.GONE);
                } else {
                    mBar.setVisibility(View.VISIBLE);
                    mBar.setProgress(newProgress);
                }
            }

            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
                if (title != null) {
                }
            }
        });

        /**
         * 监听WebView的加载状态    分别为 ： 加载的 前 中 后期
         * */
        mWebView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                String title = view.getTitle();
                if (!TextUtils.isEmpty(title)) {
                }
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                //本应该加载的H5静态界面
                mWebView.loadUrl(url);
                return true;
            }
        });
    }


    @TargetApi(Build.VERSION_CODES.ECLAIR)
    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            default:
                break;
        }
    }



    @Override
    public void onDestroy() {
        if( mWebView!=null) {

            // 如果先调用destroy()方法，则会命中if (isDestroyed()) return;这一行代码，需要先onDetachedFromWindow()，再
            // destory()
            ViewParent parent = mWebView.getParent();
            if (parent != null) {
                ((ViewGroup) parent).removeView(mWebView);
            }

            mWebView.stopLoading();
            // 退出时调用此方法，移除绑定的服务，否则某些特定系统会报错
            mWebView.getSettings().setJavaScriptEnabled(false);
            mWebView.clearHistory();
            mWebView.clearView();
            mWebView.removeAllViews();
            mWebView.destroy();

        }
        super.onDestroy();
    }

    @TargetApi(Build.VERSION_CODES.ECLAIR)
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && mWebView.canGoBack()) {
            mWebView.goBack();
            return true;
        } else {
            onBackPressed();
        }
        return super.onKeyDown(keyCode, event);
    }


}