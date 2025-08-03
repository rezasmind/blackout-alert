using PowerGuard.Models;
using PowerGuard.Resources;
using PowerGuard.Services;

namespace PowerGuard.Forms
{
    public partial class SettingsForm : Form
    {
        public AppSettings Settings { get; private set; }

        public SettingsForm(AppSettings settings)
        {
            InitializeComponent();

            // Apply Vazir Matn font (temporarily disabled)
            // FontManager.ApplyVazirMatnFontToForm(this);

            Settings = new AppSettings
            {
                StartWithWindows = settings.StartWithWindows,
                WarningTimeMinutes = settings.WarningTimeMinutes,
                ShutdownTimeMinutes = settings.ShutdownTimeMinutes,
                EnableSmartReminders = settings.EnableSmartReminders,
                ReminderTime = settings.ReminderTime,
                EnableRecurringSchedule = settings.EnableRecurringSchedule,
                RecurringType = settings.RecurringType,
                RecurringTime = settings.RecurringTime,
                WeeklyDays = new List<DayOfWeek>(settings.WeeklyDays),
                FirstRun = settings.FirstRun,
                LastReminderShown = settings.LastReminderShown
            };
            
            LoadSettings();
        }

        private void LoadSettings()
        {
            // General Settings
            chkStartWithWindows.Checked = Settings.StartWithWindows;
            numWarningTime.Value = Settings.WarningTimeMinutes;
            numShutdownTime.Value = Settings.ShutdownTimeMinutes;
            
            // Smart Reminders
            chkEnableSmartReminders.Checked = Settings.EnableSmartReminders;
            dtpReminderTime.Value = DateTime.Today.Add(Settings.ReminderTime);
            
            // Recurring Schedules
            chkEnableRecurring.Checked = Settings.EnableRecurringSchedule;
            cmbRecurringType.SelectedIndex = (int)Settings.RecurringType;
            dtpRecurringTime.Value = DateTime.Today.Add(Settings.RecurringTime);
            
            // Weekly days
            chkMonday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Monday);
            chkTuesday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Tuesday);
            chkWednesday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Wednesday);
            chkThursday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Thursday);
            chkFriday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Friday);
            chkSaturday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Saturday);
            chkSunday.Checked = Settings.WeeklyDays.Contains(DayOfWeek.Sunday);
            
            UpdateControlStates();
        }

        private void SaveSettings()
        {
            // General Settings
            Settings.StartWithWindows = chkStartWithWindows.Checked;
            Settings.WarningTimeMinutes = (int)numWarningTime.Value;
            Settings.ShutdownTimeMinutes = (int)numShutdownTime.Value;
            
            // Smart Reminders
            Settings.EnableSmartReminders = chkEnableSmartReminders.Checked;
            Settings.ReminderTime = dtpReminderTime.Value.TimeOfDay;
            
            // Recurring Schedules
            Settings.EnableRecurringSchedule = chkEnableRecurring.Checked;
            Settings.RecurringType = (RecurringType)cmbRecurringType.SelectedIndex;
            Settings.RecurringTime = dtpRecurringTime.Value.TimeOfDay;
            
            // Weekly days
            Settings.WeeklyDays.Clear();
            if (chkMonday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Monday);
            if (chkTuesday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Tuesday);
            if (chkWednesday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Wednesday);
            if (chkThursday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Thursday);
            if (chkFriday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Friday);
            if (chkSaturday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Saturday);
            if (chkSunday.Checked) Settings.WeeklyDays.Add(DayOfWeek.Sunday);
        }

        private void UpdateControlStates()
        {
            // Enable/disable smart reminder controls
            dtpReminderTime.Enabled = chkEnableSmartReminders.Checked;
            
            // Enable/disable recurring schedule controls
            cmbRecurringType.Enabled = chkEnableRecurring.Checked;
            dtpRecurringTime.Enabled = chkEnableRecurring.Checked;
            
            // Enable/disable weekly day controls
            bool enableWeeklyDays = chkEnableRecurring.Checked && cmbRecurringType.SelectedIndex == 1; // Weekly
            chkMonday.Enabled = enableWeeklyDays;
            chkTuesday.Enabled = enableWeeklyDays;
            chkWednesday.Enabled = enableWeeklyDays;
            chkThursday.Enabled = enableWeeklyDays;
            chkFriday.Enabled = enableWeeklyDays;
            chkSaturday.Enabled = enableWeeklyDays;
            chkSunday.Enabled = enableWeeklyDays;
        }

        private void ChkEnableSmartReminders_CheckedChanged(object sender, EventArgs e)
        {
            UpdateControlStates();
        }

        private void ChkEnableRecurring_CheckedChanged(object sender, EventArgs e)
        {
            UpdateControlStates();
        }

        private void CmbRecurringType_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateControlStates();
        }

        private void BtnSave_Click(object sender, EventArgs e)
        {
            // Validate settings
            if (numWarningTime.Value <= numShutdownTime.Value)
            {
                MessageBox.Show(
                    "زمان هشدار باید بیشتر از زمان خاموشی باشد.",
                    Strings.ErrorTitle,
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            if (chkEnableRecurring.Checked && cmbRecurringType.SelectedIndex == 1 && !Settings.WeeklyDays.Any())
            {
                MessageBox.Show(
                    "لطفاً حداقل یک روز از هفته را انتخاب کنید.",
                    Strings.ErrorTitle,
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            SaveSettings();
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void BtnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
    }
}
