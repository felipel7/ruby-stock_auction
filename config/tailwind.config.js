const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        darker: {
          '50': '#cdd0e4',
          '100': '#b5bad6',
          '200': '#9ea4c8',
          '300': '#888fb8',
          '400': '#727aa8',
          '500': '#5f6795',
          '600': '#53597c',
          '700': '#454a64',
          '800': '#373a4d',
          '900': '#282a36',
          '950': '#1e2028',
        },
        dark: {
          '50': '#f7f7fb',
          '100': '#dfe1ed',
          '200': '#c7cadf',
          '300': '#b1b5d0',
          '400': '#9ba0c0',
          '500': '#858bb0',
          '600': '#71779f',
          '700': '#606689',
          '800': '#525771',
          '900': '#44475a',
          '950': '#44475a',
        },
        cyan: {
          '50': '#fafeff',
          '100': '#d4f8ff',
          '200': '#aff0fe',
          '300': '#8be9fd',
          '400': '#67e1fb',
          '500': '#44d9f8',
          '600': '#22d0f5',
          '700': '#0dbfe5',
          '800': '#0ca0bf',
          '900': '#0c819a',
          'DEFAULT': '#8be9fd',
        },
        pink: {
          '50': '#ffeaf6',
          '100': '#ffc4e6',
          '200': '#ff9fd6',
          '300': '#ff79c6',
          '400': '#fd55b6',
          '500': '#fb31a5',
          '600': '#f80e95',
          '700': '#d90880',
          '800': '#b3086b',
          '900': '#8e0855',
          'DEFAULT': '#ff79c6',
        },
        red: {
          '50': '#ffecec',
          '100': '#ffc6c6',
          '200': '#ffa0a0',
          '300': '#ff7b7b',
          '400': '#ff5555',
          '500': '#fd3131',
          '600': '#fb0e0e',
          '700': '#dd0606',
          '800': '#b70707',
          '900': '#910707',
          'DEFAULT': '#ff5555',
        }
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('flowbite/plugin')
  ]
}
