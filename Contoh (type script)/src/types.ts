
export type ThemeType = 'hewan' | 'alam' | 'angkasa' | 'malam' | 'lautan';

export interface ThemeConfig {
  id: ThemeType;
  name: string;
  primary: string;
  secondary: string;
  bgClass: string;
  cardClass: string;
  pattern: string;
  icon: string;
  accent: string;
  widgetBg: string;
  widgetBorder: string;
}

export const THEMES: ThemeConfig[] = [
  {
    id: 'malam',
    name: 'Mode Malam',
    primary: 'bg-[#2C3E50]',
    secondary: 'text-[#95A5A6]',
    bgClass: 'bg-[#121212]',
    cardClass: 'bg-[#1E1E1E] border-[#2C3E50]',
    pattern: 'night-mode-pattern',
    icon: 'https://img.freepik.com/free-vector/moon-stars-cartoon-icon-illustration_138676-2444.jpg',
    accent: 'text-[#F1C40F]',
    widgetBg: 'bg-[#1E1E1E]',
    widgetBorder: 'border-[#2C3E50]'
  },
  {
    id: 'angkasa',
    name: 'Angkasa',
    primary: 'bg-[#6C5CE7]',
    secondary: 'text-[#A29BFE]',
    bgClass: 'bg-[#2D3436]',
    cardClass: 'bg-[#3D4446] border-[#6C5CE7]/30',
    pattern: 'cosmic-discovery-pattern',
    icon: 'https://img.freepik.com/free-vector/cute-astronaut-floating-with-planet-cartoon-vector-icon-illustration_138676-2355.jpg',
    accent: 'text-[#FAB1A0]',
    widgetBg: 'bg-[#3D4446]',
    widgetBorder: 'border-[#6C5CE7]'
  },
  {
    id: 'alam',
    name: 'Alam',
    primary: 'bg-[#A8E6CF]',
    secondary: 'text-[#006D4E]',
    bgClass: 'bg-[#F2F7F5]',
    cardClass: 'bg-white border-[#A8E6CF]',
    pattern: 'nature-learning-pattern',
    icon: 'https://img.freepik.com/free-vector/landscape-park-with-green-trees-path-mountains_107791-3252.jpg',
    accent: 'text-[#FFAAA5]',
    widgetBg: 'bg-white',
    widgetBorder: 'border-[#A8E6CF]'
  },
  {
    id: 'hewan',
    name: 'Hewan',
    primary: 'bg-[#FF9A00]',
    secondary: 'text-[#827569]',
    bgClass: 'bg-[#FDF6E9]',
    cardClass: 'bg-white border-[#FF9A00]/20',
    pattern: 'wild-bright-pattern',
    icon: 'https://img.freepik.com/free-vector/cheerful-rabbit-cartoon-character_1308-164745.jpg',
    accent: 'text-[#FF6B6B]',
    widgetBg: 'bg-white',
    widgetBorder: 'border-[#FF9A00]'
  },
  {
    id: 'lautan',
    name: 'Lautan',
    primary: 'bg-[#00CEC9]',
    secondary: 'text-[#0984E3]',
    bgClass: 'bg-[#EBF7FF]',
    cardClass: 'bg-white border-[#00CEC9]/30',
    pattern: 'sea-waves-pattern',
    icon: 'https://img.freepik.com/free-vector/underwater-background-with-sea-plant-cartoon_1308-142855.jpg',
    accent: 'text-[#74B9FF]',
    widgetBg: 'bg-white',
    widgetBorder: 'border-[#00CEC9]'
  }
];
