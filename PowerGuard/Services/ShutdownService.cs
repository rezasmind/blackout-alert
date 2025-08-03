using System.Diagnostics;
using PowerGuard.Resources;

namespace PowerGuard.Services
{
    public static class ShutdownService
    {
        public static bool InitiateShutdown()
        {
            try
            {
                Logger.LogShutdownInitiated();
                
                // Use shutdown command with immediate shutdown
                var processInfo = new ProcessStartInfo
                {
                    FileName = "shutdown.exe",
                    Arguments = "/s /t 0",
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                Process.Start(processInfo);
                return true;
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to initiate shutdown: {ex.Message}");
                MessageBox.Show(
                    Strings.ErrorShutdownFailed,
                    Strings.ErrorTitle,
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                );
                return false;
            }
        }

        public static bool CancelShutdown()
        {
            try
            {
                Logger.LogShutdownCancelled();
                
                // Cancel any pending shutdown
                var processInfo = new ProcessStartInfo
                {
                    FileName = "shutdown.exe",
                    Arguments = "/a",
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                Process.Start(processInfo);
                return true;
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to cancel shutdown: {ex.Message}");
                return false;
            }
        }
    }
}
