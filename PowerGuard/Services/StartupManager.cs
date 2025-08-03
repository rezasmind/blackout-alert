using Microsoft.Win32;
using PowerGuard.Resources;

namespace PowerGuard.Services
{
    public static class StartupManager
    {
        private const string AppName = "PowerGuard";
        private const string RegistryKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run";

        public static bool IsStartupEnabled()
        {
            try
            {
                using var key = Registry.CurrentUser.OpenSubKey(RegistryKey, false);
                return key?.GetValue(AppName) != null;
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to check startup status: {ex.Message}");
                return false;
            }
        }

        public static bool SetStartupEnabled(bool enabled)
        {
            try
            {
                using var key = Registry.CurrentUser.OpenSubKey(RegistryKey, true);
                if (key == null)
                {
                    Logger.LogError("Failed to open registry key for startup management");
                    return false;
                }

                if (enabled)
                {
                    var exePath = Application.ExecutablePath;
                    key.SetValue(AppName, $"\"{exePath}\"");
                    Logger.LogInfo($"Startup enabled: {exePath}");
                }
                else
                {
                    key.DeleteValue(AppName, false);
                    Logger.LogInfo("Startup disabled");
                }

                return true;
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to set startup status: {ex.Message}");
                MessageBox.Show(
                    Strings.ErrorStartupRegistration,
                    Strings.ErrorTitle,
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return false;
            }
        }
    }
}
