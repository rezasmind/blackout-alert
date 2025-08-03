using PowerGuard.Resources;

namespace PowerGuard.Forms
{
    partial class WelcomeForm
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
            this.lblTitle = new Label();
            this.lblMessage = new Label();
            this.chkStartWithWindows = new CheckBox();
            this.btnGetStarted = new Button();
            this.pictureBox = new PictureBox();
            
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            this.SuspendLayout();
            
            // 
            // pictureBox
            // 
            this.pictureBox.Image = SystemIcons.Information.ToBitmap();
            this.pictureBox.Location = new Point(20, 20);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new Size(48, 48);
            this.pictureBox.SizeMode = PictureBoxSizeMode.StretchImage;
            this.pictureBox.TabIndex = 0;
            this.pictureBox.TabStop = false;
            
            // 
            // lblTitle
            // 
            this.lblTitle.Font = new Font("Tahoma", 14F, FontStyle.Bold, GraphicsUnit.Point);
            this.lblTitle.ForeColor = Color.DarkBlue;
            this.lblTitle.Location = new Point(80, 20);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.RightToLeft = RightToLeft.Yes;
            this.lblTitle.Size = new Size(400, 30);
            this.lblTitle.TabIndex = 1;
            this.lblTitle.Text = Strings.WelcomeTitle;
            this.lblTitle.TextAlign = ContentAlignment.MiddleCenter;
            
            // 
            // lblMessage
            // 
            this.lblMessage.Font = new Font("Tahoma", 10F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblMessage.Location = new Point(20, 80);
            this.lblMessage.Name = "lblMessage";
            this.lblMessage.RightToLeft = RightToLeft.Yes;
            this.lblMessage.Size = new Size(460, 80);
            this.lblMessage.TabIndex = 2;
            this.lblMessage.Text = Strings.WelcomeMessage;
            this.lblMessage.TextAlign = ContentAlignment.TopCenter;
            
            // 
            // chkStartWithWindows
            // 
            this.chkStartWithWindows.Checked = true;
            this.chkStartWithWindows.CheckState = CheckState.Checked;
            this.chkStartWithWindows.Font = new Font("Tahoma", 10F, FontStyle.Regular, GraphicsUnit.Point);
            this.chkStartWithWindows.Location = new Point(50, 180);
            this.chkStartWithWindows.Name = "chkStartWithWindows";
            this.chkStartWithWindows.RightToLeft = RightToLeft.Yes;
            this.chkStartWithWindows.Size = new Size(400, 24);
            this.chkStartWithWindows.TabIndex = 3;
            this.chkStartWithWindows.Text = Strings.StartAutomatically;
            this.chkStartWithWindows.UseVisualStyleBackColor = true;
            
            // 
            // btnGetStarted
            // 
            this.btnGetStarted.BackColor = Color.LightGreen;
            this.btnGetStarted.Font = new Font("Tahoma", 12F, FontStyle.Bold, GraphicsUnit.Point);
            this.btnGetStarted.Location = new Point(175, 220);
            this.btnGetStarted.Name = "btnGetStarted";
            this.btnGetStarted.RightToLeft = RightToLeft.Yes;
            this.btnGetStarted.Size = new Size(150, 40);
            this.btnGetStarted.TabIndex = 4;
            this.btnGetStarted.Text = Strings.GetStarted;
            this.btnGetStarted.UseVisualStyleBackColor = false;
            this.btnGetStarted.Click += new EventHandler(this.BtnGetStarted_Click);
            
            // 
            // WelcomeForm
            // 
            this.AutoScaleDimensions = new SizeF(7F, 15F);
            this.AutoScaleMode = AutoScaleMode.Font;
            this.BackColor = Color.White;
            this.ClientSize = new Size(500, 280);
            this.Controls.Add(this.btnGetStarted);
            this.Controls.Add(this.chkStartWithWindows);
            this.Controls.Add(this.lblMessage);
            this.Controls.Add(this.lblTitle);
            this.Controls.Add(this.pictureBox);
            this.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "WelcomeForm";
            this.RightToLeft = RightToLeft.Yes;
            this.RightToLeftLayout = true;
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Text = Strings.WelcomeTitle;
            
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            this.ResumeLayout(false);
        }

        #endregion

        private Label lblTitle;
        private Label lblMessage;
        private CheckBox chkStartWithWindows;
        private Button btnGetStarted;
        private PictureBox pictureBox;
    }
}
