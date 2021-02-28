package com.simrat39.AnimeTwistFlut

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.UiModeManager
import android.content.Context
import android.content.Intent
import android.content.res.Configuration.UI_MODE_TYPE_TELEVISION
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.TypedValue
import android.view.ContextThemeWrapper
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.work.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.net.URL
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val constraints = Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED)
        // repeat every 3 days
        val req = PeriodicWorkRequestBuilder<UpdateCheckWorker>(3, TimeUnit.DAYS)
                .setConstraints(constraints.build())
                .addTag(UpdateCheckWorker.workTag)
                .build()
        WorkManager
                .getInstance(context)
                .enqueue(req)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tv_info").setMethodCallHandler { call, result ->
            if (call.method == "isTV") {
                result.success(isTV())
            } else if (call.method == "launchMxPlayer") {
                val url = call.argument<String>("url")
                val referer = call.argument<String>("referer")
                if (url != null && referer != null) {
                    launchMxPlayer(url, referer)
                }
                result.success(null)
            }
        }
    }

    private fun isTV(): Boolean {
        val uiModeManager: UiModeManager = getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
        return uiModeManager.currentModeType === UI_MODE_TYPE_TELEVISION
    }

    private fun launchMxPlayer(url: String, referer: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        val headers = arrayOf<String>("Referer", referer, "User-Agent", "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101 Firefox/85.0")
        intent.data = Uri.parse(url)
        intent.putExtra("headers", headers)
        intent.setPackage("com.mxtech.videoplayer.ad")
        context.startActivity(intent)
    }
}

class UpdateCheckWorker(context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {
    var context = context

    override fun doWork(): Result {
        WorkManager.getInstance(context).cancelAllWorkByTag(workTag)

        var githubUpdateChecker = GithubUpdateChecker()
        val hasUpdate = githubUpdateChecker.checkUpdate()
        if (hasUpdate) {
            var notificationHelper = NotificationHelper(context, channelId = "1")
            notificationHelper.setChannel("Updates", "Push notifications for in app updates")
            var notif = notificationHelper.createNotification(
                    "Update Available",
                    "Latest version: ${githubUpdateChecker.latestVersion}\nCurrent version: ${githubUpdateChecker.currentVersion}",
                    arrayOf(NotificationAction(R.drawable.ic_download, "Download", notificationHelper.launchUrlIntent(githubUpdateChecker.downloadLink)))
            )
            notificationHelper.sendNotification(notif, 1)
        }
        return Result.success()
    }

    companion object {
        var workTag = "1"
    }
}

class NotificationHelper(context: Context, channelId: String) {
    var context = context
    var channelId = channelId

    fun setChannel(name: String, desc: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = name
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, name, importance).apply {
                description = desc
            }
            // Register the channel with the system
            val notificationManager: NotificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun createNotification(title: String, description: String, actions: Array<NotificationAction>): NotificationCompat.Builder {
        val notif = NotificationCompat.Builder(context, this.channelId)
                .setSmallIcon(R.drawable.ic_notification)
                .setStyle(NotificationCompat.BigTextStyle().bigText(description))
                .setColor(getDeviceAccentColor())
                .setContentText(description)
                .setContentTitle(title)
                .setContentIntent(openAppIntent())

        actions.forEach { action ->
            notif.addAction(action.drawable, action.title, action.pendingIntent)
        }

        return notif
    }

    fun sendNotification(notification: NotificationCompat.Builder, notificationId: Int) {
        with(NotificationManagerCompat.from(context)) {
            notify(notificationId, notification.build())
        }
    }

    fun openAppIntent(): PendingIntent {
        // Flutter apps only have one activity
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        return PendingIntent.getActivity(context, 0, intent, 0)
    }

    fun launchUrlIntent(url: String): PendingIntent {
        var i = Intent(Intent.ACTION_VIEW)
        i.data = Uri.parse(url)
        return PendingIntent.getActivity(context, 0, i, 0)
    }

    private fun getDeviceAccentColor(): Int {
        val value = TypedValue()
        val ctx = ContextThemeWrapper(context, android.R.style.Theme_DeviceDefault)
        ctx.theme.resolveAttribute(android.R.attr.colorAccent, value, true)
        return value.data
    }

}

class NotificationAction(drawable: Int, title: String, pendingIntent: PendingIntent) {
    var drawable = drawable
    var title = title
    var pendingIntent = pendingIntent
}

class GithubUpdateChecker {
    var hasUpdate = false
    var latestVersion = ""
    var currentVersion = ""
    var downloadLink = ""

    private val URL = "https://raw.githubusercontent.com/simrat39/AnimeTwistFlut/master/release.json"

    private fun setCurrentVersion() {
        currentVersion = BuildConfig.VERSION_NAME
    }

    private fun setLatestVersion() {
        val text = URL(URL).readText()
        val jsonObj = JSONObject(text.substring(text.indexOf("{"), text.lastIndexOf("}") + 1))
        val latestVersion = jsonObj.getString("latest_version")
        val dl = jsonObj.getString("download_link")
        this.latestVersion = latestVersion
        this.downloadLink = dl
    }

    fun checkUpdate(): Boolean {
        setCurrentVersion()
        setLatestVersion()
        if (currentVersion != latestVersion) {
            hasUpdate = true
        }
        return hasUpdate
    }
}
