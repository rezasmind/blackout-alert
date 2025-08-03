using System.Text.Json;
using PowerGuard.Services;

namespace PowerGuard.Models
{
    public class AppSettings
    {
        public bool StartWithWindows { get; set; } = true;
        public int WarningTimeMinutes { get; set; } = 7;
        public int ShutdownTimeMinutes { get; set; } = 5;
        public bool EnableSmartReminders { get; set; } = true;
        public TimeSpan ReminderTime { get; set; } = new TimeSpan(11, 0, 0); // 11:00 AM
        public bool EnableRecurringSchedule { get; set; } = false;
        public RecurringType RecurringType { get; set; } = RecurringType.Daily;
        public TimeSpan RecurringTime { get; set; } = new TimeSpan(14, 0, 0); // 2:00 PM
        public List<DayOfWeek> WeeklyDays { get; set; } = new List<DayOfWeek>();
        public bool FirstRun { get; set; } = true;
        public DateTime? LastReminderShown { get; set; }

        private static readonly string SettingsPath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
            "PowerGuard",
            "settings.json"
        );

        public static AppSettings Load()
        {
            try
            {
                if (File.Exists(SettingsPath))
                {
                    var json = File.ReadAllText(SettingsPath);
                    var settings = JsonSerializer.Deserialize<AppSettings>(json);
                    return settings ?? new AppSettings();
                }
            }
            catch (Exception ex)
            {
                // Log error but continue with default settings
                Logger.LogError($"Failed to load settings: {ex.Message}");
            }

            return new AppSettings();
        }

        public void Save()
        {
            try
            {
                var directory = Path.GetDirectoryName(SettingsPath);
                if (!Directory.Exists(directory))
                {
                    Directory.CreateDirectory(directory!);
                }

                var json = JsonSerializer.Serialize(this, new JsonSerializerOptions
                {
                    WriteIndented = true
                });

                File.WriteAllText(SettingsPath, json);
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to save settings: {ex.Message}");
            }
        }
    }

    public enum RecurringType
    {
        Daily,
        Weekly
    }
}
