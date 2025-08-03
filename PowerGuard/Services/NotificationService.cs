using PowerGuard.Resources;

namespace PowerGuard.Services
{
    public static class NotificationService
    {
        public static void ShowWarningNotification(int minutes, NotifyIcon notifyIcon)
        {
            try
            {
                var message = string.Format(Strings.SevenMinuteWarning, minutes);
                
                notifyIcon.ShowBalloonTip(
                    5000, // 5 seconds
                    Strings.PowerOutageAlert,
                    message,
                    ToolTipIcon.Warning
                );

                Logger.LogWarningIssued(minutes);
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to show warning notification: {ex.Message}");
            }
        }

        public static void ShowSmartReminder(NotifyIcon notifyIcon)
        {
            try
            {
                notifyIcon.ShowBalloonTip(
                    10000, // 10 seconds
                    Strings.SmartReminderTitle,
                    Strings.SmartReminderMessage,
                    ToolTipIcon.Info
                );

                Logger.LogInfo("Smart reminder shown");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to show smart reminder: {ex.Message}");
            }
        }
    }
}
