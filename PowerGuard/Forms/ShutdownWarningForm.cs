using PowerGuard.Resources;
using PowerGuard.Services;

namespace PowerGuard.Forms
{
    public partial class ShutdownWarningForm : Form
    {
        private System.Windows.Forms.Timer countdownTimer = null!;
        private int secondsRemaining = 30;

        public ShutdownWarningForm()
        {
            InitializeComponent();

            // Apply Vazir Matn font (temporarily disabled)
            // FontManager.ApplyVazirMatnFontToForm(this);

            InitializeCountdown();
        }

        private void InitializeCountdown()
        {
            countdownTimer = new System.Windows.Forms.Timer();
            countdownTimer.Interval = 1000; // 1 second
            countdownTimer.Tick += CountdownTimer_Tick;
            countdownTimer.Start();
            
            UpdateCountdownDisplay();
        }

        private void CountdownTimer_Tick(object sender, EventArgs e)
        {
            secondsRemaining--;
            
            if (secondsRemaining <= 0)
            {
                countdownTimer.Stop();
                this.DialogResult = DialogResult.OK; // Proceed with shutdown
                this.Close();
            }
            else
            {
                UpdateCountdownDisplay();
            }
        }

        private void UpdateCountdownDisplay()
        {
            lblCountdown.Text = string.Format(Strings.ShutdownInProgress, secondsRemaining);
        }

        private void BtnCancel_Click(object sender, EventArgs e)
        {
            countdownTimer.Stop();
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            countdownTimer?.Stop();
            countdownTimer?.Dispose();
            base.OnFormClosing(e);
        }

        // Prevent closing with Alt+F4 or X button during countdown
        protected override void OnFormClosed(FormClosedEventArgs e)
        {
            if (this.DialogResult == DialogResult.None)
            {
                this.DialogResult = DialogResult.Cancel;
            }
            base.OnFormClosed(e);
        }
    }
}
