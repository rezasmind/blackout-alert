using PowerGuard.Resources;

namespace PowerGuard.Forms
{
    partial class ShutdownWarningForm
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
            this.lblCountdown = new Label();
            this.lblMessage = new Label();
            this.btnCancel = new Button();
            this.pictureBox = new PictureBox();
            
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            this.SuspendLayout();
            
            // 
            // pictureBox
            // 
            this.pictureBox.Image = SystemIcons.Warning.ToBitmap();
            this.pictureBox.Location = new Point(20, 20);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new Size(48, 48);
            this.pictureBox.SizeMode = PictureBoxSizeMode.StretchImage;
            this.pictureBox.TabIndex = 0;
            this.pictureBox.TabStop = false;
            
            // 
            // lblCountdown
            // 
            this.lblCountdown.Font = new Font("Tahoma", 14F, FontStyle.Bold, GraphicsUnit.Point);
            this.lblCountdown.ForeColor = Color.Red;
            this.lblCountdown.Location = new Point(80, 20);
            this.lblCountdown.Name = "lblCountdown";
            this.lblCountdown.RightToLeft = RightToLeft.Yes;
            this.lblCountdown.Size = new Size(400, 30);
            this.lblCountdown.TabIndex = 1;
            this.lblCountdown.Text = string.Format(Strings.ShutdownInProgress, 30);
            this.lblCountdown.TextAlign = ContentAlignment.MiddleCenter;
            
            // 
            // lblMessage
            // 
            this.lblMessage.Font = new Font("Tahoma", 10F, FontStyle.Regular, GraphicsUnit.Point);
            this.lblMessage.Location = new Point(80, 60);
            this.lblMessage.Name = "lblMessage";
            this.lblMessage.RightToLeft = RightToLeft.Yes;
            this.lblMessage.Size = new Size(400, 40);
            this.lblMessage.TabIndex = 2;
            this.lblMessage.Text = Strings.ClickToCancelShutdown;
            this.lblMessage.TextAlign = ContentAlignment.MiddleCenter;
            
            // 
            // btnCancel
            // 
            this.btnCancel.BackColor = Color.FromArgb(255, 128, 128);
            this.btnCancel.Font = new Font("Tahoma", 12F, FontStyle.Bold, GraphicsUnit.Point);
            this.btnCancel.Location = new Point(200, 120);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.RightToLeft = RightToLeft.Yes;
            this.btnCancel.Size = new Size(150, 50);
            this.btnCancel.TabIndex = 3;
            this.btnCancel.Text = Strings.Cancel;
            this.btnCancel.UseVisualStyleBackColor = false;
            this.btnCancel.Click += new EventHandler(this.BtnCancel_Click);
            
            // 
            // ShutdownWarningForm
            // 
            this.AutoScaleDimensions = new SizeF(7F, 15F);
            this.AutoScaleMode = AutoScaleMode.Font;
            this.BackColor = Color.LightYellow;
            this.ClientSize = new Size(500, 200);
            this.ControlBox = false;
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.lblMessage);
            this.Controls.Add(this.lblCountdown);
            this.Controls.Add(this.pictureBox);
            this.Font = new Font("Tahoma", 9F, FontStyle.Regular, GraphicsUnit.Point);
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ShutdownWarningForm";
            this.RightToLeft = RightToLeft.Yes;
            this.RightToLeftLayout = true;
            this.ShowIcon = false;
            this.ShowInTaskbar = true;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Text = Strings.PowerOutageAlert;
            this.TopMost = true;
            
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            this.ResumeLayout(false);
        }

        #endregion

        private Label lblCountdown;
        private Label lblMessage;
        private Button btnCancel;
        private PictureBox pictureBox;
    }
}
