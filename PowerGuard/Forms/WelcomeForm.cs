using PowerGuard.Models;
using PowerGuard.Resources;
using PowerGuard.Services;

namespace PowerGuard.Forms
{
    public partial class WelcomeForm : Form
    {
        public AppSettings Settings { get; private set; }

        public WelcomeForm(AppSettings settings)
        {
            InitializeComponent();
            Settings = settings;

            // Apply Vazir Matn font (temporarily disabled)
            // FontManager.ApplyVazirMatnFontToForm(this);

            // Set initial checkbox state
            chkStartWithWindows.Checked = settings.StartWithWindows;
        }

        private void BtnGetStarted_Click(object sender, EventArgs e)
        {
            Settings.StartWithWindows = chkStartWithWindows.Checked;
            this.DialogResult = DialogResult.OK;
            this.Close();
        }
    }
}
