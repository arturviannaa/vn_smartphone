/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        sans: ['"SF Pro Display"', 'Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        'vn-primary': 'var(--vn-primary)',
        'ios-bg': 'var(--ios-bg)',
        'ios-card': 'var(--ios-card)',
        'ios-glass': 'var(--ios-glass)',
        'ios-divider': 'var(--ios-divider)',
      },
      borderRadius: {
        'ios-sm': '12px',
        'ios-md': '18px',
        'ios-lg': '24px',
        'ios-xl': '32px',
        'ios-full': '9999px',
      },
      backdropBlur: {
        'ios': '30px',
      }
    },
  },
  plugins: [],
}