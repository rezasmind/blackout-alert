using PowerGuard.Models;
using PowerGuard.Resources;
using PowerGuard.Services;
using PowerGuard.Forms;

namespace PowerGuard;

public partial class MainForm : Form
{
    private AppSettings settings = null!;
    private NotifyIcon notifyIcon = null!;
    private ContextMenuStrip trayMenu = null!;
    private System.Windows.Forms.Timer mainTimer = null!;
    private System.Windows.Forms.Timer reminderTimer = null!;
    private DateTime? scheduledShutdownTime;
    private bool warningShown = false;

    public MainForm()
    {
        InitializeComponent();
        InitializeApplication();
    }

    private void InitializeApplication()
    {
        // Load settings
        settings = AppSettings.Load();

        // Apply font to the form (temporarily disabled)
        // FontManager.ApplyVazirMatnFontToForm(this);

        // Initialize system tray
        InitializeSystemTray();

        // Initialize timers
        InitializeTimers();

        // Handle first run
        if (settings.FirstRun)
        {
            ShowWelcomeScreen();
            settings.FirstRun = false;
            settings.Save();
        }

        // Set up startup if enabled
        if (settings.StartWithWindows)
        {
            StartupManager.SetStartupEnabled(true);
        }

        // Hide main window initially
        this.WindowState = FormWindowState.Minimized;
        this.ShowInTaskbar = false;
        this.Visible = false;

        // Set up recurring schedule if enabled
        SetupRecurringSchedule();
    }

    private void InitializeSystemTray()
    {
        // Create context menu
        trayMenu = new ContextMenuStrip();
        trayMenu.Items.Add(Strings.ShowMainWindow, null, ShowMainWindow_Click);
        trayMenu.Items.Add("-");
        trayMenu.Items.Add(Strings.Settings, null, Settings_Click);
        trayMenu.Items.Add("-");
        trayMenu.Items.Add(Strings.Exit, null, Exit_Click);

        // Create notify icon
        notifyIcon = new NotifyIcon()
        {
            Icon = this.Icon,
            ContextMenuStrip = trayMenu,
            Text = Strings.AppTitle,
            Visible = true
        };

        notifyIcon.DoubleClick += ShowMainWindow_Click;
        notifyIcon.MouseMove += NotifyIcon_MouseMove;
    }

    private void InitializeTimers()
    {
        // Main timer for checking shutdown time
        mainTimer = new System.Windows.Forms.Timer();
        mainTimer.Interval = 1000; // Check every second
        mainTimer.Tick += MainTimer_Tick;

        // Reminder timer for smart reminders
        reminderTimer = new System.Windows.Forms.Timer();
        reminderTimer.Interval = 60000; // Check every minute
        reminderTimer.Tick += ReminderTimer_Tick;

        if (settings.EnableSmartReminders)
        {
            reminderTimer.Start();
        }
    }

    private void ShowWelcomeScreen()
    {
        using var welcomeForm = new WelcomeForm(settings);
        welcomeForm.ShowDialog(this);
    }

    private void SetupRecurringSchedule()
    {
        if (!settings.EnableRecurringSchedule) return;

        var now = DateTime.Now;
        DateTime nextScheduledTime;

        if (settings.RecurringType == RecurringType.Daily)
        {
            nextScheduledTime = now.Date.Add(settings.RecurringTime);
            if (nextScheduledTime <= now)
            {
                nextScheduledTime = nextScheduledTime.AddDays(1);
            }
        }
        else // Weekly
        {
            nextScheduledTime = GetNextWeeklySchedule(now);
        }

        if (nextScheduledTime > now)
        {
            SetShutdownTimer(nextScheduledTime);
            Logger.LogRecurringScheduleActivated(nextScheduledTime.ToString(Strings.DateTimeFormat));
        }
    }

    private DateTime GetNextWeeklySchedule(DateTime now)
    {
        if (!settings.WeeklyDays.Any()) return now.AddDays(1);

        var today = now.DayOfWeek;
        var todayTime = now.Date.Add(settings.RecurringTime);

        // Check if today is a scheduled day and time hasn't passed
        if (settings.WeeklyDays.Contains(today) && todayTime > now)
        {
            return todayTime;
        }

        // Find next scheduled day
        for (int i = 1; i <= 7; i++)
        {
            var checkDay = (DayOfWeek)(((int)today + i) % 7);
            if (settings.WeeklyDays.Contains(checkDay))
            {
                return now.Date.AddDays(i).Add(settings.RecurringTime);
            }
        }

        return now.AddDays(1); // Fallback
    }

    private void SetShutdownTimer(DateTime shutdownTime)
    {
        scheduledShutdownTime = shutdownTime;
        warningShown = false;
        mainTimer.Start();

        UpdateUI();
        Logger.LogTimerSet(shutdownTime);
    }

    private void CancelShutdownTimer()
    {
        scheduledShutdownTime = null;
        warningShown = false;
        mainTimer.Stop();

        UpdateUI();
        Logger.LogShutdownCancelled();
    }

    private void UpdateUI()
    {
        if (scheduledShutdownTime.HasValue)
        {
            btnSetTimer.Text = Strings.CancelShutdown;
            lblStatus.Text = string.Format(Strings.ShutdownScheduledFor,
                scheduledShutdownTime.Value.ToString(Strings.TimeFormat));
        }
        else
        {
            btnSetTimer.Text = Strings.SetShutdownTimer;
            lblStatus.Text = Strings.NoTimerSet;
        }
    }

    private void MainTimer_Tick(object sender, EventArgs e)
    {
        if (!scheduledShutdownTime.HasValue) return;

        var now = DateTime.Now;
        var timeUntilShutdown = scheduledShutdownTime.Value - now;

        // Show warning at configured time before shutdown
        if (!warningShown && timeUntilShutdown.TotalMinutes <= settings.WarningTimeMinutes && timeUntilShutdown.TotalMinutes > settings.ShutdownTimeMinutes)
        {
            NotificationService.ShowWarningNotification(settings.WarningTimeMinutes, notifyIcon);
            warningShown = true;
        }

        // Initiate shutdown at configured time before outage
        if (timeUntilShutdown.TotalMinutes <= settings.ShutdownTimeMinutes)
        {
            mainTimer.Stop();
            ShowShutdownDialog();
        }
    }

    private void ShowShutdownDialog()
    {
        using var shutdownForm = new ShutdownWarningForm();
        var result = shutdownForm.ShowDialog(this);

        if (result == DialogResult.Cancel)
        {
            CancelShutdownTimer();
        }
        else
        {
            ShutdownService.InitiateShutdown();
            Application.Exit();
        }
    }

    private void ReminderTimer_Tick(object sender, EventArgs e)
    {
        if (!settings.EnableSmartReminders) return;
        if (scheduledShutdownTime.HasValue) return; // Timer already set

        var now = DateTime.Now;
        var reminderTime = now.Date.Add(settings.ReminderTime);

        // Show reminder if it's time and we haven't shown it today
        if (now >= reminderTime &&
            (!settings.LastReminderShown.HasValue || settings.LastReminderShown.Value.Date < now.Date))
        {
            NotificationService.ShowSmartReminder(notifyIcon);
            settings.LastReminderShown = now;
            settings.Save();
        }
    }

    private void NotifyIcon_MouseMove(object sender, MouseEventArgs e)
    {
        if (scheduledShutdownTime.HasValue)
        {
            var timeRemaining = scheduledShutdownTime.Value - DateTime.Now;
            if (timeRemaining.TotalSeconds > 0)
            {
                var timeString = FormatTimeSpan(timeRemaining);
                notifyIcon.Text = string.Format(Strings.ShutdownIn, timeString);
            }
            else
            {
                notifyIcon.Text = Strings.AppTitle;
            }
        }
        else
        {
            notifyIcon.Text = Strings.AppTitle;
        }
    }

    private string FormatTimeSpan(TimeSpan timeSpan)
    {
        if (timeSpan.TotalDays >= 1)
            return $"{(int)timeSpan.TotalDays}d {timeSpan.Hours}h {timeSpan.Minutes}m";
        else if (timeSpan.TotalHours >= 1)
            return $"{timeSpan.Hours}h {timeSpan.Minutes}m {timeSpan.Seconds}s";
        else
            return $"{timeSpan.Minutes}m {timeSpan.Seconds}s";
    }

    private void ShowMainWindow_Click(object sender, EventArgs e)
    {
        this.Show();
        this.WindowState = FormWindowState.Normal;
        this.ShowInTaskbar = true;
        this.BringToFront();
        this.Activate();
    }

    private void Settings_Click(object sender, EventArgs e)
    {
        using var settingsForm = new SettingsForm(settings);
        if (settingsForm.ShowDialog(this) == DialogResult.OK)
        {
            settings = settingsForm.Settings;
            settings.Save();

            // Update startup setting
            StartupManager.SetStartupEnabled(settings.StartWithWindows);

            // Update reminder timer
            if (settings.EnableSmartReminders)
                reminderTimer.Start();
            else
                reminderTimer.Stop();

            // Update recurring schedule
            SetupRecurringSchedule();
        }
    }

    private void Exit_Click(object sender, EventArgs e)
    {
        var result = MessageBox.Show(
            Strings.ConfirmExit,
            Strings.ConfirmTitle,
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question
        );

        if (result == DialogResult.Yes)
        {
            Application.Exit();
        }
    }

    protected override void SetVisibleCore(bool value)
    {
        base.SetVisibleCore(value && !settings.FirstRun);
    }

    private void BtnSetTimer_Click(object sender, EventArgs e)
    {
        if (scheduledShutdownTime.HasValue)
        {
            // Cancel existing timer
            CancelShutdownTimer();
        }
        else
        {
            // Set new timer
            var selectedTime = dtpShutdownTime.Value;
            var today = DateTime.Today;
            var shutdownTime = today.Add(selectedTime.TimeOfDay);

            // If time has passed today, schedule for tomorrow
            if (shutdownTime <= DateTime.Now)
            {
                shutdownTime = shutdownTime.AddDays(1);
            }

            SetShutdownTimer(shutdownTime);
        }
    }

    private void BtnSettings_Click(object sender, EventArgs e)
    {
        Settings_Click(sender, e);
    }

    protected override void OnFormClosing(FormClosingEventArgs e)
    {
        if (e.CloseReason == CloseReason.UserClosing)
        {
            e.Cancel = true;
            this.Hide();
            this.ShowInTaskbar = false;
        }
        else
        {
            notifyIcon?.Dispose();
            mainTimer?.Dispose();
            reminderTimer?.Dispose();
        }

        base.OnFormClosing(e);
    }
}
