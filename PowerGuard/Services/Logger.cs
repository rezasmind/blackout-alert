using PowerGuard.Resources;

namespace PowerGuard.Services
{
    public static class Logger
    {
        private static readonly string LogPath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
            "PowerGuard",
            "log.txt"
        );

        private static readonly object lockObject = new object();

        public static void LogInfo(string message)
        {
            WriteLog("INFO", message);
        }

        public static void LogWarning(string message)
        {
            WriteLog("WARNING", message);
        }

        public static void LogError(string message)
        {
            WriteLog("ERROR", message);
        }

        public static void LogAppStarted()
        {
            LogInfo(Strings.LogAppStarted);
        }

        public static void LogTimerSet(DateTime shutdownTime)
        {
            LogInfo(string.Format(Strings.LogTimerSet, shutdownTime.ToString(Strings.DateTimeFormat)));
        }

        public static void LogWarningIssued(int minutes)
        {
            LogInfo(string.Format(Strings.LogWarningIssued, minutes));
        }

        public static void LogShutdownInitiated()
        {
            LogInfo(Strings.LogShutdownInitiated);
        }

        public static void LogShutdownCancelled()
        {
            LogInfo(Strings.LogShutdownCancelled);
        }

        public static void LogRecurringScheduleActivated(string schedule)
        {
            LogInfo(string.Format(Strings.LogRecurringScheduleActivated, schedule));
        }

        private static void WriteLog(string level, string message)
        {
            try
            {
                lock (lockObject)
                {
                    var directory = Path.GetDirectoryName(LogPath);
                    if (!Directory.Exists(directory))
                    {
                        Directory.CreateDirectory(directory!);
                    }

                    var logEntry = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] [{level}] {message}";
                    File.AppendAllText(LogPath, logEntry + Environment.NewLine);

                    // Keep log file size manageable (max 1MB)
                    if (File.Exists(LogPath))
                    {
                        var fileInfo = new FileInfo(LogPath);
                        if (fileInfo.Length > 1024 * 1024) // 1MB
                        {
                            TruncateLogFile();
                        }
                    }
                }
            }
            catch
            {
                // Silently fail to avoid infinite loops
            }
        }

        private static void TruncateLogFile()
        {
            try
            {
                var lines = File.ReadAllLines(LogPath);
                if (lines.Length > 1000)
                {
                    var recentLines = lines.Skip(lines.Length - 500).ToArray();
                    File.WriteAllLines(LogPath, recentLines);
                }
            }
            catch
            {
                // If truncation fails, delete the file to start fresh
                try
                {
                    File.Delete(LogPath);
                }
                catch
                {
                    // Silently fail
                }
            }
        }
    }
}
