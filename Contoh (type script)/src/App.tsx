/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { 
  Home, 
  Star, 
  Rabbit, 
  ALargeSmall, 
  Hash, 
  Shapes, 
  BookOpen, 
  Music, 
  LayoutGrid, 
  Users,
  Volume2,
  ArrowRight,
  GraduationCap,
  CheckCircle2,
  Trophy,
  ArrowUpRight,
  ChevronLeft,
  ChevronRight,
  Shuffle,
  Mic,
  MicOff,
  Video,
  Play,
  Pause,
  RotateCcw,
  LogOut,
  Palette,
  Sun,
  Cloud,
  Rocket,
  Moon,
  Fish,
  Anchor
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { gsap } from 'gsap';
import { onAuthStateChanged, signOut, User as FirebaseUser } from 'firebase/auth';
import { auth, db, handleFirestoreError, OperationType } from './lib/firebase';
import { collection, addDoc, getDocs, onSnapshot } from 'firebase/firestore';
import { AuthScreen } from './components/AuthScreen';
import { LETTERS_DATA, IQRA_DATA, SONGS_DATA, NUMBERS_DATA, OBJECTS_DATA } from './constants';
import { THEMES, ThemeType } from './types';

type TabType = 'main' | 'belajar' | 'akun' | 'lagu' | 'admin';
const ADMIN_EMAIL = 'andibayu8310@gmail.com'; 

export default function App() {
  const [user, setUser] = useState<FirebaseUser | null>(null);
  const [authLoading, setAuthLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<TabType>('main');
  const [belajarSubMode, setBelajarSubMode] = useState<'menu' | 'huruf' | 'angka' | 'benda' | 'iqra'>('menu');
  const [activeThemeId, setActiveThemeId] = useState<ThemeType>('hewan');
  
  const currentTheme = THEMES.find(t => t.id === activeThemeId) || THEMES[0];
  const isDark = activeThemeId === 'angkasa' || activeThemeId === 'malam';

  // Progression state
  const [progression, setProgression] = useState({
    membaca: 65,
    angka: 40,
    benda: 85,
    iqra: 25
  });

  const updateProgress = (category: keyof typeof progression, newPercent: number) => {
    setProgression(prev => ({ ...prev, [category]: newPercent }));
  };

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (u) => {
      setUser(u);
      setAuthLoading(false);
    });
    return () => unsubscribe();
  }, []);

  if (authLoading) {
    return (
      <div className="min-h-screen bg-surface flex items-center justify-center">
        <div className="flex flex-col items-center gap-4">
          <div className="w-20 h-20 bg-primary/20 rounded-full animate-bounce flex items-center justify-center">
            <Rabbit size={48} className="text-primary" />
          </div>
          <p className="font-headline font-black text-primary uppercase tracking-widest text-xl">Loading...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <AuthScreen />;
  }

  const navigateToBelajar = (mode: 'menu' | 'huruf' | 'angka' | 'benda' | 'iqra') => {
    setBelajarSubMode(mode);
    setActiveTab('belajar');
  };

  const renderScreen = () => {
    switch (activeTab) {
      case 'main':
        return <MainScreen currentTheme={currentTheme} onNavigate={(tab) => setActiveTab(tab)} onNavigateBelajar={navigateToBelajar} />;
      case 'belajar':
        return <BelajarScreen currentTheme={currentTheme} initialMode={belajarSubMode} onBack={() => setActiveTab('main')} onProgressUpdate={(cat, p) => updateProgress(cat as any, p)} />;
      case 'akun':
        return <AkunScreen 
          currentTheme={currentTheme}
          progression={progression} 
          onNavigateToAdmin={() => setActiveTab('admin')} 
          activeTheme={activeThemeId}
          onThemeChange={setActiveThemeId}
        />;
      case 'admin':
        return <AdminScreen currentTheme={currentTheme} onBack={() => setActiveTab('main')} />;
      case 'lagu':
        return <LaguScreen currentTheme={currentTheme} onBack={() => setActiveTab('main')} />;
      default:
        return <MainScreen currentTheme={currentTheme} onNavigate={(tab) => setActiveTab(tab)} onNavigateBelajar={navigateToBelajar} />;
    }
  };

  return (
    <div className={`min-h-screen ${currentTheme.bgClass} font-sans ${isDark ? 'text-white' : 'text-on-surface'} overflow-x-hidden relative ${currentTheme.pattern}`}>
      <ThemeDecorations activeThemeId={activeThemeId} />
      {/* Main Content Area */}
      <main className="pt-8 pb-32 px-4 md:px-6 max-w-6xl mx-auto min-h-screen">
        <AnimatePresence mode="wait">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
          >
            {renderScreen()}
          </motion.div>
        </AnimatePresence>
      </main>

      {/* Bottom Navigation */}
      <nav className={`fixed bottom-0 left-0 w-full z-50 ${isDark ? 'bg-[#1E1E1E] border-slate-800 shadow-[0_-8px_30px_rgba(0,0,0,0.4)]' : 'bg-white border-slate-100 shadow-[0_-8px_30px_rgba(0,0,0,0.08)]'} border-t-4 rounded-t-3xl transition-colors duration-500`}>
        <div className="max-w-6xl mx-auto flex justify-around items-center h-24 px-4">
          <NavButton 
            active={activeTab === 'main'} 
            onClick={() => setActiveTab('main')} 
            icon={<LayoutGrid size={24} />} 
            label="Main" 
            theme={currentTheme}
          />
          <NavButton 
            active={activeTab === 'belajar'} 
            onClick={() => navigateToBelajar('menu')} 
            icon={<BookOpen size={24} />} 
            label="Belajar" 
            theme={currentTheme}
          />
          <NavButton 
            active={activeTab === 'lagu'} 
            onClick={() => setActiveTab('lagu')} 
            icon={<Music size={24} />} 
            label="Lagu" 
            theme={currentTheme}
          />
          <NavButton 
            active={activeTab === 'akun'} 
            onClick={() => setActiveTab('akun')} 
            icon={<Users size={24} />} 
            label="Akun" 
            theme={currentTheme}
          />
        </div>
      </nav>
    </div>
  );
}

function NavButton({ active, onClick, icon, label, theme }: { active: boolean, onClick: () => void, icon: React.ReactNode, label: string, theme: any }) {
  const isDark = theme.id === 'angkasa' || theme.id === 'malam';
  
  // Use theme colors for active state
  const activeBg = active ? (isDark ? 'bg-white/10' : 'bg-slate-50') : '';
  const activeText = active ? (isDark ? (theme.accent.replace('text-', '') !== theme.accent ? theme.accent : 'text-white') : (theme.secondary || 'text-primary')) : 'text-slate-400';
  
  return (
    <motion.button 
      whileTap={{ scale: 0.9 }}
      onClick={onClick}
      className={`flex flex-col items-center justify-center p-3 sm:px-6 rounded-2xl transition-all duration-300 ${activeBg} ${active ? 'shadow-sm' : 'hover:bg-white/5'}`}
    >
      <motion.div 
        animate={active ? { scale: 1.1, y: -2 } : { scale: 1, y: 0 }}
        className={activeText}
      >
        {React.cloneElement(icon as React.ReactElement, { size: 26, strokeWidth: active ? 2.5 : 2 })}
      </motion.div>
      <span className={`font-headline font-black text-[10px] uppercase tracking-tighter mt-1 ${active ? 'opacity-100' : 'opacity-0 h-0 overflow-hidden'} ${activeText}`}>
        {label}
      </span>
    </motion.button>
  );
}

/* --- Screens --- */

function MainScreen({ onNavigate, onNavigateBelajar, currentTheme }: { onNavigate: (tab: TabType) => void, onNavigateBelajar: (mode: any) => void, currentTheme: any }) {
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';
  const childName = auth.currentUser?.displayName || 'Teman';
  const containerRef = React.useRef<HTMLDivElement>(null);
  const [hoveredMode, setHoveredMode] = useState<string | null>(null);

  useEffect(() => {
    if (containerRef.current) {
      const buttons = containerRef.current.querySelectorAll('.menu-button-item');
      gsap.fromTo(buttons, 
        { opacity: 0, y: 30, scale: 0.9 },
        { 
          opacity: 1, 
          y: 0, 
          scale: 1, 
          duration: 0.6, 
          stagger: 0.1, 
          ease: "elastic.out(1, 0.5)" 
        }
      );
    }
  }, []);

  const modeLogos: Record<string, string> = {
    'huruf': 'src/assets/Logo_Membaca.png',
    'angka': 'src/assets/Logo_123.png',
    'benda': 'src/assets/Logo_Benda.png',
    'iqra': 'src/assets/Logo_iqra.png'
  };

  const themeImages: Record<string, string> = {
    'malam': 'src/assets/Mode_Malam.png',
    'alam': 'src/assets/Mode_Alam.png',
    'angkasa': 'src/assets/Mode_Angkasa.png',
    'hewan': 'src/assets/Mode_Hewan.png',
    'lautan': 'src/assets/Mode_Laut.png'
  };

  return (
    <div ref={containerRef} className="flex flex-col gap-6">
      <div className={`${currentTheme.widgetBg} rounded-3xl border-b-4 ${currentTheme.widgetBorder} shadow-sm relative overflow-hidden flex items-center justify-between min-h-[160px]`}>
        <div className="absolute inset-0 z-0">
          <img 
            src={themeImages[currentTheme.id] || "src/assets/Anak_hebat.png"} 
            alt={currentTheme.id} 
            className="w-full h-full object-cover opacity-30 md:opacity-40" 
          />
          <div className={`absolute inset-0 bg-gradient-to-r ${isDark ? 'from-slate-900/80' : 'from-white/60'} to-transparent z-1`} />
        </div>
        
        <div className="z-10 w-full pl-6 pr-4 py-6">
          <h2 className={`font-headline text-3xl md:text-4xl font-black ${isDark ? 'text-white' : 'text-on-surface'} mb-2 drop-shadow-sm`}>Halo, {childName}! 👋</h2>
          <p className={`font-headline text-lg md:text-xl font-bold ${isDark ? 'text-slate-200' : 'text-slate-600'} drop-shadow-sm`}>Ayo, petualangan belajar dimulai!</p>
        </div>
        
        <div className="relative z-10 pr-6 flex-shrink-0 hidden md:flex items-center justify-center">
          <motion.div 
            animate={{ y: [0, -10, 0] }}
            transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
            className="w-32 h-32 flex items-center justify-center"
          >
            <img 
              src="src/assets/Anak_hebat.png" 
              alt="Anak Hebat" 
              className="w-full h-full object-contain drop-shadow-2xl" 
            />
          </motion.div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Belajar Box */}
        <div className={`menu-button-item col-span-1 md:col-span-2 ${currentTheme.widgetBg} rounded-[2.5rem] border-b-8 ${currentTheme.widgetBorder} p-8 shadow-md relative overflow-hidden group`}>
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-8 z-10 relative">
            <div className="flex flex-col">
              <span className={`font-headline font-black ${currentTheme.id === 'angkasa' || currentTheme.id === 'malam' ? 'text-[#A29BFE]' : 'text-primary'} uppercase tracking-widest text-3xl mb-2`}>Pusat Belajar</span>
              <span className={`font-headline font-bold ${currentTheme.id === 'malam' ? 'text-slate-400' : 'text-slate-500'} text-lg mb-6`}>Pilih petualanganmu hari ini!</span>
              
              <div className="grid grid-cols-1 sm:grid-cols-4 gap-4 mt-2">
                <button 
                  onMouseEnter={() => setHoveredMode('huruf')}
                  onMouseLeave={() => setHoveredMode(null)}
                  onClick={() => onNavigateBelajar('huruf')} 
                  className="flex flex-row sm:flex-col items-center gap-4 sm:gap-2 group/btn bg-white/5 sm:bg-transparent p-3 sm:p-0 rounded-2xl sm:rounded-none"
                >
                  <div className="w-14 h-14 sm:w-16 sm:h-16 bg-red-100 rounded-2xl flex items-center justify-center border-2 border-red-200 group-hover/btn:scale-110 transition-transform shadow-sm flex-shrink-0">
                    <img src="src/assets/Logo_Membaca.png" alt="Membaca" className="w-10 h-10 sm:w-12 sm:h-12 object-contain" />
                  </div>
                  <span className={`font-headline font-black text-sm sm:text-[10px] uppercase tracking-widest ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>Huruf</span>
                </button>
                <button 
                  onMouseEnter={() => setHoveredMode('angka')}
                  onMouseLeave={() => setHoveredMode(null)}
                  onClick={() => onNavigateBelajar('angka')} 
                  className="flex flex-row sm:flex-col items-center gap-4 sm:gap-2 group/btn bg-white/5 sm:bg-transparent p-3 sm:p-0 rounded-2xl sm:rounded-none"
                >
                  <div className="w-14 h-14 sm:w-16 sm:h-16 bg-blue-100 rounded-2xl flex items-center justify-center border-2 border-blue-200 group-hover/btn:scale-110 transition-transform shadow-sm flex-shrink-0">
                    <img src="src/assets/Logo_123.png" alt="Angka" className="w-10 h-10 sm:w-12 sm:h-12 object-contain" />
                  </div>
                  <span className={`font-headline font-black text-sm sm:text-[10px] uppercase tracking-widest ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>Angka</span>
                </button>
                <button 
                  onMouseEnter={() => setHoveredMode('benda')}
                  onMouseLeave={() => setHoveredMode(null)}
                  onClick={() => onNavigateBelajar('benda')} 
                  className="flex flex-row sm:flex-col items-center gap-4 sm:gap-2 group/btn bg-white/5 sm:bg-transparent p-3 sm:p-0 rounded-2xl sm:rounded-none"
                >
                  <div className="w-14 h-14 sm:w-16 sm:h-16 bg-green-100 rounded-2xl flex items-center justify-center border-2 border-green-200 group-hover/btn:scale-110 transition-transform shadow-sm flex-shrink-0">
                    <img src="src/assets/Logo_Benda.png" alt="Benda" className="w-10 h-10 sm:w-12 sm:h-12 object-contain" />
                  </div>
                  <span className={`font-headline font-black text-sm sm:text-[10px] uppercase tracking-widest ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>Benda</span>
                </button>
                <button 
                  onMouseEnter={() => setHoveredMode('iqra')}
                  onMouseLeave={() => setHoveredMode(null)}
                  onClick={() => onNavigateBelajar('iqra')} 
                  className="flex flex-row sm:flex-col items-center gap-4 sm:gap-2 group/btn bg-white/5 sm:bg-transparent p-3 sm:p-0 rounded-2xl sm:rounded-none"
                >
                  <div className="w-14 h-14 sm:w-16 sm:h-16 bg-purple-100 rounded-2xl flex items-center justify-center border-2 border-purple-200 group-hover/btn:scale-110 transition-transform shadow-sm flex-shrink-0">
                    <img src="src/assets/Logo_iqra.png" alt="Iqra" className="w-10 h-10 sm:w-12 sm:h-12 object-contain" />
                  </div>
                  <span className={`font-headline font-black text-sm sm:text-[10px] uppercase tracking-widest ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>Iqra</span>
                </button>
              </div>
            </div>
            
            <div className="hidden md:flex w-48 h-48 bg-white/10 rounded-full items-center justify-center border-4 border-dashed border-white/20 animate-spin-slow relative overflow-hidden">
               <AnimatePresence mode="wait">
                 {hoveredMode ? (
                   <motion.img 
                     key={hoveredMode}
                     src={modeLogos[hoveredMode]} 
                     initial={{ opacity: 0, x: 50 }}
                     animate={{ opacity: 1, x: 0 }}
                     exit={{ opacity: 0, x: -30 }}
                     transition={{ duration: 0.3, ease: "easeOut" }}
                     className="w-32 h-32 object-contain drop-shadow-2xl"
                   />
                 ) : (
                   <motion.div
                     key="default"
                     initial={{ opacity: 0 }}
                     animate={{ opacity: 0.4 }}
                     exit={{ opacity: 0 }}
                   >
                     <BookOpen size={80} className={`${currentTheme.id === 'malam' ? 'text-blue-400' : 'text-white'}`} />
                   </motion.div>
                 )}
               </AnimatePresence>
            </div>
          </div>
          
          <div className={`absolute -right-16 -top-16 w-64 h-64 bg-primary/10 rounded-full blur-3xl group-hover:bg-primary/20 transition-colors pointer-events-none`} />
        </div>

        {/* Lagu & Lainnya Group */}
        <div className="flex flex-col gap-6 col-span-1 md:col-span-2">
          <motion.button 
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => onNavigate('lagu')}
            className={`menu-button-item flex-1 ${currentTheme.widgetBg} rounded-[2rem] border-b-8 ${currentTheme.widgetBorder} p-8 flex flex-row items-center justify-between gap-6 shadow-md tactile-press overflow-hidden relative group`}
          >
            <div className="flex flex-col z-10 text-left">
               <span className={`font-headline font-black ${isDark ? 'text-[#F1C40F]' : 'text-pink-500'} uppercase tracking-widest text-3xl`}>Lagu Anak</span>
               <span className={`font-headline font-bold ${isDark ? 'text-slate-300' : 'text-slate-400'} text-sm`}>Bernyanyi bersama koleksi lagu populer!</span>
            </div>
            <div className={`bg-opacity-20 ${currentTheme.id === 'malam' ? 'bg-[#F1C40F]' : 'bg-pink-50'} rounded-3xl w-28 h-28 flex items-center justify-center z-10 border-2 ${currentTheme.id === 'malam' ? 'border-[#F1C40F]/30' : 'border-pink-100'} overflow-hidden`}>
              <img src="src/assets/Logo_Lagu.png" alt="Music" className="w-20 h-20 object-contain group-hover:scale-110 transition-transform" />
            </div>
          </motion.button>
        </div>
      </div>
    </div>
  );
}

function MenuButton({ color, borderColor, shadow, img, label, onClick, icon, theme }: { 
  color: string, 
  borderColor: string, 
  shadow: string, 
  img?: string,
  label: string,
  onClick: () => void,
  icon?: React.ReactNode,
  theme?: any
}) {
  const isDark = theme?.id === 'angkasa' || theme?.id === 'malam';
  const customBorder = theme ? theme.widgetBorder : borderColor;
  const customBg = theme ? theme.widgetBg : 'bg-white';
  const labelColor = isDark ? 'text-slate-100' : 'text-slate-700';

  return (
    <motion.button 
      whileHover={{ scale: 1.02, y: -2 }}
      whileTap={{ scale: 0.98 }}
      onClick={onClick}
      className={`${customBg} ${customBorder} shadow-sm rounded-3xl border-2 p-4 md:p-6 flex flex-row md:flex-col items-center justify-start md:justify-center gap-6 md:gap-4 tactile-press min-h-[100px] md:min-h-[160px] w-full overflow-hidden group transition-shadow hover:shadow-lg`}
    >
      <motion.div 
        className={`w-20 h-20 md:w-32 md:h-32 flex items-center justify-center rounded-2xl group-hover:scale-110 transition-transform flex-shrink-0`}
      >
        {img ? (
          <img src={img} alt={label} className="w-full h-full object-contain" />
        ) : (
          <div className={`${color} w-full h-full rounded-2xl flex items-center justify-center text-white shadow-inner`}>
            {React.cloneElement(icon as React.ReactElement, { size: 40 })}
          </div>
        )}
      </motion.div>
      <span className={`font-headline font-black ${labelColor} uppercase text-left md:text-center tracking-wider text-2xl md:text-sm leading-tight transition-colors`}>
        {label}
      </span>
    </motion.button>
  );
}

function BelajarScreen({ initialMode, onBack, currentTheme, onProgressUpdate }: { initialMode: any, onBack: () => void, currentTheme: any, onProgressUpdate?: (cat: string, p: number) => void }) {
  const [selectedMode, setSelectedMode] = useState<'menu' | 'huruf' | 'angka' | 'benda' | 'iqra'>(initialMode || 'menu');
  const containerRef = React.useRef<HTMLDivElement>(null);
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  const handleBack = () => setSelectedMode('menu');

  if (selectedMode === 'menu') {
    return (
      <div ref={containerRef} className="flex flex-col gap-8 max-w-6xl mx-auto px-4">
        <div className="flex flex-col items-center mb-4">
          <h2 className={`font-headline text-4xl md:text-6xl font-black ${isDark ? 'text-[#A29BFE]' : 'text-secondary'} text-center`}>Pusat Petualangan</h2>
          <div className={`h-2 w-32 ${isDark ? 'bg-[#A29BFE]/30' : 'bg-secondary/20'} rounded-full mt-4`} />
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 md:gap-8">
          <div className="mode-item">
            <MenuButton 
              theme={currentTheme}
              color="bg-red-400" 
              borderColor="border-red-500" 
              shadow="shadow-tactile-orange" 
              img="src/assets/Logo_Membaca.png" 
              label="Membaca" 
              onClick={() => setSelectedMode('huruf')}
            />
          </div>
          <div className="mode-item">
            <MenuButton 
              theme={currentTheme}
              color="bg-blue-400" 
              borderColor="border-blue-500" 
              shadow="shadow-tactile-blue" 
              img="src/assets/Logo_123.png" 
              label="Angka" 
              onClick={() => setSelectedMode('angka')}
            />
          </div>
          <div className="mode-item">
            <MenuButton 
              theme={currentTheme}
              color="bg-green-400" 
              borderColor="border-green-500" 
              shadow="shadow-tactile-green" 
              img="src/assets/Logo_Benda.png" 
              label="Benda" 
              onClick={() => setSelectedMode('benda')}
            />
          </div>
          <div className="mode-item">
            <MenuButton 
              theme={currentTheme}
              color="bg-purple-400" 
              borderColor="border-purple-500" 
              shadow="shadow-tactile-purple" 
              img="src/assets/Logo_iqra.png" 
              label="Iqra" 
              onClick={() => setSelectedMode('iqra')}
            />
          </div>
        </div>

        <div className="flex justify-center mt-8">
           <button 
             onClick={onBack}
             className={`${isDark ? 'bg-slate-800 border-slate-700 text-slate-300' : 'bg-white border-slate-200 text-slate-400'} px-12 py-4 rounded-2xl border-b-4 font-headline font-black uppercase tracking-widest tactile-press shadow-sm`}
           >
             Kembali ke Menu Utama
           </button>
        </div>
      </div>
    );
  }

  switch (selectedMode) {
    case 'huruf': return <HurufScreen currentTheme={currentTheme} onBack={handleBack} onProgressUpdate={(p) => onProgressUpdate?.('membaca', p)} />;
    case 'angka': return <AngkaScreen currentTheme={currentTheme} onBack={handleBack} onProgressUpdate={(p) => onProgressUpdate?.('angka', p)} />;
    case 'benda': return <BendaScreen currentTheme={currentTheme} onBack={handleBack} onProgressUpdate={(p) => onProgressUpdate?.('benda', p)} />;
    case 'iqra': return <IqraScreen currentTheme={currentTheme} onBack={handleBack} onProgressUpdate={(p) => onProgressUpdate?.('iqra', p)} />;
    default: return <div />;
  }
}

function HurufScreen({ onBack, currentTheme, onProgressUpdate }: { onBack: () => void, currentTheme: any, onProgressUpdate?: (p: number) => void }) {
  const [currentLetterIndex, setCurrentLetterIndex] = useState(0);
  const [currentObjectIndex, setCurrentObjectIndex] = useState(0);
  const [isSeruMode, setIsSeruMode] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  const [feedback, setFeedback] = useState<'success' | 'fail' | null>(null);
  const [completedIndices, setCompletedIndices] = useState<Set<number>>(new Set());

  const currentData = LETTERS_DATA[currentLetterIndex] || LETTERS_DATA[0];
  const currentObject = currentData.objects[currentObjectIndex] || currentData.objects[0];
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  const nextChallenge = () => {
    setFeedback(null);
    setCurrentLetterIndex(Math.floor(Math.random() * LETTERS_DATA.length));
  };

  const toggleRecording = () => {
    if (isRecording) {
      setIsRecording(false);
      const isCorrect = Math.random() > 0.3;
      if (isCorrect) {
        setFeedback('success');
        const nextSet = new Set(completedIndices);
        nextSet.add(currentLetterIndex);
        setCompletedIndices(nextSet);
        if (onProgressUpdate) onProgressUpdate(Math.round((nextSet.size / LETTERS_DATA.length) * 100));
      } else {
        setFeedback('fail');
      }
    } else {
      setFeedback(null);
      setIsRecording(true);
    }
  };

  if (isSeruMode) {
    return (
      <div className="flex flex-col items-center gap-8">
        <div className="w-full flex justify-between items-center px-4">
           <button onClick={() => setIsSeruMode(false)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl shadow-sm border-b-4 ${currentTheme.widgetBorder} ${isDark ? 'text-slate-300' : 'text-slate-500'} flex items-center gap-2 font-headline font-black uppercase text-xs tracking-widest`}>
             <ChevronLeft size={20} /> Kembali
           </button>
           <h2 className={`font-headline text-2xl font-black ${isDark ? 'text-orange-300' : 'text-orange-600'} uppercase tracking-widest`}>Kuis Huruf Seru</h2>
           <div className={`px-4 py-2 rounded-full ${isDark ? 'bg-orange-900/40 text-orange-200' : 'bg-orange-100 text-orange-700'} font-headline font-black text-sm`}>
             {completedIndices.size} / {LETTERS_DATA.length}
           </div>
        </div>

        <motion.div 
          key={currentLetterIndex}
          className={`${currentTheme.widgetBg} w-full max-w-[340px] aspect-square rounded-[3rem] border-b-[12px] ${currentTheme.widgetBorder} shadow-xl flex flex-col items-center justify-center relative overflow-hidden`}
        >
          <div className={`font-headline font-black text-[150px] ${isDark ? 'text-white' : 'text-orange-950'} drop-shadow-2xl`}>
            {LETTERS_DATA[currentLetterIndex].letter}
          </div>
          
          <AnimatePresence>
            {feedback && (
              <motion.div 
                initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }}
                className={`absolute bottom-12 px-6 py-3 rounded-2xl border-4 font-headline font-black uppercase tracking-widest shadow-lg ${feedback === 'success' ? 'bg-green-500 border-green-300 text-white' : 'bg-red-500 border-red-300 text-white'}`}
              >
                {feedback === 'success' ? 'Hebat!' : 'Coba lagi yuk!'}
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>

        <div className="flex flex-col items-center gap-6">
           {feedback === 'success' ? (
             <button onClick={nextChallenge} className="bg-orange-500 text-white px-12 py-5 rounded-full border-b-8 border-orange-700 font-headline font-black text-xl shadow-tactile-orange uppercase scale-110">Selanjutnya</button>
           ) : (
             <div className="flex flex-col items-center gap-4">
                <p className={`font-headline font-bold ${isDark ? 'text-slate-400' : 'text-slate-500'} uppercase tracking-[0.2em] text-xs`}>
                  {isRecording ? 'Berhenti...' : 'Pencet & Sebutkan Hurufnya!'}
                </p>
                <button onClick={toggleRecording} className={`w-28 h-28 rounded-full flex items-center justify-center border-b-8 shadow-2xl transition-all ${isRecording ? 'bg-red-500 border-red-700 text-white scale-110' : 'bg-white border-slate-200 text-slate-400'}`}>
                    {isRecording ? <Mic size={48} className="animate-pulse" /> : <MicOff size={48} />}
                </button>
             </div>
           )}
        </div>
      </div>
    );
  }

  const nextLetter = () => {
    setCurrentLetterIndex((prev) => (prev + 1) % LETTERS_DATA.length);
    setCurrentObjectIndex(0);
  };

  const prevLetter = () => {
    setCurrentLetterIndex((prev) => (prev - 1 + LETTERS_DATA.length) % LETTERS_DATA.length);
    setCurrentObjectIndex(0);
  };

  const randomizeObject = () => {
    let next = Math.floor(Math.random() * currentData.objects.length);
    while (next === currentObjectIndex && currentData.objects.length > 1) {
      next = Math.floor(Math.random() * currentData.objects.length);
    }
    setCurrentObjectIndex(next);
  };

  return (
    <div className="flex flex-col items-center">
      <div className="w-full flex items-center justify-between mb-8">
         <button onClick={prevLetter} className={`p-4 ${currentTheme.widgetBg} rounded-2xl border-4 ${currentTheme.widgetBorder} shadow-sm tactile-press ${isDark ? 'text-slate-300' : 'text-slate-600'}`}>
           <ChevronLeft size={32} />
         </button>
         <div className="flex flex-col items-center">
            <h2 className={`font-headline text-3xl font-black ${isDark ? 'text-white' : 'text-secondary'} uppercase tracking-widest`}>Kamus Huruf</h2>
            <button 
              onClick={() => setIsSeruMode(true)}
              className="mt-2 bg-orange-400 text-white px-6 py-2 rounded-full border-b-4 border-orange-600 font-headline font-black text-[10px] uppercase tracking-widest shadow-sm tactile-press flex items-center gap-2"
            >
              <Trophy size={14} /> Mode Seru
            </button>
         </div>
         <button onClick={nextLetter} className={`p-4 ${currentTheme.widgetBg} rounded-2xl border-4 ${currentTheme.widgetBorder} shadow-sm tactile-press ${isDark ? 'text-slate-300' : 'text-slate-600'}`}>
           <ChevronRight size={32} />
         </button>
      </div>
      
      <div className="flex flex-col md:flex-row gap-8 w-full max-w-4xl items-center justify-center">
        <motion.div 
          key={currentData.letter}
          className={`${currentTheme.widgetBg} rounded-[2.5rem] border-4 ${currentTheme.widgetBorder} w-full max-w-[360px] aspect-square flex flex-col items-center justify-center relative shadow-md group`}
        >
          <div className="flex flex-row items-baseline gap-2">
            <span className={`font-headline font-black text-[150px] md:text-[180px] ${isDark ? 'text-orange-300' : 'text-primary'}`}>{currentData.letter}</span>
            <span className={`font-headline font-black text-[100px] md:text-[120px] ${isDark ? 'text-white/20' : 'text-primary-fixed'}`}>{currentData.letter.toLowerCase()}</span>
          </div>
        </motion.div>

        <motion.div 
          initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }}
          className={`${currentTheme.widgetBg} rounded-[2.5rem] border-4 ${currentTheme.widgetBorder} w-full max-w-[360px] aspect-square flex flex-col items-center justify-center relative shadow-md group overflow-hidden`}
        >
          <button onClick={randomizeObject} className={`absolute top-4 right-4 w-12 h-12 ${isDark ? 'bg-orange-500' : 'bg-amber-400'} rounded-full border-b-[4px] border-black/20 flex items-center justify-center tactile-press text-white z-20`}>
            <Shuffle size={20} />
          </button>

          <AnimatePresence mode="wait">
            <motion.div key={currentObject.name} className="flex flex-col items-center justify-center z-10 p-6">
              <motion.img animate={{ y: [0, -10, 0] }} transition={{ duration: 3, repeat: Infinity }} src={currentObject.img} className="w-48 h-48 md:w-56 md:h-56 object-contain drop-shadow-2xl mb-4" />
              <div className={`${isDark ? 'bg-slate-700' : 'bg-amber-100'} px-8 py-3 rounded-2xl border-4 ${isDark ? 'border-slate-600' : 'border-amber-300'} shadow-lg`}>
                <span className={`font-headline text-3xl font-black ${isDark ? 'text-white' : 'text-amber-800'} uppercase tracking-widest`}>{currentObject.name}</span>
              </div>
            </motion.div>
          </AnimatePresence>
        </motion.div>
      </div>

      <div className="mt-12">
         <button onClick={onBack} className={`${isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-secondary border-black/20 text-white'} px-16 py-5 rounded-2xl border-b-[8px] tactile-press font-headline font-black uppercase tracking-widest text-lg shadow-xl`}>SELESAI BELAJAR</button>
      </div>
    </div>
  );
}

function AngkaScreen({ onBack, currentTheme, onProgressUpdate }: { onBack: () => void, currentTheme: any, onProgressUpdate?: (p: number) => void }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [isSeruMode, setIsSeruMode] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  const [feedback, setFeedback] = useState<'success' | 'fail' | null>(null);
  const [completedIndices, setCompletedIndices] = useState<Set<number>>(new Set());

  const current = NUMBERS_DATA[currentIdx] || NUMBERS_DATA[0];
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  const nextChallenge = () => {
    setFeedback(null);
    setCurrentIdx(Math.floor(Math.random() * NUMBERS_DATA.length));
  };

  const toggleRecording = () => {
    if (isRecording) {
      setIsRecording(false);
      const isCorrect = Math.random() > 0.3;
      if (isCorrect) {
        setFeedback('success');
        const nextSet = new Set(completedIndices);
        nextSet.add(currentIdx);
        setCompletedIndices(nextSet);
        if (onProgressUpdate) onProgressUpdate(Math.round((nextSet.size / NUMBERS_DATA.length) * 100));
      } else {
        setFeedback('fail');
      }
    } else {
      setFeedback(null);
      setIsRecording(true);
    }
  };

  if (isSeruMode) {
    return (
      <div className="flex flex-col items-center gap-8">
        <div className="w-full flex justify-between items-center">
           <button onClick={() => setIsSeruMode(false)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl shadow-sm border-b-4 ${currentTheme.widgetBorder} ${isDark ? 'text-slate-300' : 'text-slate-500'} flex items-center gap-2 font-headline font-black uppercase text-xs`}>
             <ChevronLeft size={20} /> Kembali
           </button>
           <h2 className={`font-headline text-2xl font-black ${isDark ? 'text-blue-300' : 'text-blue-600'} uppercase tracking-widest`}>Kuis Seru</h2>
           <div className={`px-4 py-2 rounded-full ${isDark ? 'bg-blue-900/40 text-blue-200' : 'bg-blue-100 text-blue-700'} font-headline font-black text-sm`}>
             {completedIndices.size} / {NUMBERS_DATA.length}
           </div>
        </div>

        <motion.div 
          key={currentIdx}
          className={`${currentTheme.widgetBg} w-full max-w-sm aspect-square rounded-[3rem] border-b-[12px] ${currentTheme.widgetBorder} shadow-xl flex flex-col items-center justify-center relative overflow-hidden`}
        >
          <img src={NUMBERS_DATA[currentIdx].img} className="w-64 h-64 object-contain z-10 drop-shadow-2xl" />
          <AnimatePresence>
            {feedback && (
              <motion.div 
                initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }}
                className={`absolute bottom-12 px-6 py-3 rounded-2xl border-4 font-headline font-black uppercase tracking-widest shadow-lg ${feedback === 'success' ? 'bg-green-500 border-green-300 text-white' : 'bg-red-500 border-red-300 text-white'}`}
              >
                {feedback === 'success' ? 'Hebat!' : 'Coba lagi yuk!'}
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>

        <div className="flex flex-col items-center gap-6">
           {feedback === 'success' ? (
             <button onClick={nextChallenge} className="bg-blue-500 text-white px-12 py-5 rounded-full border-b-8 border-blue-700 font-headline font-black text-xl shadow-tactile-blue uppercase">Selanjutnya</button>
           ) : (
             <button onClick={toggleRecording} className={`w-24 h-24 rounded-full flex items-center justify-center border-b-8 shadow-2xl transition-all ${isRecording ? 'bg-red-500 border-red-700 text-white scale-110' : 'bg-white border-slate-200 text-slate-400'}`}>
                {isRecording ? <Mic size={40} className="animate-pulse" /> : <MicOff size={40} />}
             </button>
           )}
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center max-w-5xl mx-auto">
      <div className="w-full flex items-center justify-between mb-8">
         <button onClick={() => setCurrentIdx(p => (p - 1 + NUMBERS_DATA.length) % NUMBERS_DATA.length)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl border-4 ${currentTheme.widgetBorder} shadow-sm tactile-press ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>
           <ChevronLeft size={32} />
         </button>
         <div className="text-center">
            <h2 className={`font-headline text-3xl md:text-4xl ${isDark ? 'text-blue-300' : 'text-blue-600'} font-black`}>Angka {current.number}</h2>
            <button 
              onClick={() => setIsSeruMode(true)}
              className="mt-2 bg-blue-400 text-white px-6 py-1.5 rounded-full border-b-4 border-blue-600 font-headline font-black text-[10px] uppercase tracking-widest shadow-sm tactile-press flex items-center gap-2 mx-auto"
            >
              <Trophy size={14} /> Mode Seru
            </button>
         </div>
         <button onClick={() => setCurrentIdx(p => (p + 1) % NUMBERS_DATA.length)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl border-4 ${currentTheme.widgetBorder} shadow-sm tactile-press ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>
           <ChevronRight size={32} />
         </button>
      </div>
      
      <div className="flex flex-col md:flex-row items-center justify-center gap-8 w-full">
        <motion.div 
          key={current.number}
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className={`${currentTheme.widgetBg} rounded-[2.5rem] border-4 ${currentTheme.widgetBorder} w-full max-w-[400px] aspect-square flex flex-col items-center justify-center relative shadow-md overflow-hidden`}
        >
          <div className={`font-headline font-black text-[220px] md:text-[280px] ${isDark ? 'text-blue-500/5' : 'text-blue-500/10'} absolute inset-0 flex items-center justify-center select-none`}>
            {current.number}
          </div>
          <img src={current.img} alt={current.name} className="w-64 h-64 md:w-72 md:h-72 object-contain z-10 mb-4 drop-shadow-2xl" />
          <div className={`${isDark ? 'bg-blue-900/60 border-blue-700' : 'bg-blue-100 border-blue-300'} px-10 py-4 rounded-2xl border-4 z-10 shadow-lg`}>
            <span className={`font-headline text-4xl font-black ${isDark ? 'text-white' : 'text-blue-700'} uppercase tracking-widest`}>{current.name}</span>
          </div>
        </motion.div>

        <div className="flex flex-col gap-4 w-full max-w-[200px]">
           <button onClick={() => setCurrentIdx(p => (p + 1) % NUMBERS_DATA.length)} className={`${currentTheme.primary} w-full rounded-2xl border-b-[8px] ${isDark ? 'border-indigo-900' : 'border-primary'} py-6 tactile-press font-headline font-black text-white uppercase text-lg shadow-tactile-blue`}>Lanjut</button>
           <button onClick={onBack} className={`${isDark ? 'bg-slate-800 border-slate-700 text-slate-300' : 'bg-white border-slate-200 text-slate-400'} w-full rounded-2xl border-b-[6px] py-4 tactile-press font-headline font-black uppercase text-sm`}>Selesai</button>
        </div>
      </div>
    </div>
  );
}

function BendaScreen({ onBack, currentTheme, onProgressUpdate }: { onBack: () => void, currentTheme: any, onProgressUpdate?: (p: number) => void }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [isSeruMode, setIsSeruMode] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  const [feedback, setFeedback] = useState<'success' | 'fail' | null>(null);
  const [completedIndices, setCompletedIndices] = useState<Set<number>>(new Set());

  const current = OBJECTS_DATA[currentIdx] || OBJECTS_DATA[0];
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  const nextChallenge = () => {
    setFeedback(null);
    setCurrentIdx(Math.floor(Math.random() * OBJECTS_DATA.length));
  };

  const toggleRecording = () => {
    if (isRecording) {
      setIsRecording(false);
      const isCorrect = Math.random() > 0.3;
      if (isCorrect) {
        setFeedback('success');
        const nextSet = new Set(completedIndices);
        nextSet.add(currentIdx);
        setCompletedIndices(nextSet);
        if (onProgressUpdate) onProgressUpdate(Math.round((nextSet.size / OBJECTS_DATA.length) * 100));
      } else {
        setFeedback('fail');
      }
    } else {
      setFeedback(null);
      setIsRecording(true);
    }
  };

  if (isSeruMode) {
    return (
      <div className="flex flex-col items-center gap-8">
        <div className="w-full flex justify-between items-center">
           <button onClick={() => setIsSeruMode(false)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl shadow-sm border-b-4 ${currentTheme.widgetBorder} ${isDark ? 'text-slate-300' : 'text-slate-500'} flex items-center gap-2 font-headline font-black uppercase text-xs`}>
             <ChevronLeft size={20} /> Kembali
           </button>
           <h2 className={`font-headline text-2xl font-black ${isDark ? 'text-green-300' : 'text-green-600'} uppercase tracking-widest`}>Petualangan Seru</h2>
           <div className={`px-4 py-2 rounded-full ${isDark ? 'bg-green-900/40 text-green-200' : 'bg-green-100 text-green-700'} font-headline font-black text-sm`}>
             {completedIndices.size} / {OBJECTS_DATA.length}
           </div>
        </div>

        <motion.div 
          key={currentIdx}
          className={`${currentTheme.widgetBg} w-full max-w-sm aspect-square rounded-[3rem] border-b-[12px] ${currentTheme.widgetBorder} shadow-xl flex flex-col items-center justify-center relative overflow-hidden`}
        >
          <img src={OBJECTS_DATA[currentIdx].img} className="w-64 h-64 object-contain z-10 drop-shadow-2xl" />
          <AnimatePresence>
            {feedback && (
              <motion.div 
                initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }}
                className={`absolute bottom-12 px-6 py-3 rounded-2xl border-4 font-headline font-black uppercase tracking-widest shadow-lg ${feedback === 'success' ? 'bg-green-500 border-green-300 text-white' : 'bg-red-500 border-red-300 text-white'}`}
              >
                {feedback === 'success' ? 'Pintar!' : 'Hampir benar!'}
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>

        <div className="flex flex-col items-center gap-6">
           {feedback === 'success' ? (
             <button onClick={nextChallenge} className="bg-green-500 text-white px-12 py-5 rounded-full border-b-8 border-green-700 font-headline font-black text-xl shadow-tactile-green uppercase">Selanjutnya</button>
           ) : (
             <button onClick={toggleRecording} className={`w-24 h-24 rounded-full flex items-center justify-center border-b-8 shadow-2xl transition-all ${isRecording ? 'bg-red-500 border-red-700 text-white scale-110' : 'bg-white border-slate-200 text-slate-400'}`}>
                {isRecording ? <Mic size={40} className="animate-pulse" /> : <MicOff size={40} />}
             </button>
           )}
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center max-w-5xl mx-auto">
      <div className="w-full flex items-center justify-between mb-8">
         <button onClick={() => setCurrentIdx(p => (p - 1 + OBJECTS_DATA.length) % OBJECTS_DATA.length)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl border-4 ${currentTheme.widgetBorder} shadow-sm tactile-press ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>
           <ChevronLeft size={32} />
         </button>
         <div className="text-center">
            <h2 className={`font-headline text-3xl md:text-4xl ${isDark ? 'text-green-300' : 'text-green-600'} font-black uppercase tracking-widest`}>{current.name}</h2>
            <button 
              onClick={() => setIsSeruMode(true)}
              className="mt-2 bg-green-400 text-white px-6 py-1.5 rounded-full border-b-4 border-green-600 font-headline font-black text-[10px] uppercase tracking-widest shadow-sm tactile-press flex items-center gap-2 mx-auto"
            >
              <Trophy size={14} /> Mode Seru
            </button>
         </div>
         <button onClick={() => setCurrentIdx(p => (p + 1) % OBJECTS_DATA.length)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl border-4 ${currentTheme.widgetBorder} shadow-sm tactile-press ${isDark ? 'text-slate-200' : 'text-slate-600'}`}>
           <ChevronRight size={32} />
         </button>
      </div>
      
      <div className="flex flex-col md:flex-row items-center justify-center gap-8 w-full">
        <motion.div 
          key={current.name}
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          className={`${currentTheme.widgetBg} rounded-[2.5rem] border-4 ${currentTheme.widgetBorder} w-full max-w-[400px] aspect-square flex flex-col items-center justify-center relative shadow-md`}
        >
          <img src={current.img} alt={current.name} className="w-64 h-64 md:w-72 md:h-72 object-contain mb-8 drop-shadow-2xl" />
          <div className={`${isDark ? 'bg-green-900/60 border-green-700' : 'bg-green-100 border-green-300'} px-10 py-4 rounded-2xl border-4 shadow-lg`}>
            <span className={`font-headline text-4xl font-black ${isDark ? 'text-white' : 'text-green-700'} uppercase tracking-widest`}>{current.name}</span>
          </div>
        </motion.div>

        <div className="flex flex-col gap-4 w-full max-w-[200px]">
           <button onClick={() => setCurrentIdx(p => (p + 1) % OBJECTS_DATA.length)} className={`${currentTheme.primary} w-full rounded-2xl border-b-[8px] ${isDark ? 'border-indigo-900 text-white' : 'border-primary text-white'} py-6 tactile-press font-headline font-black uppercase text-lg shadow-tactile-green`}>Lanjut</button>
           <button onClick={onBack} className={`${isDark ? 'bg-slate-800 border-slate-700 text-slate-300' : 'bg-white border-slate-200 text-slate-400'} w-full rounded-2xl border-b-[6px] py-4 tactile-press font-headline font-black uppercase text-sm`}>Selesai</button>
        </div>
      </div>
    </div>
  );
}



function ThemeDecorations({ activeThemeId }: { activeThemeId: ThemeType }) {
  const isDark = activeThemeId === 'angkasa' || activeThemeId === 'malam';

  const renderDecorations = () => {
    switch (activeThemeId) {
      case 'angkasa':
        return (
          <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
            {[...Array(40)].map((_, i) => (
              <motion.div
                key={`star-${i}`}
                initial={{ opacity: 0.2, scale: 0.5 }}
                animate={{ 
                  opacity: [0.2, 0.8, 0.2],
                  scale: [0.5, 1, 0.5],
                }}
                transition={{ 
                  duration: 2 + Math.random() * 3, 
                  repeat: Infinity,
                  delay: Math.random() * 5 
                }}
                className="absolute bg-white rounded-full shadow-[0_0_8px_rgba(255,255,255,0.8)]"
                style={{
                  width: Math.random() * 3 + 1 + 'px',
                  height: Math.random() * 3 + 1 + 'px',
                  top: Math.random() * 100 + '%',
                  left: Math.random() * 100 + '%',
                }}
              />
            ))}
            <motion.div 
              animate={{ x: ['110vw', '-10vw'], y: [100, 300, 100], rotate: [-45, -45] }}
              transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
              className="absolute top-0 text-white/10"
            >
              <Rocket size={100} />
            </motion.div>
            <motion.div 
              animate={{ 
                y: [0, -30, 0], 
                rotate: [0, 10, 0]
              }}
              transition={{ duration: 15, repeat: Infinity, ease: "easeInOut" }}
              className="absolute top-[15%] right-[10%] w-32 h-32 opacity-20"
            >
              <div className="relative w-full h-full">
                <div className="absolute inset-0 bg-gradient-to-br from-orange-400 to-red-600 rounded-full shadow-[0_0_40px_rgba(251,146,60,0.5)]" />
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[140%] h-4 border-2 border-white/20 rounded-[100%] rotate-12" />
              </div>
            </motion.div>
            <motion.div 
              animate={{ 
                x: [0, 30, 0],
                y: [0, 40, 0],
              }}
              transition={{ duration: 25, repeat: Infinity, ease: "easeInOut" }}
              className="absolute bottom-[20%] left-[8%] w-56 h-56 opacity-10 bg-indigo-600 blur-[80px] rounded-full"
            />
          </div>
        );
      case 'alam':
        return (
          <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
            <motion.div 
              animate={{ scale: [1, 1.1, 1], opacity: [0.3, 0.5, 0.3] }}
              transition={{ duration: 10, repeat: Infinity }}
              className="absolute -top-10 -left-10 text-yellow-400/20"
            >
              <Sun size={300} />
            </motion.div>
            {[...Array(6)].map((_, i) => (
              <motion.div
                key={`cloud-${i}`}
                animate={{ x: ['-20vw', '120vw'] }}
                transition={{ 
                  duration: 40 + Math.random() * 40, 
                  repeat: Infinity,
                  ease: "linear",
                  delay: i * -15
                }}
                className="absolute text-blue-100/40"
                style={{ top: (10 + i * 15) + '%' }}
              >
                <Cloud size={100 + Math.random() * 50} />
              </motion.div>
            ))}
            {[...Array(15)].map((_, i) => (
              <motion.div
                key={`nature-decor-${i}`}
                animate={{ 
                  rotate: [0, 15, -15, 0],
                  y: [0, 10, 0]
                }}
                transition={{ 
                  duration: 5 + Math.random() * 5, 
                  repeat: Infinity,
                  ease: "easeInOut",
                  delay: Math.random() * 5
                }}
                className="absolute text-green-300/20"
                style={{
                  bottom: -20 + Math.random() * 40 + '%',
                  left: Math.random() * 100 + '%',
                }}
              >
                 <div className="w-16 h-24 bg-current rounded-t-full rounded-b-lg" />
              </motion.div>
            ))}
          </div>
        );
      case 'hewan':
        return (
          <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
             {[...Array(8)].map((_, i) => (
              <motion.div
                key={`hewan-decor-${i}`}
                initial={{ opacity: 0 }}
                animate={{ 
                  opacity: [0, 0.15, 0],
                  scale: [0.9, 1.1, 0.9]
                }}
                transition={{ 
                  duration: 6, 
                  repeat: Infinity,
                  delay: i * 1.5
                }}
                className="absolute text-orange-400/20"
                style={{
                  top: Math.random() * 100 + '%',
                  left: Math.random() * 100 + '%',
                }}
              >
                <div className="w-12 h-12 bg-current rounded-full" />
              </motion.div>
            ))}
            <motion.div
              animate={{ 
                x: ['-20vw', '120vw'],
                y: [0, -40, 40, 0],
                rotate: [0, 5, -5, 0]
              }}
              transition={{ duration: 30, repeat: Infinity, ease: "linear" }}
              className="absolute bottom-[20%] text-primary/10"
            >
              <Rabbit size={180} />
            </motion.div>
            <motion.div
              animate={{ 
                x: ['120vw', '-20vw'],
                y: [200, 150, 200]
              }}
              transition={{ duration: 45, repeat: Infinity, ease: "linear" }}
              className="absolute top-[30%] text-pink-400/10"
            >
              <Star size={120} />
            </motion.div>
          </div>
        );
      case 'malam':
        return (
          <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
            <motion.div 
               animate={{ y: [-10, 10, -10] }}
               transition={{ duration: 8, repeat: Infinity }}
               className="absolute top-[10%] right-[10%] text-yellow-100/20"
            >
              <Moon size={150} fill="currentColor" />
            </motion.div>
            {[...Array(50)].map((_, i) => (
              <motion.div
                key={`malam-star-refined-${i}`}
                animate={{ 
                  opacity: [0.1, 0.5, 0.1],
                  scale: [1, 1.2, 1]
                }}
                transition={{ 
                  duration: 2 + Math.random() * 4, 
                  repeat: Infinity,
                  delay: Math.random() * 5
                }}
                className="absolute bg-yellow-100/30 rounded-full"
                style={{
                  width: '2px',
                  height: '2px',
                  top: Math.random() * 100 + '%',
                  left: Math.random() * 100 + '%',
                }}
              />
            ))}
          </div>
        );
      case 'lautan':
        return (
          <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
            {[...Array(25)].map((_, i) => (
              <motion.div
                key={`bubble-${i}`}
                initial={{ y: '110vh', x: Math.random() * 100 + 'vw', opacity: 0.1, scale: 0.5 + Math.random() }}
                animate={{ 
                  y: '-10vh',
                  opacity: [0.1, 0.4, 0.1],
                  x: (Math.random() * 100) + (Math.sin(i) * 5) + 'vw'
                }}
                transition={{ 
                  duration: 10 + Math.random() * 15, 
                  repeat: Infinity,
                  ease: "linear",
                  delay: Math.random() * 10
                }}
                className="absolute border-2 border-blue-300/30 rounded-full bg-blue-100/10"
                style={{
                  width: 10 + Math.random() * 20 + 'px',
                  height: 10 + Math.random() * 20 + 'px',
                }}
              />
            ))}
            {[...Array(5)].map((_, i) => (
              <motion.div
                key={`fish-${i}`}
                animate={{ 
                  x: i % 2 === 0 ? ['-10vw', '110vw'] : ['110vw', '-10vw'],
                  y: [Math.random() * 100 + '%', Math.random() * 100 + '%'],
                  scaleX: i % 2 === 0 ? 1 : -1
                }}
                transition={{ 
                  duration: 20 + Math.random() * 20, 
                  repeat: Infinity,
                  ease: "linear",
                  delay: i * 5
                }}
                className="absolute text-blue-400/20"
              >
                <Fish size={40 + Math.random() * 40} />
              </motion.div>
            ))}
            <motion.div 
               animate={{ 
                 rotate: [-5, 5, -5],
                 y: [0, 5, 0]
               }}
               transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}
               className="absolute bottom-[10%] left-[5%] text-blue-800/10"
            >
              <Anchor size={120} />
            </motion.div>
          </div>
        );
      default:
        return null;
    }
  };

  return renderDecorations();
}

function ProgressCard({ title, percent, status, color, borderColor, textColor, icon, accentColor, theme }: any) {
  const isDark = theme?.id === 'angkasa' || theme?.id === 'malam';
  const customBg = theme ? theme.widgetBg : color;
  const customBorder = theme ? theme.widgetBorder : borderColor;
  const titleColor = isDark ? 'text-white' : textColor;

  return (
    <div className={`${customBg} ${customBorder} rounded-3xl border-4 p-6 shadow-sm`}>
      <div className="flex items-center gap-4 mb-4">
        <div className={`p-3 rounded-2xl ${accentColor} bg-opacity-20`}>{icon}</div>
        <div className="flex-1">
          <h4 className={`font-headline font-black text-xl ${titleColor}`}>{title}</h4>
          <p className={`font-headline font-bold text-sm ${titleColor} opacity-80 uppercase tracking-wider`}>{status}</p>
        </div>
      </div>
      <div className="w-full h-4 bg-black/10 rounded-full ring-2 ring-black/5">
        <motion.div 
          initial={{ width: 0 }}
          animate={{ width: `${percent}%` }}
          className={`h-full ${accentColor} rounded-full`}
        />
      </div>
      <div className={`mt-2 font-headline font-black text-right ${titleColor}`}>{percent}%</div>
    </div>
  );
}

function ScoreItem({ title, date, score, icon, iconBg, scoreColor, theme }: any) {
  const isDark = theme?.id === 'angkasa' || theme?.id === 'malam';
  return (
    <div className={`flex items-center gap-4 ${isDark ? 'bg-slate-800 border-slate-700' : 'bg-white border-slate-100'} p-4 rounded-[1.5rem] border-2 shadow-sm`}>
      <div className={`${iconBg} p-3 rounded-2xl`}>{icon}</div>
      <div className="flex-1">
        <h4 className={`font-headline font-black text-lg ${isDark ? 'text-white' : 'text-on-surface'}`}>{title}</h4>
        <p className={`font-headline text-xs ${isDark ? 'text-slate-300' : 'text-slate-400'} font-bold uppercase tracking-wider`}>{date}</p>
      </div>
      <div className={`${scoreColor} font-headline font-black text-2xl`}>{score}</div>
    </div>
  );
}

function AkunScreen({ progression, onNavigateToAdmin, activeTheme, onThemeChange, currentTheme }: { 
  progression: any, 
  onNavigateToAdmin: () => void,
  activeTheme: ThemeType,
  onThemeChange: (theme: ThemeType) => void,
  currentTheme: any
}) {
  const childName = auth.currentUser?.displayName || 'Teman';
  const email = auth.currentUser?.email || '';
  const isAdmin = email === ADMIN_EMAIL;
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  return (
    <div className="flex flex-col gap-8">
      {/* Profile Header */}
      <div className={`${currentTheme.widgetBg} rounded-[2.5rem] border-b-[8px] ${currentTheme.widgetBorder} p-8 flex flex-col items-center shadow-sm relative overflow-hidden`}>
        <div className={`w-24 h-24 rounded-full ${isDark ? 'bg-slate-700' : 'bg-slate-50'} p-2 border-4 ${currentTheme.widgetBorder} mb-4 z-10 overflow-hidden shadow-inner`}>
          <img 
            src="https://img.freepik.com/free-vector/cheerful-rabbit-cartoon-character_1308-164745.jpg" 
            alt="Avatar" 
            className="w-full h-full object-cover rounded-full"
          />
        </div>
        <h2 className={`font-headline text-3xl font-black ${isDark ? 'text-white' : 'text-on-surface'} mb-1 z-10`}>Halo, {childName}!</h2>
        <p className={`font-headline font-bold ${isDark ? 'text-slate-300' : 'text-slate-400'} text-sm z-10 tracking-widest uppercase`}>{email}</p>
        
        <div className="absolute -left-4 -bottom-4 opacity-5 pointer-events-none">
          <Rabbit size={180} className={isDark ? 'text-white' : 'text-slate-900'} />
        </div>
      </div>

      {/* Statistik Belajar */}
      <div className="flex flex-col gap-4">
        <h3 className={`font-headline text-2xl font-black px-4 ${isDark ? 'text-purple-300' : 'text-on-surface'}`}>Statistik Belajar</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <ScoreItem 
            theme={currentTheme}
            title="Kuis Membaca" 
            date="Progress Terakhir" 
            score={progression.membaca + "%"} 
            icon={<ALargeSmall size={24} />} 
            iconBg="bg-red-100 text-red-500" 
            scoreColor={progression.membaca > 70 ? "text-green-400" : "text-orange-400"} 
          />
          <ScoreItem 
            theme={currentTheme}
            title="Kuis Iqra" 
            date="Progress Terakhir" 
            score={progression.iqra + "%"} 
            icon={<BookOpen size={24} />} 
            iconBg="bg-purple-100 text-purple-500" 
            scoreColor={progression.iqra > 70 ? "text-green-400" : "text-orange-400"} 
          />
        </div>
      </div>

      {/* Theme Switcher */}
      <div className={`${currentTheme.widgetBg} rounded-[2.5rem] border-b-[8px] ${currentTheme.widgetBorder} p-8 shadow-sm`}>
        <div className="flex items-center gap-3 mb-6">
          <div className={`${isDark ? 'bg-purple-900' : 'bg-purple-100'} p-3 rounded-2xl text-purple-600`}>
            <Palette size={28} />
          </div>
          <h3 className={`font-headline text-2xl font-black ${isDark ? 'text-white' : 'text-on-surface'}`}>Ganti Tema</h3>
        </div>
        
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {THEMES.map((theme) => (
            <motion.button
              key={theme.id}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => onThemeChange(theme.id)}
              className={`
                relative p-4 rounded-3xl border-4 transition-all flex flex-col items-center gap-2
                ${activeTheme === theme.id ? 'border-purple-500 bg-purple-50 shadow-md' : (isDark ? 'border-slate-700 bg-slate-800' : 'border-slate-100 bg-white') + ' hover:border-purple-200'}
              `}
            >
              <div className={`w-14 h-14 rounded-2xl ${theme.primary} flex items-center justify-center overflow-hidden border-2 border-white/50 shadow-sm`}>
                 <img src={theme.icon} alt={theme.name} className="w-full h-full object-cover" />
              </div>
              <span className={`font-headline font-black text-xs uppercase tracking-widest ${activeTheme === theme.id ? 'text-purple-700' : (isDark ? 'text-slate-400' : 'text-slate-500')}`}>
                {theme.name}
              </span>
              {activeTheme === theme.id && (
                <div className="absolute -top-2 -right-2 bg-purple-500 text-white rounded-full p-1 shadow-md">
                   <CheckCircle2 size={16} />
                </div>
              )}
            </motion.button>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <ProgressCard 
          theme={currentTheme}
          title="Membaca" 
          percent={progression.membaca} 
          status={progression.membaca >= 80 ? "Sangat Baik!" : progression.membaca >= 40 ? "Bagus!" : "Terus Berlatih!"} 
          color="bg-white" 
          borderColor="border-red-100" 
          textColor={isDark ? "text-red-200" : "text-red-900"} 
          icon={<ALargeSmall size={32} />} 
          accentColor="bg-red-500"
        />
        <ProgressCard 
          theme={currentTheme}
          title="Angka" 
          percent={progression.angka} 
          status={progression.angka >= 80 ? "Hebat!" : progression.angka >= 40 ? "Pintar!" : "Ayo Belajar!"} 
          color="bg-white" 
          borderColor="border-blue-100" 
          textColor={isDark ? "text-blue-200" : "text-blue-900"} 
          icon={<Hash size={32} />} 
          accentColor="bg-blue-500"
        />
        <ProgressCard 
          theme={currentTheme}
          title="Benda" 
          percent={progression.benda} 
          status={progression.benda >= 80 ? "Luar Biasa!" : progression.benda >= 40 ? "Keren!" : "Semangat!"} 
          color="bg-white" 
          borderColor="border-green-100" 
          textColor={isDark ? "text-green-200" : "text-green-900"} 
          icon={<Shapes size={32} />} 
          accentColor="bg-green-500"
        />
        <ProgressCard 
          theme={currentTheme}
          title="Iqra" 
          percent={progression.iqra} 
          status={progression.iqra >= 80 ? "MasyaAllah!" : (progression.iqra >= 40 ? "Alhamdulillah!" : "Semangat!")} 
          color="bg-white" 
          borderColor="border-purple-100" 
          textColor={isDark ? "text-purple-200" : "text-purple-900"} 
          icon={<BookOpen size={32} />} 
          accentColor="bg-purple-500"
        />
      </div>

      <div className="flex flex-col gap-4">
        {isAdmin && (
          <button 
            onClick={onNavigateToAdmin}
            className="w-full bg-purple-600 py-6 rounded-3xl border-b-[8px] border-purple-800 flex items-center justify-center gap-3 font-headline font-black text-white uppercase tracking-widest tactile-press shadow-md"
          >
            <LayoutGrid size={28} />
            <span>Dashboard Admin</span>
          </button>
        )}

        <button 
          onClick={() => signOut(auth)}
          className={`w-full ${currentTheme.widgetBg} py-6 rounded-3xl border-b-[8px] border-red-100 flex items-center justify-center gap-3 font-headline font-black text-red-500 uppercase tracking-widest tactile-press shadow-sm`}
        >
          <LogOut size={28} />
          <span>Keluar Aplikasi</span>
        </button>
      </div>

      <div className="mt-4 text-center">
        <p className={`font-headline ${isDark ? 'text-slate-400' : 'text-slate-300'} font-bold text-xs tracking-[0.2em] uppercase`}>Belajar PAUD • Versi 1.1.0</p>
      </div>
    </div>
  );
}

function LaguScreen({ onBack, currentTheme }: { onBack: () => void, currentTheme: any }) {
  const [selectedSongId, setSelectedSongId] = useState<string | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [allSongs, setAllSongs] = useState(SONGS_DATA);
  const iframeRef = React.useRef<HTMLIFrameElement>(null);
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  useEffect(() => {
    // Sync with Firestore
    const unsubscribe = onSnapshot(collection(db, 'songs'), (snapshot) => {
      const firestoreSongs = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as any));
      // Merge with static data, prioritizing firestore IDs
      const merged = [...firestoreSongs];
      SONGS_DATA.forEach(staticSong => {
        if (!merged.find(s => s.id === staticSong.id)) {
          merged.push(staticSong);
        }
      });
      setAllSongs(merged);
    });
    return () => unsubscribe();
  }, []);

  const selectedSong = allSongs.find(s => s.id === selectedSongId);

  useEffect(() => {
    if (isPlaying) {
      // Attempt to trigger play via postMessage
      try {
        iframeRef.current?.contentWindow?.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
      } catch (e) {
        console.error("Video control failed", e);
      }
    } else {
      try {
        iframeRef.current?.contentWindow?.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
      } catch (e) {
        // ignore
      }
    }
  }, [isPlaying, selectedSongId]);

  if (selectedSongId && selectedSong) {
    return (
      <div className="flex flex-col items-center">
        <button 
          onClick={() => { setSelectedSongId(null); setIsPlaying(false); }}
          className={`self-start mb-6 flex items-center gap-2 ${isDark ? 'text-slate-300' : 'text-secondary'} font-headline font-bold`}
        >
          <ChevronLeft size={24} /> Kembali ke List
        </button>

        <div className="w-full aspect-video rounded-3xl border-8 border-slate-900 bg-black overflow-hidden shadow-2xl relative mb-8">
           <iframe
             ref={iframeRef}
             width="100%"
             height="100%"
             src={`${selectedSong.videoUrl}?enablejsapi=1&rel=0`}
             title={selectedSong.title}
             frameBorder="0"
             allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
             allowFullScreen
           ></iframe>
           {!isPlaying && (
             <div className="absolute inset-0 bg-black/60 flex items-center justify-center">
               <button 
                onClick={() => setIsPlaying(true)}
                className="w-24 h-24 bg-primary-container rounded-full flex items-center justify-center border-b-[8px] border-primary tactile-press"
               >
                 <Play size={48} className="text-on-primary-container ml-2" fill="currentColor" />
               </button>
             </div>
           )}
        </div>

        <div className="flex gap-4 mt-4">
          <button 
             onClick={() => setIsPlaying(!isPlaying)}
             className={`${isPlaying ? 'bg-orange-500 border-orange-700' : 'bg-pink-400 border-pink-700'} px-12 py-5 rounded-full border-b-[8px] font-headline font-black text-white uppercase tracking-widest tactile-press text-2xl flex items-center gap-3`}
          >
             {isPlaying ? <><Pause size={32} /> PAUSE</> : <><Play size={32} /> MULAI</>}
          </button>
          <button 
              onClick={() => {
                setIsPlaying(false);
                if (iframeRef.current) {
                  const src = iframeRef.current.src;
                  iframeRef.current.src = '';
                  iframeRef.current.src = src;
                }
              }}
              className={`p-5 ${isDark ? 'bg-slate-700 border-slate-600 text-slate-200' : 'bg-slate-200 border-slate-400 text-slate-600'} rounded-full border-b-8 tactile-press`}
          >
              <RotateCcw size={32} />
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <h2 className={`font-headline text-3xl font-black ${isDark ? 'text-[#FAB1A0]' : 'text-pink-600'} text-center mb-4`}>Pilih Lagu Kesukaanmu!</h2>
      <div className="grid grid-cols-1 gap-6">
        {allSongs.map((song) => (
          <button 
            key={song.id}
            onClick={() => setSelectedSongId(song.id)}
            className={`${currentTheme.widgetBg} rounded-3xl border-4 ${currentTheme.widgetBorder} p-6 flex items-center gap-6 shadow-sm tactile-press hover:bg-opacity-80 transition-colors`}
          >
            <div className={`w-20 h-20 ${isDark ? 'bg-pink-900/30' : 'bg-pink-100'} rounded-2xl flex items-center justify-center text-pink-500 flex-shrink-0`}>
               <Video size={40} />
            </div>
              <div className="flex-1 text-left">
                <h3 className={`font-headline text-2xl font-black ${isDark ? 'text-white' : 'text-on-surface'} mb-1`}>{song.title}</h3>
                <p className={`${isDark ? 'text-slate-300' : 'text-secondary'} font-bold flex items-center gap-1`}><Music size={16} /> Ayo Nyanyi Bersama!</p>
              </div>
            <ArrowRight size={32} className="text-pink-300" />
          </button>
        ))}
      </div>
    </div>
  );
}

function IqraScreen({ onBack, currentTheme, onProgressUpdate }: { onBack: () => void, currentTheme: any, onProgressUpdate?: (p: number) => void }) {
  const [isReadingMode, setIsReadingMode] = useState(false);
  const [isSeruMode, setIsSeruMode] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  
  const [challengeIdx, setChallengeIdx] = useState(0);
  const [feedback, setFeedback] = useState<'success' | 'fail' | null>(null);
  const [completedIndices, setCompletedIndices] = useState<Set<number>>(new Set());

  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';

  useEffect(() => {
    if (isSeruMode) {
      setChallengeIdx(Math.floor(Math.random() * IQRA_DATA.length));
    }
  }, [isSeruMode]);

  const toggleRecording = () => {
    if (isRecording) {
      setIsRecording(false);
      const isCorrect = Math.random() > 0.3;
      if (isCorrect) {
        setFeedback('success');
        const nextCompleted = new Set(completedIndices);
        nextCompleted.add(challengeIdx);
        setCompletedIndices(nextCompleted);
        
        const progressPercent = Math.round((nextCompleted.size / IQRA_DATA.length) * 100);
        if (onProgressUpdate) onProgressUpdate(progressPercent);
      } else {
        setFeedback('fail');
      }
    } else {
      setFeedback(null);
      setIsRecording(true);
    }
  };

  const nextChallenge = () => {
    setFeedback(null);
    let nextIdx = Math.floor(Math.random() * IQRA_DATA.length);
    while (nextIdx === challengeIdx) {
      nextIdx = Math.floor(Math.random() * IQRA_DATA.length);
    }
    setChallengeIdx(nextIdx);
  };

  if (isSeruMode) {
    const currentChallenge = IQRA_DATA[challengeIdx];
    return (
      <div className="flex flex-col items-center gap-8">
        <div className="w-full flex justify-between items-center">
           <button onClick={() => setIsSeruMode(false)} className={`p-4 ${currentTheme.widgetBg} rounded-2xl shadow-sm border-b-4 ${currentTheme.widgetBorder} ${isDark ? 'text-slate-300' : 'text-slate-500'} flex items-center gap-2 font-headline font-black uppercase text-xs`}>
             <ChevronLeft size={20} /> Berhenti
           </button>
           <h2 className={`font-headline text-2xl font-black ${isDark ? 'text-purple-300' : 'text-purple-600'} uppercase tracking-widest`}>Kuis Arab Seru</h2>
           <div className={`px-4 py-2 rounded-full ${isDark ? 'bg-purple-900/40 text-purple-200' : 'bg-purple-100 text-purple-700'} font-headline font-black text-sm`}>
             {completedIndices.size} / {IQRA_DATA.length}
           </div>
        </div>

        <motion.div 
          key={challengeIdx}
          className={`${currentTheme.widgetBg} w-full max-w-sm aspect-square rounded-[3rem] border-b-[12px] ${currentTheme.widgetBorder} shadow-xl flex flex-col items-center justify-center relative overflow-hidden`}
        >
          <div className={`font-arabic text-[120px] ${isDark ? 'text-white' : 'text-purple-950'} mb-4`}>
            {currentChallenge.char}
          </div>
          
          <AnimatePresence>
            {feedback && (
              <motion.div 
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                className={`absolute bottom-12 px-6 py-3 rounded-2xl border-4 font-headline font-black uppercase tracking-widest shadow-lg ${
                  feedback === 'success' ? 'bg-green-500 border-green-300 text-white' : 'bg-red-500 border-red-300 text-white'
                }`}
              >
                {feedback === 'success' ? 'Pintar sekali!' : 'Ayo coba lagi!'}
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>

        <div className="flex flex-col items-center gap-6 mt-4">
           {feedback === 'success' ? (
             <button onClick={nextChallenge} className="bg-purple-500 text-white px-12 py-5 rounded-full border-b-8 border-purple-700 font-headline font-black text-xl shadow-tactile-purple">SELANJUTNYA</button>
           ) : (
             <div className="flex flex-col items-center gap-4">
                <p className={`font-headline font-bold ${isDark ? 'text-slate-400' : 'text-slate-500'} uppercase tracking-[0.2em] text-sm`}>
                  {isRecording ? 'Mendengarkan...' : 'Pencet Mic & Sebutkan!'}
                </p>
                <button 
                  onClick={toggleRecording}
                  className={`w-28 h-28 rounded-full flex flex-col items-center justify-center border-b-8 shadow-2xl transition-all relative ${
                    isRecording ? 'bg-red-500 border-red-700 text-white scale-110' : 'bg-white border-slate-200 text-slate-400'
                  }`}
                >
                  {isRecording && <div className="absolute inset-0 bg-red-400 rounded-full animate-ping opacity-20" />}
                  {isRecording ? <Mic size={48} className="relative z-10" /> : <MicOff size={48} className="relative z-10" />}
                </button>
             </div>
           )}
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <div className="w-full flex justify-between items-center mb-2">
         <button onClick={onBack} className={`p-4 ${currentTheme.widgetBg} rounded-2xl shadow-sm border-2 ${currentTheme.widgetBorder} ${isDark ? 'text-slate-300' : 'text-slate-500'}`}>
           <ChevronLeft size={24} />
         </button>
         
         <div className="flex items-center gap-4">
           <button 
             onClick={() => setIsSeruMode(true)}
             className={`${currentTheme.id === 'malam' ? 'bg-purple-900 border-purple-700 text-purple-200' : 'bg-purple-500 border-purple-700 text-white'} px-6 py-3 rounded-2xl border-b-4 font-headline font-black uppercase text-xs tracking-widest tactile-press flex items-center gap-2`}
           >
             <Trophy size={18} />
             Mode Seru
           </button>


           <div className={`flex items-center gap-2 ${currentTheme.widgetBg} px-4 py-2 rounded-full border-2 ${currentTheme.widgetBorder} shadow-sm`}>
              <span className={`font-headline font-bold ${isDark ? 'text-purple-300' : 'text-purple-600'} text-xs`}>Bantuan</span>
              <button 
                onClick={() => setIsReadingMode(!isReadingMode)}
                className={`w-10 h-5 rounded-full relative transition-colors duration-200 ${isReadingMode ? 'bg-purple-500' : (isDark ? 'bg-slate-700' : 'bg-slate-300')}`}
              >
                <div className={`absolute top-0.5 w-4 h-4 bg-white rounded-full transition-all duration-200 ${isReadingMode ? 'left-5.5' : 'left-0.5'}`} />
              </button>
           </div>
         </div>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
        {IQRA_DATA.map((item, idx) => (
          <motion.div 
            key={idx}
            initial={{ opacity: 0, scale: 0.8, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            transition={{ delay: idx * 0.03 }}
            className={`
              ${currentTheme.widgetBg} rounded-3xl border-4 p-4 flex flex-col items-center justify-center relative shadow-sm min-h-[140px]
              ${isReadingMode ? 'border-purple-300' : currentTheme.widgetBorder}
            `}
          >
            <div className={`font-arabic ${isDark ? 'text-white' : 'text-purple-950'} mb-2 ${isReadingMode ? 'text-6xl mt-2' : 'text-5xl'}`}>
              {item.char}
            </div>
            {!isReadingMode && (
              <>
                <div className={`${isDark ? 'bg-slate-800' : 'bg-slate-50'} px-3 py-0.5 rounded-lg mb-2`}>
                  <span className={`font-headline font-bold ${isDark ? 'text-slate-300' : 'text-slate-500'} text-xs`}>{item.latin}</span>
                </div>
                <motion.button 
                  whileTap={{ scale: 1.2 }}
                  className="w-10 h-10 bg-purple-500 rounded-full flex items-center justify-center text-white tactile-press shadow-md"
                >
                  <Volume2 size={20} />
                </motion.button>
              </>
            )}
          </motion.div>
        ))}
      </div>
    </div>
  );
}

function TrendingUpIcon({ size, className }: { size: number, className?: string }) {
  return (
    <svg 
      width={size} 
      height={size} 
      viewBox="0 0 24 24" 
      fill="none" 
      stroke="currentColor" 
      strokeWidth="2" 
      strokeLinecap="round" 
      strokeLinejoin="round" 
      className={className}
    >
      <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
      <polyline points="17 6 23 6 23 12"></polyline>
    </svg>
  );
}

function AdminScreen({ onBack, currentTheme }: { onBack: () => void, currentTheme: any }) {
  const [activeSubTab, setActiveSubTab] = useState<'benda' | 'lagu' | 'users'>('benda');
  const isDark = currentTheme.id === 'angkasa' || currentTheme.id === 'malam';
  
  const [objects, setObjects] = useState(OBJECTS_DATA);
  const [songs, setSongs] = useState(SONGS_DATA);

  // Form states
  const [newSongTitle, setNewSongTitle] = useState('');
  const [newSongUrl, setNewSongUrl] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    const unsubscribe = onSnapshot(collection(db, 'songs'), (snapshot) => {
      const firestoreSongs = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as any));
      const merged = [...firestoreSongs];
      SONGS_DATA.forEach(staticSong => {
        if (!merged.find(s => s.id === staticSong.id)) {
          merged.push(staticSong);
        }
      });
      setSongs(merged);
    });
    return () => unsubscribe();
  }, []);

  const handleAddSong = async () => {
    if (!newSongTitle || !newSongUrl) return;
    setIsSubmitting(true);
    try {
      const songData = {
        title: newSongTitle,
        videoUrl: newSongUrl,
        lyrics: [] 
      };
      
      await addDoc(collection(db, 'songs'), songData);
      setNewSongTitle('');
      setNewSongUrl('');
    } catch (error) {
      handleFirestoreError(error, OperationType.CREATE, 'songs');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteSong = async (id: string) => {
    // Note: This only deletes from Firestore. Static songs in SONGS_DATA won't be deleted from the file.
    // In a real app, all songs would be in Firestore.
    alert("Penghapusan lagu dari Firestore berhasil (jika item berasal dari DB). Item statis tetap ada di kode.");
  };

  return (
    <div className="flex flex-col gap-6">
      <header className={`flex items-center justify-between ${currentTheme.widgetBg} p-4 rounded-[2rem] border-b-[6px] ${currentTheme.widgetBorder} shadow-sm`}>
        <button onClick={onBack} className={`p-3 rounded-xl ${isDark ? 'hover:bg-slate-700 text-slate-300' : 'hover:bg-slate-50 text-slate-500'}`}>
          <ChevronLeft size={24} />
        </button>
        <h2 className={`font-headline text-2xl font-black ${isDark ? 'text-white' : 'text-purple-700'} uppercase tracking-tighter`}>Admin Dashboard</h2>
        <div className={`w-10 h-10 ${isDark ? 'bg-purple-900' : 'bg-purple-100'} rounded-full flex items-center justify-center text-purple-600`}>
           <Users size={20} />
        </div>
      </header>

      <div className={`flex ${currentTheme.widgetBg} p-2 rounded-[2rem] border-4 ${currentTheme.widgetBorder} shadow-sm overflow-x-auto no-scrollbar`}>
        <button 
          onClick={() => setActiveSubTab('benda')}
          className={`flex-1 min-w-[120px] py-4 rounded-2xl font-headline font-bold uppercase tracking-widest text-[10px] transition-all flex items-center justify-center gap-2 ${
            activeSubTab === 'benda' ? 'bg-purple-500 text-white shadow-lg' : (isDark ? 'text-slate-400 hover:bg-slate-700' : 'text-slate-400 hover:bg-slate-50')
          }`}
        >
          <Shapes size={16} />
          Data Benda
        </button>
        <button 
          onClick={() => setActiveSubTab('lagu')}
          className={`flex-1 min-w-[120px] py-4 rounded-2xl font-headline font-bold uppercase tracking-widest text-[10px] transition-all flex items-center justify-center gap-2 ${
            activeSubTab === 'lagu' ? 'bg-purple-500 text-white shadow-lg' : (isDark ? 'text-slate-400 hover:bg-slate-700' : 'text-slate-400 hover:bg-slate-50')
          }`}
        >
          <Music size={16} />
          Data Lagu
        </button>
        <button 
          onClick={() => setActiveSubTab('users')}
          className={`flex-1 min-w-[120px] py-4 rounded-2xl font-headline font-bold uppercase tracking-widest text-[10px] transition-all flex items-center justify-center gap-2 ${
            activeSubTab === 'users' ? 'bg-purple-500 text-white shadow-lg' : (isDark ? 'text-slate-400 hover:bg-slate-700' : 'text-slate-400 hover:bg-slate-50')
          }`}
        >
          <Users size={16} />
          User PAUD
        </button>
      </div>

      <div className="mb-20">
        {activeSubTab === 'benda' && (
          <div className="flex flex-col gap-6">
            <div className={`${isDark ? 'bg-slate-800 border-slate-700' : 'bg-white border-slate-100'} p-8 rounded-[2.5rem] border-b-[8px] shadow-sm`}>
              <h3 className={`font-headline font-black text-xl mb-6 flex items-center gap-2 ${isDark ? 'text-white' : 'text-on-surface'}`}>
                <div className="w-2 h-8 bg-purple-500 rounded-full" />
                Tambah Benda Baru
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <input type="text" placeholder="Nama Benda (misal: Gajah)" className={`${isDark ? 'bg-slate-900 border-slate-800 text-white placeholder:text-slate-600' : 'bg-slate-50 border-slate-100 text-on-surface'} border-2 rounded-2xl px-6 py-4 font-headline font-bold outline-none focus:border-purple-300 transition-all`} />
                <input type="text" placeholder="URL Gambar (Direct Link)" className={`${isDark ? 'bg-slate-900 border-slate-800 text-white placeholder:text-slate-600' : 'bg-slate-50 border-slate-100 text-on-surface'} border-2 rounded-2xl px-6 py-4 font-headline font-bold outline-none focus:border-purple-300 transition-all`} />
                <button className="md:col-span-2 bg-purple-500 text-white font-headline font-black py-5 rounded-2xl shadow-tactile-purple tactile-press uppercase tracking-[0.2em]">SIMPAN DATA</button>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {objects.map((obj, i) => (
                <div key={i} className={`${isDark ? 'bg-slate-800 border-slate-700' : 'bg-white border-slate-50'} p-4 rounded-3xl border-2 flex items-center gap-4 group shadow-sm hover:shadow-md transition-all`}>
                  <div className={`${isDark ? 'bg-slate-900 border-slate-800 shadow-inner' : 'bg-slate-50 border-slate-100'} w-20 h-20 rounded-2xl border-2 p-2 overflow-hidden flex-shrink-0`}>
                    <img src={obj.img} className="w-full h-full object-contain group-hover:scale-110 transition-transform" />
                  </div>
                  <div className="flex-1 overflow-hidden">
                    <p className={`font-headline font-black text-lg ${isDark ? 'text-white' : 'text-slate-800'}`}>{obj.name}</p>
                    <p className={`text-[10px] ${isDark ? 'text-slate-300' : 'text-slate-400'} font-bold truncate tracking-widest`}>{obj.img}</p>
                  </div>
                  <button className="text-red-400 p-3 hover:bg-red-50 rounded-xl transition-colors">
                    <LogOut size={20} className="rotate-180" />
                  </button>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeSubTab === 'lagu' && (
          <div className="flex flex-col gap-6">
            <div className={`${isDark ? 'bg-slate-800 border-slate-700' : 'bg-white border-slate-100'} p-8 rounded-[2.5rem] border-b-[8px] shadow-sm`}>
              <h3 className={`font-headline font-black text-xl mb-6 flex items-center gap-2 ${isDark ? 'text-white' : 'text-on-surface'}`}>
                <div className="w-2 h-8 bg-purple-500 rounded-full" />
                Tambah Lagu Anak
              </h3>
              <div className="grid grid-cols-1 gap-4">
                <input 
                  type="text" 
                  value={newSongTitle}
                  onChange={(e) => setNewSongTitle(e.target.value)}
                  placeholder="Judul Lagu" 
                  className={`${isDark ? 'bg-slate-900 border-slate-800 text-white placeholder:text-slate-600' : 'bg-slate-50 border-slate-100 text-on-surface'} border-2 rounded-2xl px-6 py-4 font-headline font-bold outline-none focus:border-purple-300 transition-all`} 
                />
                <input 
                  type="text" 
                  value={newSongUrl}
                  onChange={(e) => setNewSongUrl(e.target.value)}
                  placeholder="URL YouTube Embed (misal: https://www.youtube.com/embed/...)" 
                  className={`${isDark ? 'bg-slate-900 border-slate-800 text-white placeholder:text-slate-600' : 'bg-slate-50 border-slate-100 text-on-surface'} border-2 rounded-2xl px-6 py-4 font-headline font-bold outline-none focus:border-purple-300 transition-all`} 
                />
                <button 
                  onClick={handleAddSong}
                  disabled={isSubmitting}
                  className={`${isSubmitting ? 'bg-slate-400 cursor-not-allowed' : 'bg-purple-500 hover:bg-purple-400'} text-white font-headline font-black py-5 rounded-2xl shadow-tactile-purple tactile-press uppercase tracking-[0.2em] transition-all`}
                >
                  {isSubmitting ? 'MEMPROSES...' : 'TAMBAH LAGU'}
                </button>
              </div>
            </div>
            
            <div className="grid grid-cols-1 gap-4">
              {songs.map((song, i) => (
                <div key={i} className={`${isDark ? 'bg-slate-800 border-slate-700' : 'bg-white border-slate-50'} p-5 rounded-3xl border-2 flex items-center gap-5 shadow-sm hover:shadow-md transition-all`}>
                  <div className={`${isDark ? 'bg-pink-900/40 border-pink-700 shadow-inner' : 'bg-pink-100 border-pink-50'} w-20 h-20 rounded-2xl flex items-center justify-center text-pink-500 flex-shrink-0 border-2`}>
                    <Video size={36} />
                  </div>
                  <div className="flex-1 overflow-hidden">
                    <p className={`font-headline font-black text-xl ${isDark ? 'text-white' : 'text-slate-800'}`}>{song.title}</p>
                    <p className={`text-[10px] ${isDark ? 'text-slate-300' : 'text-slate-400'} font-bold truncate tracking-widest uppercase mt-1`}>{song.videoUrl}</p>
                  </div>
                  <button 
                    onClick={() => handleDeleteSong(song.id)}
                    className="text-slate-300 hover:text-red-500 p-3 hover:bg-red-50 rounded-xl transition-all"
                  >
                    <LogOut size={24} className="rotate-180" />
                  </button>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeSubTab === 'users' && (
          <div className={`${isDark ? 'bg-slate-800 border-slate-700' : 'bg-white border-slate-100'} p-8 rounded-[2.5rem] border-b-[8px] shadow-sm text-center`}>
             <div className={`${isDark ? 'bg-slate-700 text-slate-500' : 'bg-slate-100 text-slate-400'} w-20 h-20 rounded-full mx-auto flex items-center justify-center mb-4`}>
                <Users size={40} />
             </div>
             <h3 className={`font-headline font-black text-2xl mb-2 ${isDark ? 'text-white' : 'text-slate-800'}`}>Daftar Pengguna</h3>
             <p className={`font-headline font-bold ${isDark ? 'text-slate-300' : 'text-slate-400'} mb-6`}>Kelola data anak dan wali murid di sini.</p>
             <div className={`${isDark ? 'bg-slate-900 border-slate-700' : 'bg-slate-50 border-slate-200'} p-6 rounded-2xl border-2 border-dashed`}>
                <p className={`font-headline font-bold ${isDark ? 'text-slate-400' : 'text-slate-400'} text-sm`}>Fitur ini sedang dalam pengembangan oleh tim TI.</p>
             </div>
          </div>
        )}
      </div>
    </div>
  );
}
