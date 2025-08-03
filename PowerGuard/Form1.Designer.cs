using PowerGuard.Resources;
using PowerGuard.Services;

namespace PowerGuard;

partial class MainForm
{
    /// <summary>
    ///  Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    ///  Clean up any resources being used.
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
    ///  Required method for Designer support - do not modify
    ///  the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.components = new System.ComponentModel.Container();

        // Form controls
        this.lblSelectTime = new Label();
        this.dtpShutdownTime = new DateTimePicker();
        this.btnSetTimer = new Button();
        this.lblStatus = new Label();
        this.btnSettings = new Button();

        this.SuspendLayout();

        //
        // lblSelectTime
        //
        this.lblSelectTime.AutoSize = true;
        this.lblSelectTime.Font = new Font("Tahoma", 10F, FontStyle.Regular, GraphicsUnit.Point);
        this.lblSelectTime.Location = new Point(20, 20);
        this.lblSelectTime.Name = "lblSelectTime";
        this.lblSelectTime.RightToLeft = RightToLeft.Yes;
        this.lblSelectTime.Size = new Size(200, 17);
        this.lblSelectTime.TabIndex = 0;
        this.lblSelectTime.Text = Strings.SelectTime;

        //
        // dtpShutdownTime
        //
        this.dtpShutdownTime.CustomFormat = "HH:mm";
        this.dtpShutdownTime.Font = new Font("Tahoma", 12F, FontStyle.Regular, GraphicsUnit.Point);
        this.dtpShutdownTime.Format = DateTimePickerFormat.Custom;
        this.dtpShutdownTime.Location = new Point(20, 50);
        this.dtpShutdownTime.Name = "dtpShutdownTime";
        this.dtpShutdownTime.RightToLeft = RightToLeft.No;
        this.dtpShutdownTime.ShowUpDown = true;
        this.dtpShutdownTime.Size = new Size(120, 27);
        this.dtpShutdownTime.TabIndex = 1;

        //
        // btnSetTimer
        //
        this.btnSetTimer.Font = new Font("Tahoma", 10F, FontStyle.Bold, GraphicsUnit.Point);
        this.btnSetTimer.Location = new Point(160, 45);
        this.btnSetTimer.Name = "btnSetTimer";
        this.btnSetTimer.RightToLeft = RightToLeft.Yes;
        this.btnSetTimer.Size = new Size(150, 35);
        this.btnSetTimer.TabIndex = 2;
        this.btnSetTimer.Text = Strings.SetShutdownTimer;
        this.btnSetTimer.UseVisualStyleBackColor = true;
        this.btnSetTimer.Click += new EventHandler(this.BtnSetTimer_Click);

        //
        // lblStatus
        //
        this.lblStatus.AutoSize = true;
        this.lblStatus.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
        this.lblStatus.ForeColor = Color.DarkBlue;
        this.lblStatus.Location = new Point(20, 100);
        this.lblStatus.Name = "lblStatus";
        this.lblStatus.RightToLeft = RightToLeft.Yes;
        this.lblStatus.Size = new Size(100, 14);
        this.lblStatus.TabIndex = 3;
        this.lblStatus.Text = Strings.NoTimerSet;

        //
        // btnSettings
        //
        this.btnSettings.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
        this.btnSettings.Location = new Point(20, 130);
        this.btnSettings.Name = "btnSettings";
        this.btnSettings.RightToLeft = RightToLeft.Yes;
        this.btnSettings.Size = new Size(100, 30);
        this.btnSettings.TabIndex = 4;
        this.btnSettings.Text = Strings.Settings;
        this.btnSettings.UseVisualStyleBackColor = true;
        this.btnSettings.Click += new EventHandler(this.BtnSettings_Click);

        //
        // MainForm
        //
        this.AutoScaleDimensions = new SizeF(7F, 15F);
        this.AutoScaleMode = AutoScaleMode.Font;
        this.ClientSize = new Size(350, 180);
        this.Controls.Add(this.btnSettings);
        this.Controls.Add(this.lblStatus);
        this.Controls.Add(this.btnSetTimer);
        this.Controls.Add(this.dtpShutdownTime);
        this.Controls.Add(this.lblSelectTime);
        this.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
        this.FormBorderStyle = FormBorderStyle.FixedSingle;
        this.MaximizeBox = false;
        this.Name = "MainForm";
        this.RightToLeft = RightToLeft.Yes;
        this.RightToLeftLayout = true;
        this.StartPosition = FormStartPosition.CenterScreen;
        this.Text = Strings.MainFormTitle;

        this.ResumeLayout(false);
        this.PerformLayout();
    }

    #endregion

    private Label lblSelectTime;
    private DateTimePicker dtpShutdownTime;
    private Button btnSetTimer;
    private Label lblStatus;
    private Button btnSettings;
}
