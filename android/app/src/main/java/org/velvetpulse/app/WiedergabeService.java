package org.velvetpulse.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.media.session.MediaSession;
import android.media.session.PlaybackState;
import android.os.Build;
import android.os.IBinder;

/** Neutrale Systemsteuerung. Sprechtexte und Inhaltstitel verlassen Dart nicht. */
public final class WiedergabeService extends Service {
    public interface Steuerung { void ausfuehren(String aktion); }
    public static Steuerung steuerung;
    private static final String KANAL = "wiedergabe_neutral";
    private static final int MELDUNG = 204;
    private MediaSession sitzung;

    @Override public void onCreate() {
        super.onCreate();
        sitzung = new MediaSession(this, "Pulse");
        sitzung.setCallback(new MediaSession.Callback() {
            @Override public void onPause() { steuern("pause"); }
            @Override public void onStop() { steuern("beenden"); }
        });
        sitzung.setFlags(MediaSession.FLAG_HANDLES_MEDIA_BUTTONS | MediaSession.FLAG_HANDLES_TRANSPORT_CONTROLS);
        sitzung.setActive(true);
    }
    private void steuern(String aktion) {
        if (steuerung != null) steuerung.ausfuehren(aktion);
    }
    @Override public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent == null) { stopSelf(); return START_NOT_STICKY; }
        String aktion = intent.getAction();
        if ("pause".equals(aktion) || "beenden".equals(aktion)) {
            steuern(aktion);
            if ("beenden".equals(aktion)) { stopForeground(true); stopSelf(); }
            return START_NOT_STICKY;
        }
        String titel = intent.getStringExtra("titel");
        if (titel == null) { stopSelf(); return START_NOT_STICKY; }
        boolean spielt = intent.getBooleanExtra("spielt", false);
        if (Build.VERSION.SDK_INT >= 26) {
            NotificationChannel kanal = new NotificationChannel(KANAL, titel, NotificationManager.IMPORTANCE_LOW);
            kanal.setShowBadge(false);
            ((NotificationManager)getSystemService(NOTIFICATION_SERVICE)).createNotificationChannel(kanal);
        }
        Notification.Builder b = Build.VERSION.SDK_INT >= 26
            ? new Notification.Builder(this, KANAL) : new Notification.Builder(this);
        b.setContentTitle(titel).setSmallIcon(android.R.drawable.ic_media_play)
            .setOnlyAlertOnce(true).setShowWhen(false).setOngoing(spielt)
            .setVisibility(Notification.VISIBILITY_PRIVATE)
            .setCategory(Notification.CATEGORY_TRANSPORT);
        Intent oeffnen = getPackageManager().getLaunchIntentForPackage(getPackageName());
        if (oeffnen != null) b.setContentIntent(PendingIntent.getActivity(this, 0, oeffnen,
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE));
        if (spielt) b.addAction(new Notification.Action.Builder(android.R.drawable.ic_media_pause,
            intent.getStringExtra("pause"), taste("pause", 1)).build());
        b.addAction(new Notification.Action.Builder(android.R.drawable.ic_media_pause,
            intent.getStringExtra("beenden"), taste("beenden", 2)).build());
        b.setStyle(new Notification.MediaStyle().setMediaSession(sitzung.getSessionToken())
            .setShowActionsInCompactView(spielt ? new int[]{0, 1} : new int[]{0}));
        sitzung.setPlaybackState(new PlaybackState.Builder()
            .setActions(PlaybackState.ACTION_PAUSE | PlaybackState.ACTION_STOP)
            .setState(spielt ? PlaybackState.STATE_PLAYING : PlaybackState.STATE_PAUSED,
                intent.getLongExtra("position", 0), spielt ? 1f : 0f).build());
        startForeground(MELDUNG, b.build());
        return START_NOT_STICKY;
    }
    private PendingIntent taste(String aktion, int nummer) {
        return PendingIntent.getService(this, nummer, new Intent(this, WiedergabeService.class).setAction(aktion),
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
    }
    @Override public void onTaskRemoved(Intent intent) {
        steuern("pause"); stopForeground(true); stopSelf();
    }
    @Override public void onDestroy() {
        if (sitzung != null) { sitzung.setActive(false); sitzung.release(); }
        super.onDestroy();
    }
    @Override public IBinder onBind(Intent intent) { return null; }
}
