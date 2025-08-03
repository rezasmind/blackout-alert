using PowerGuard.Services;
using System.Globalization;

namespace PowerGuard;

static class Program
{
    private static Mutex? mutex;
    private const string MutexName = "PowerGuard_SingleInstance_Mutex";

    /// <summary>
    ///  The main entry point for the application.
    /// </summary>
    [STAThread]
    static void Main()
    {
        // Ensure single instance
        mutex = new Mutex(true, MutexName, out bool createdNew);

        if (!createdNew)
        {
            // Another instance is already running
            MessageBox.Show("محافظ برق در حال اجرا است.", "محافظ برق", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        try
        {
            // Set Persian culture for proper RTL support
            var persianCulture = new CultureInfo("fa-IR");
            Thread.CurrentThread.CurrentCulture = persianCulture;
            Thread.CurrentThread.CurrentUICulture = persianCulture;

            // Configure application
            ApplicationConfiguration.Initialize();
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            // Initialize font manager for Persian text support (temporarily disabled)
            // This will load Vazir Matn fonts if available
            // var fontsAvailable = FontManager.IsVazirMatnAvailable();
            // Logger.LogInfo($"Vazir Matn fonts available: {fontsAvailable}");

            // Log application start
            Logger.LogAppStarted();

            // Run the main form
            Application.Run(new MainForm());
        }
        finally
        {
            mutex?.ReleaseMutex();
            mutex?.Dispose();
        }
    }
}