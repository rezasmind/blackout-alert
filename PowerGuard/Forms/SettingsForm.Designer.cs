using PowerGuard.Resources;

namespace PowerGuard.Forms
{
    partial class SettingsForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            // General Settings Group
            this.grpGeneral = new GroupBox();
            this.chkStartWithWindows = new CheckBox();
            this.lblWarningTime = new Label();
            this.numWarningTime = new NumericUpDown();
            this.lblShutdownTime = new Label();
            this.numShutdownTime = new NumericUpDown();
            
            // Smart Reminders Group
            this.grpSmartReminders = new GroupBox();
            this.chkEnableSmartReminders = new CheckBox();
            this.lblReminderTime = new Label();
            this.dtpReminderTime = new DateTimePicker();
            
            // Recurring Schedules Group
            this.grpRecurring = new GroupBox();
            this.chkEnableRecurring = new CheckBox();
            this.lblRecurringType = new Label();
            this.cmbRecurringType = new ComboBox();
            this.lblRecurringTime = new Label();
            this.dtpRecurringTime = new DateTimePicker();
            this.lblWeeklyDays = new Label();
            this.chkMonday = new CheckBox();
            this.chkTuesday = new CheckBox();
            this.chkWednesday = new CheckBox();
            this.chkThursday = new CheckBox();
            this.chkFriday = new CheckBox();
            this.chkSaturday = new CheckBox();
            this.chkSunday = new CheckBox();
            
            // Buttons
            this.btnSave = new Button();
            this.btnCancel = new Button();
            
            this.grpGeneral.SuspendLayout();
            this.grpSmartReminders.SuspendLayout();
            this.grpRecurring.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numWarningTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numShutdownTime)).BeginInit();
            this.SuspendLayout();
            
            // 
            // grpGeneral
            // 
            this.grpGeneral.Controls.Add(this.numShutdownTime);
            this.grpGeneral.Controls.Add(this.lblShutdownTime);
            this.grpGeneral.Controls.Add(this.numWarningTime);
            this.grpGeneral.Controls.Add(this.lblWarningTime);
            this.grpGeneral.Controls.Add(this.chkStartWithWindows);
            this.grpGeneral.Font = new Font("Tahoma", 10F, FontStyle.Bold, GraphicsUnit.Point);
            this.grpGeneral.Location = new Point(12, 12);
            this.grpGeneral.Name = "grpGeneral";
            this.grpGeneral.RightToLeft = RightToLeft.Yes;
            this.grpGeneral.Size = new Size(460, 120);
            this.grpGeneral.TabIndex = 0;
            this.grpGeneral.TabStop = false;
            this.grpGeneral.Text = Strings.GeneralSettings;
            
            // 
            // chkStartWithWindows
            // 
            this.chkStartWithWindows.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkStartWithWindows.Location = new Point(20, 25);
            this.chkStartWithWindows.Name = "chkStartWithWindows";
            this.chkStartWithWindows.RightToLeft = RightToLeft.Yes;
            this.chkStartWithWindows.Size = new Size(420, 24);
            this.chkStartWithWindows.TabIndex = 0;
            this.chkStartWithWindows.Text = Strings.StartWithWindows;
            this.chkStartWithWindows.UseVisualStyleBackColor = true;
            
            // 
            // lblWarningTime
            // 
            this.lblWarningTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblWarningTime.Location = new Point(280, 55);
            this.lblWarningTime.Name = "lblWarningTime";
            this.lblWarningTime.RightToLeft = RightToLeft.Yes;
            this.lblWarningTime.Size = new Size(160, 20);
            this.lblWarningTime.TabIndex = 1;
            this.lblWarningTime.Text = Strings.WarningTime;
            this.lblWarningTime.TextAlign = ContentAlignment.MiddleRight;
            
            // 
            // numWarningTime
            // 
            this.numWarningTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.numWarningTime.Location = new Point(220, 55);
            this.numWarningTime.Maximum = new decimal(new int[] { 60, 0, 0, 0 });
            this.numWarningTime.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            this.numWarningTime.Name = "numWarningTime";
            this.numWarningTime.RightToLeft = RightToLeft.No;
            this.numWarningTime.Size = new Size(50, 22);
            this.numWarningTime.TabIndex = 2;
            this.numWarningTime.Value = new decimal(new int[] { 7, 0, 0, 0 });
            
            // 
            // lblShutdownTime
            // 
            this.lblShutdownTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblShutdownTime.Location = new Point(280, 85);
            this.lblShutdownTime.Name = "lblShutdownTime";
            this.lblShutdownTime.RightToLeft = RightToLeft.Yes;
            this.lblShutdownTime.Size = new Size(160, 20);
            this.lblShutdownTime.TabIndex = 3;
            this.lblShutdownTime.Text = Strings.ShutdownTime;
            this.lblShutdownTime.TextAlign = ContentAlignment.MiddleRight;
            
            // 
            // numShutdownTime
            // 
            this.numShutdownTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.numShutdownTime.Location = new Point(220, 85);
            this.numShutdownTime.Maximum = new decimal(new int[] { 30, 0, 0, 0 });
            this.numShutdownTime.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            this.numShutdownTime.Name = "numShutdownTime";
            this.numShutdownTime.RightToLeft = RightToLeft.No;
            this.numShutdownTime.Size = new Size(50, 22);
            this.numShutdownTime.TabIndex = 4;
            this.numShutdownTime.Value = new decimal(new int[] { 5, 0, 0, 0 });
            
            // 
            // grpSmartReminders
            // 
            this.grpSmartReminders.Controls.Add(this.dtpReminderTime);
            this.grpSmartReminders.Controls.Add(this.lblReminderTime);
            this.grpSmartReminders.Controls.Add(this.chkEnableSmartReminders);
            this.grpSmartReminders.Font = new Font("Tahoma", 10F, FontStyle.Bold, GraphicsUnit.Point);
            this.grpSmartReminders.Location = new Point(12, 145);
            this.grpSmartReminders.Name = "grpSmartReminders";
            this.grpSmartReminders.RightToLeft = RightToLeft.Yes;
            this.grpSmartReminders.Size = new Size(460, 80);
            this.grpSmartReminders.TabIndex = 1;
            this.grpSmartReminders.TabStop = false;
            this.grpSmartReminders.Text = "یادآوری هوشمند";
            
            // 
            // chkEnableSmartReminders
            // 
            this.chkEnableSmartReminders.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkEnableSmartReminders.Location = new Point(20, 25);
            this.chkEnableSmartReminders.Name = "chkEnableSmartReminders";
            this.chkEnableSmartReminders.RightToLeft = RightToLeft.Yes;
            this.chkEnableSmartReminders.Size = new Size(420, 24);
            this.chkEnableSmartReminders.TabIndex = 0;
            this.chkEnableSmartReminders.Text = Strings.EnableSmartReminders;
            this.chkEnableSmartReminders.UseVisualStyleBackColor = true;
            this.chkEnableSmartReminders.CheckedChanged += new EventHandler(this.ChkEnableSmartReminders_CheckedChanged);
            
            // 
            // lblReminderTime
            // 
            this.lblReminderTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblReminderTime.Location = new Point(280, 55);
            this.lblReminderTime.Name = "lblReminderTime";
            this.lblReminderTime.RightToLeft = RightToLeft.Yes;
            this.lblReminderTime.Size = new Size(160, 20);
            this.lblReminderTime.TabIndex = 1;
            this.lblReminderTime.Text = Strings.ReminderTime;
            this.lblReminderTime.TextAlign = ContentAlignment.MiddleRight;
            
            // 
            // dtpReminderTime
            // 
            this.dtpReminderTime.CustomFormat = "HH:mm";
            this.dtpReminderTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.dtpReminderTime.Format = DateTimePickerFormat.Custom;
            this.dtpReminderTime.Location = new Point(180, 55);
            this.dtpReminderTime.Name = "dtpReminderTime";
            this.dtpReminderTime.RightToLeft = RightToLeft.No;
            this.dtpReminderTime.ShowUpDown = true;
            this.dtpReminderTime.Size = new Size(90, 22);
            this.dtpReminderTime.TabIndex = 2;
            
            // 
            // grpRecurring
            // 
            this.grpRecurring.Controls.Add(this.chkSunday);
            this.grpRecurring.Controls.Add(this.chkSaturday);
            this.grpRecurring.Controls.Add(this.chkFriday);
            this.grpRecurring.Controls.Add(this.chkThursday);
            this.grpRecurring.Controls.Add(this.chkWednesday);
            this.grpRecurring.Controls.Add(this.chkTuesday);
            this.grpRecurring.Controls.Add(this.chkMonday);
            this.grpRecurring.Controls.Add(this.lblWeeklyDays);
            this.grpRecurring.Controls.Add(this.dtpRecurringTime);
            this.grpRecurring.Controls.Add(this.lblRecurringTime);
            this.grpRecurring.Controls.Add(this.cmbRecurringType);
            this.grpRecurring.Controls.Add(this.lblRecurringType);
            this.grpRecurring.Controls.Add(this.chkEnableRecurring);
            this.grpRecurring.Font = new Font("Tahoma", 10F, FontStyle.Bold, GraphicsUnit.Point);
            this.grpRecurring.Location = new Point(12, 240);
            this.grpRecurring.Name = "grpRecurring";
            this.grpRecurring.RightToLeft = RightToLeft.Yes;
            this.grpRecurring.Size = new Size(460, 200);
            this.grpRecurring.TabIndex = 2;
            this.grpRecurring.TabStop = false;
            this.grpRecurring.Text = Strings.RecurringSchedules;
            
            // 
            // chkEnableRecurring
            // 
            this.chkEnableRecurring.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkEnableRecurring.Location = new Point(20, 25);
            this.chkEnableRecurring.Name = "chkEnableRecurring";
            this.chkEnableRecurring.RightToLeft = RightToLeft.Yes;
            this.chkEnableRecurring.Size = new Size(420, 24);
            this.chkEnableRecurring.TabIndex = 0;
            this.chkEnableRecurring.Text = Strings.EnableRecurring;
            this.chkEnableRecurring.UseVisualStyleBackColor = true;
            this.chkEnableRecurring.CheckedChanged += new EventHandler(this.ChkEnableRecurring_CheckedChanged);
            
            // 
            // lblRecurringType
            // 
            this.lblRecurringType.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblRecurringType.Location = new Point(280, 55);
            this.lblRecurringType.Name = "lblRecurringType";
            this.lblRecurringType.RightToLeft = RightToLeft.Yes;
            this.lblRecurringType.Size = new Size(160, 20);
            this.lblRecurringType.TabIndex = 1;
            this.lblRecurringType.Text = Strings.RecurringType;
            this.lblRecurringType.TextAlign = ContentAlignment.MiddleRight;
            
            // 
            // cmbRecurringType
            // 
            this.cmbRecurringType.DropDownStyle = ComboBoxStyle.DropDownList;
            this.cmbRecurringType.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.cmbRecurringType.Items.AddRange(new object[] { Strings.Daily, Strings.Weekly });
            this.cmbRecurringType.Location = new Point(180, 55);
            this.cmbRecurringType.Name = "cmbRecurringType";
            this.cmbRecurringType.RightToLeft = RightToLeft.Yes;
            this.cmbRecurringType.Size = new Size(90, 22);
            this.cmbRecurringType.TabIndex = 2;
            this.cmbRecurringType.SelectedIndexChanged += new EventHandler(this.CmbRecurringType_SelectedIndexChanged);
            
            // 
            // lblRecurringTime
            // 
            this.lblRecurringTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblRecurringTime.Location = new Point(280, 85);
            this.lblRecurringTime.Name = "lblRecurringTime";
            this.lblRecurringTime.RightToLeft = RightToLeft.Yes;
            this.lblRecurringTime.Size = new Size(160, 20);
            this.lblRecurringTime.TabIndex = 3;
            this.lblRecurringTime.Text = Strings.RecurringTime;
            this.lblRecurringTime.TextAlign = ContentAlignment.MiddleRight;
            
            // 
            // dtpRecurringTime
            // 
            this.dtpRecurringTime.CustomFormat = "HH:mm";
            this.dtpRecurringTime.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.dtpRecurringTime.Format = DateTimePickerFormat.Custom;
            this.dtpRecurringTime.Location = new Point(180, 85);
            this.dtpRecurringTime.Name = "dtpRecurringTime";
            this.dtpRecurringTime.RightToLeft = RightToLeft.No;
            this.dtpRecurringTime.ShowUpDown = true;
            this.dtpRecurringTime.Size = new Size(90, 22);
            this.dtpRecurringTime.TabIndex = 4;
            
            // 
            // lblWeeklyDays
            // 
            this.lblWeeklyDays.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblWeeklyDays.Location = new Point(350, 115);
            this.lblWeeklyDays.Name = "lblWeeklyDays";
            this.lblWeeklyDays.RightToLeft = RightToLeft.Yes;
            this.lblWeeklyDays.Size = new Size(90, 20);
            this.lblWeeklyDays.TabIndex = 5;
            this.lblWeeklyDays.Text = Strings.WeeklyDays;
            this.lblWeeklyDays.TextAlign = ContentAlignment.MiddleRight;
            
            // Weekly day checkboxes
            this.chkSaturday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkSaturday.Location = new Point(380, 140);
            this.chkSaturday.Name = "chkSaturday";
            this.chkSaturday.RightToLeft = RightToLeft.Yes;
            this.chkSaturday.Size = new Size(60, 20);
            this.chkSaturday.TabIndex = 6;
            this.chkSaturday.Text = Strings.Saturday;
            this.chkSaturday.UseVisualStyleBackColor = true;
            
            this.chkSunday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkSunday.Location = new Point(310, 140);
            this.chkSunday.Name = "chkSunday";
            this.chkSunday.RightToLeft = RightToLeft.Yes;
            this.chkSunday.Size = new Size(60, 20);
            this.chkSunday.TabIndex = 7;
            this.chkSunday.Text = Strings.Sunday;
            this.chkSunday.UseVisualStyleBackColor = true;
            
            this.chkMonday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkMonday.Location = new Point(240, 140);
            this.chkMonday.Name = "chkMonday";
            this.chkMonday.RightToLeft = RightToLeft.Yes;
            this.chkMonday.Size = new Size(60, 20);
            this.chkMonday.TabIndex = 8;
            this.chkMonday.Text = Strings.Monday;
            this.chkMonday.UseVisualStyleBackColor = true;
            
            this.chkTuesday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkTuesday.Location = new Point(170, 140);
            this.chkTuesday.Name = "chkTuesday";
            this.chkTuesday.RightToLeft = RightToLeft.Yes;
            this.chkTuesday.Size = new Size(60, 20);
            this.chkTuesday.TabIndex = 9;
            this.chkTuesday.Text = Strings.Tuesday;
            this.chkTuesday.UseVisualStyleBackColor = true;
            
            this.chkWednesday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkWednesday.Location = new Point(380, 165);
            this.chkWednesday.Name = "chkWednesday";
            this.chkWednesday.RightToLeft = RightToLeft.Yes;
            this.chkWednesday.Size = new Size(60, 20);
            this.chkWednesday.TabIndex = 10;
            this.chkWednesday.Text = Strings.Wednesday;
            this.chkWednesday.UseVisualStyleBackColor = true;
            
            this.chkThursday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkThursday.Location = new Point(310, 165);
            this.chkThursday.Name = "chkThursday";
            this.chkThursday.RightToLeft = RightToLeft.Yes;
            this.chkThursday.Size = new Size(60, 20);
            this.chkThursday.TabIndex = 11;
            this.chkThursday.Text = Strings.Thursday;
            this.chkThursday.UseVisualStyleBackColor = true;
            
            this.chkFriday.Font = new Font("Tahoma", 8F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkFriday.Location = new Point(240, 165);
            this.chkFriday.Name = "chkFriday";
            this.chkFriday.RightToLeft = RightToLeft.Yes;
            this.chkFriday.Size = new Size(60, 20);
            this.chkFriday.TabIndex = 12;
            this.chkFriday.Text = Strings.Friday;
            this.chkFriday.UseVisualStyleBackColor = true;
            
            // 
            // btnSave
            // 
            this.btnSave.BackColor = Color.LightGreen;
            this.btnSave.Font = new Font("Tahoma", 10F, FontStyle.Bold, GraphicsUnit.Point);
            this.btnSave.Location = new Point(280, 460);
            this.btnSave.Name = "btnSave";
            this.btnSave.RightToLeft = RightToLeft.Yes;
            this.btnSave.Size = new Size(90, 35);
            this.btnSave.TabIndex = 3;
            this.btnSave.Text = Strings.Save;
            this.btnSave.UseVisualStyleBackColor = false;
            this.btnSave.Click += new EventHandler(this.BtnSave_Click);
            
            // 
            // btnCancel
            // 
            this.btnCancel.Font = new Font("Tahoma", 10F, FontStyle.Regular, GraphicsUnit.Point);
            this.btnCancel.Location = new Point(380, 460);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.RightToLeft = RightToLeft.Yes;
            this.btnCancel.Size = new Size(90, 35);
            this.btnCancel.TabIndex = 4;
            this.btnCancel.Text = Strings.Cancel;
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new EventHandler(this.BtnCancel_Click);
            
            // 
            // SettingsForm
            // 
            this.AutoScaleDimensions = new SizeF(7F, 15F);
            this.AutoScaleMode = AutoScaleMode.Font;
            this.ClientSize = new Size(484, 510);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.grpRecurring);
            this.Controls.Add(this.grpSmartReminders);
            this.Controls.Add(this.grpGeneral);
            this.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SettingsForm";
            this.RightToLeft = RightToLeft.Yes;
            this.RightToLeftLayout = true;
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = FormStartPosition.CenterParent;
            this.Text = Strings.SettingsTitle;
            
            this.grpGeneral.ResumeLayout(false);
            this.grpSmartReminders.ResumeLayout(false);
            this.grpRecurring.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.numWarningTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numShutdownTime)).EndInit();
            this.ResumeLayout(false);
        }

        #endregion

        private GroupBox grpGeneral;
        private CheckBox chkStartWithWindows;
        private Label lblWarningTime;
        private NumericUpDown numWarningTime;
        private Label lblShutdownTime;
        private NumericUpDown numShutdownTime;
        
        private GroupBox grpSmartReminders;
        private CheckBox chkEnableSmartReminders;
        private Label lblReminderTime;
        private DateTimePicker dtpReminderTime;
        
        private GroupBox grpRecurring;
        private CheckBox chkEnableRecurring;
        private Label lblRecurringType;
        private ComboBox cmbRecurringType;
        private Label lblRecurringTime;
        private DateTimePicker dtpRecurringTime;
        private Label lblWeeklyDays;
        private CheckBox chkMonday;
        private CheckBox chkTuesday;
        private CheckBox chkWednesday;
        private CheckBox chkThursday;
        private CheckBox chkFriday;
        private CheckBox chkSaturday;
        private CheckBox chkSunday;
        
        private Button btnSave;
        private Button btnCancel;
    }
}
