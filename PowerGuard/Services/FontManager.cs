using System.Drawing.Text;
using System.Runtime.InteropServices;

namespace PowerGuard.Services
{
    public static class FontManager
    {
        private static PrivateFontCollection? privateFonts;
        private static Font? vazirMatnThin;
        private static Font? vazirMatnExtraLight;
        private static Font? vazirMatnLight;
        private static Font? vazirMatnRegular;
        private static Font? vazirMatnMedium;
        private static Font? vazirMatnSemiBold;
        private static Font? vazirMatnBold;
        private static Font? vazirMatnExtraBold;
        private static Font? vazirMatnBlack;

        // Font family names
        public const string VazirMatnFamilyName = "Vazirmatn";

        // Default fallback fonts for Persian
        public const string FallbackFontName = "Tahoma";

        // Font weight enumeration
        public enum VazirMatnWeight
        {
            Thin = 100,
            ExtraLight = 200,
            Light = 300,
            Regular = 400,
            Medium = 500,
            SemiBold = 600,
            Bold = 700,
            ExtraBold = 800,
            Black = 900
        }

        static FontManager()
        {
            LoadFonts();
        }

        /// <summary>
        /// Load Vazir Matn fonts from embedded resources or files
        /// </summary>
        private static void LoadFonts()
        {
            try
            {
                privateFonts = new PrivateFontCollection();
                
                // Try to load fonts from Resources/Fonts directory
                var fontDirectory = Path.Combine(Application.StartupPath, "Resources", "Fonts");

                if (Directory.Exists(fontDirectory))
                {
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-Thin.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-ExtraLight.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-Light.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-Regular.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-Medium.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-SemiBold.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-Bold.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-ExtraBold.ttf"));
                    LoadFontFromFile(Path.Combine(fontDirectory, "Vazirmatn-Black.ttf"));
                }

                // Try to load from embedded resources as fallback
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-Thin.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-ExtraLight.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-Light.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-Regular.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-Medium.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-SemiBold.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-Bold.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-ExtraBold.ttf");
                LoadFontFromResource("PowerGuard.Resources.Fonts.Vazirmatn-Black.ttf");

                // Create font instances
                CreateFontInstances();
                
                Logger.LogInfo("Vazir Matn fonts loaded successfully");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to load Vazir Matn fonts: {ex.Message}");
                Logger.LogInfo("Falling back to system fonts");
            }
        }

        /// <summary>
        /// Load font from file path
        /// </summary>
        private static void LoadFontFromFile(string fontPath)
        {
            try
            {
                if (File.Exists(fontPath) && privateFonts != null)
                {
                    privateFonts.AddFontFile(fontPath);
                    Logger.LogInfo($"Loaded font from file: {Path.GetFileName(fontPath)}");
                }
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to load font from file {fontPath}: {ex.Message}");
            }
        }

        /// <summary>
        /// Load font from embedded resource
        /// </summary>
        private static void LoadFontFromResource(string resourceName)
        {
            try
            {
                var assembly = System.Reflection.Assembly.GetExecutingAssembly();
                using var stream = assembly.GetManifestResourceStream(resourceName);
                
                if (stream != null && privateFonts != null)
                {
                    var fontData = new byte[stream.Length];
                    stream.Read(fontData, 0, fontData.Length);
                    
                    var fontPtr = Marshal.AllocCoTaskMem(fontData.Length);
                    Marshal.Copy(fontData, 0, fontPtr, fontData.Length);
                    
                    privateFonts.AddMemoryFont(fontPtr, fontData.Length);
                    Marshal.FreeCoTaskMem(fontPtr);
                    
                    Logger.LogInfo($"Loaded font from resource: {resourceName}");
                }
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to load font from resource {resourceName}: {ex.Message}");
            }
        }

        /// <summary>
        /// Create font instances from loaded font families
        /// </summary>
        private static void CreateFontInstances()
        {
            if (privateFonts == null) return;

            foreach (var fontFamily in privateFonts.Families)
            {
                if (fontFamily.Name.Contains("Vazirmatn") || fontFamily.Name.Contains("VazirMatn"))
                {
                    try
                    {
                        // Create instances for all available weights
                        if (fontFamily.IsStyleAvailable(FontStyle.Regular))
                        {
                            vazirMatnThin = new Font(fontFamily, 9F, FontStyle.Regular);
                            vazirMatnExtraLight = new Font(fontFamily, 9F, FontStyle.Regular);
                            vazirMatnLight = new Font(fontFamily, 9F, FontStyle.Regular);
                            vazirMatnRegular = new Font(fontFamily, 9F, FontStyle.Regular);
                            vazirMatnMedium = new Font(fontFamily, 9F, FontStyle.Regular);
                            vazirMatnSemiBold = new Font(fontFamily, 9F, FontStyle.Regular);
                        }

                        if (fontFamily.IsStyleAvailable(FontStyle.Bold))
                        {
                            vazirMatnBold = new Font(fontFamily, 9F, FontStyle.Bold);
                            vazirMatnExtraBold = new Font(fontFamily, 9F, FontStyle.Bold);
                            vazirMatnBlack = new Font(fontFamily, 9F, FontStyle.Bold);
                        }

                        Logger.LogInfo($"Created font instances for family: {fontFamily.Name}");
                    }
                    catch (Exception ex)
                    {
                        Logger.LogError($"Failed to create font instances for {fontFamily.Name}: {ex.Message}");
                    }
                }
            }
        }

        /// <summary>
        /// Get Vazir Matn font with specified size and style
        /// </summary>
        public static Font GetVazirMatnFont(float size = 9F, FontStyle style = FontStyle.Regular)
        {
            try
            {
                Font? baseFont = style switch
                {
                    FontStyle.Bold => vazirMatnBold,
                    FontStyle.Regular => vazirMatnRegular,
                    _ => vazirMatnRegular
                };

                if (baseFont != null && privateFonts?.Families.Length > 0)
                {
                    var fontFamily = privateFonts.Families.FirstOrDefault(f =>
                        f.Name.Contains("Vazirmatn") || f.Name.Contains("VazirMatn"));

                    if (fontFamily != null && fontFamily.IsStyleAvailable(style))
                    {
                        return new Font(fontFamily, size, style);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to get Vazir Matn font: {ex.Message}");
            }

            // Fallback to Tahoma for Persian text
            return new Font(FallbackFontName, size, style);
        }

        /// <summary>
        /// Get Vazir Matn font with specified weight
        /// </summary>
        public static Font GetVazirMatnFont(float size, VazirMatnWeight weight)
        {
            try
            {
                Font? baseFont = weight switch
                {
                    VazirMatnWeight.Thin => vazirMatnThin,
                    VazirMatnWeight.ExtraLight => vazirMatnExtraLight,
                    VazirMatnWeight.Light => vazirMatnLight,
                    VazirMatnWeight.Regular => vazirMatnRegular,
                    VazirMatnWeight.Medium => vazirMatnMedium,
                    VazirMatnWeight.SemiBold => vazirMatnSemiBold,
                    VazirMatnWeight.Bold => vazirMatnBold,
                    VazirMatnWeight.ExtraBold => vazirMatnExtraBold,
                    VazirMatnWeight.Black => vazirMatnBlack,
                    _ => vazirMatnRegular
                };

                if (baseFont != null && privateFonts?.Families.Length > 0)
                {
                    var fontFamily = privateFonts.Families.FirstOrDefault(f =>
                        f.Name.Contains("Vazirmatn") || f.Name.Contains("VazirMatn"));

                    if (fontFamily != null)
                    {
                        // Use regular style since weight is handled by different font files
                        return new Font(fontFamily, size, FontStyle.Regular);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to get Vazir Matn font with weight {weight}: {ex.Message}");
            }

            // Fallback to Tahoma for Persian text
            var fallbackStyle = weight >= VazirMatnWeight.Bold ? FontStyle.Bold : FontStyle.Regular;
            return new Font(FallbackFontName, size, fallbackStyle);
        }

        /// <summary>
        /// Apply Vazir Matn font to a control and all its children
        /// </summary>
        public static void ApplyVazirMatnFont(Control control, float? fontSize = null, FontStyle? fontStyle = null)
        {
            try
            {
                var size = fontSize ?? control.Font.Size;
                var style = fontStyle ?? control.Font.Style;
                
                control.Font = GetVazirMatnFont(size, style);
                
                // Apply to all child controls recursively
                foreach (Control child in control.Controls)
                {
                    ApplyVazirMatnFont(child, fontSize, fontStyle);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to apply Vazir Matn font to control {control.Name}: {ex.Message}");
            }
        }

        /// <summary>
        /// Apply Vazir Matn font to a form and all its controls
        /// </summary>
        public static void ApplyVazirMatnFontToForm(Form form)
        {
            try
            {
                // Set form font
                form.Font = GetVazirMatnFont(9F, FontStyle.Regular);
                
                // Apply to all controls
                ApplyVazirMatnFont(form);
                
                Logger.LogInfo($"Applied Vazir Matn font to form: {form.Name}");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to apply Vazir Matn font to form {form.Name}: {ex.Message}");
            }
        }

        /// <summary>
        /// Check if Vazir Matn fonts are available
        /// </summary>
        public static bool IsVazirMatnAvailable()
        {
            return vazirMatnRegular != null && privateFonts?.Families.Length > 0;
        }

        /// <summary>
        /// Get available font families
        /// </summary>
        public static string[] GetAvailableFontFamilies()
        {
            if (privateFonts == null) return Array.Empty<string>();
            
            return privateFonts.Families.Select(f => f.Name).ToArray();
        }

        /// <summary>
        /// Cleanup resources
        /// </summary>
        public static void Dispose()
        {
            try
            {
                vazirMatnThin?.Dispose();
                vazirMatnExtraLight?.Dispose();
                vazirMatnLight?.Dispose();
                vazirMatnRegular?.Dispose();
                vazirMatnMedium?.Dispose();
                vazirMatnSemiBold?.Dispose();
                vazirMatnBold?.Dispose();
                vazirMatnExtraBold?.Dispose();
                vazirMatnBlack?.Dispose();
                privateFonts?.Dispose();
            }
            catch (Exception ex)
            {
                Logger.LogError($"Error disposing font resources: {ex.Message}");
            }
        }
    }
}
