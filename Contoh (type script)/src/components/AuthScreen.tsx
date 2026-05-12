import React, { useState } from 'react';
import { 
  createUserWithEmailAndPassword, 
  signInWithEmailAndPassword,
  updateProfile
} from 'firebase/auth';
import { doc, setDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db, handleFirestoreError, OperationType } from '../lib/firebase';
import { motion } from 'motion/react';
import { 
  Mail, Lock, User, Eye, EyeOff, Loader2, ArrowRight, ShieldCheck 
} from 'lucide-react';

export function AuthScreen() {
  const [isLogin, setIsLogin] = useState(true);
  const [isAdminLogin, setIsAdminLogin] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [childName, setChildName] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const validate = () => {
    if (!email.includes('@')) {
      setError('Email belum valid ya Bunda/Ayah');
      return false;
    }
    if (password.length < 6) {
      setError('Password minimal 6 karakter ya');
      return false;
    }
    if (!isLogin && !childName && !isAdminLogin) {
      setError('Nama anak tidak boleh kosong');
      return false;
    }
    return true;
  };

  const handleAdminMode = () => {
    setIsAdminLogin(!isAdminLogin);
    setIsLogin(true);
    setEmail('');
    setPassword('');
    setError('');
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    
    setLoading(true);
    setError('');

    try {
      if (isLogin) {
        await signInWithEmailAndPassword(auth, email, password);
      } else {
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        
        // Save profile
        await updateProfile(user, { displayName: childName });
        
        // Save to Firestore
        const userDoc = {
          uid: user.uid,
          email: user.email,
          childName: childName,
          createdAt: serverTimestamp()
        };
        
        try {
          await setDoc(doc(db, 'users', user.uid), userDoc);
        } catch (err) {
          handleFirestoreError(err, OperationType.WRITE, `users/${user.uid}`);
        }
      }
    } catch (err: any) {
      console.error(err);
      if (err.code === 'auth/user-not-found' || err.code === 'auth/wrong-password') {
        setError('Email atau password salah nih');
      } else if (err.code === 'auth/email-already-in-use') {
        setError('Email ini sudah terdaftar ya');
      } else {
        setError('Maaf, ada kendala. Coba lagi ya Bunda/Ayah');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-surface flex flex-col items-center justify-center p-6 relative overflow-hidden">
      {/* Background blobs */}
      <div className={`absolute top-0 right-0 w-64 h-64 ${isAdminLogin ? 'bg-purple-500/10' : 'bg-primary/10'} rounded-full blur-3xl -mr-32 -mt-32`} />
      <div className={`absolute bottom-0 left-0 w-64 h-64 ${isAdminLogin ? 'bg-indigo-500/10' : 'bg-secondary/10'} rounded-full blur-3xl -ml-32 -mb-32`} />

      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md flex flex-col items-center"
      >
        <motion.div 
          initial={{ opacity: 0, scale: 0.5, rotate: -10 }}
          animate={{ 
            opacity: 1, 
            scale: 1, 
            rotate: 0,
            y: [0, -10, 0]
          }}
          transition={{
            y: { duration: 3, repeat: Infinity, ease: "easeInOut" },
            default: { duration: 0.5 }
          }}
          className={`bg-white p-2 rounded-3xl border-4 ${isAdminLogin ? 'border-purple-600 shadow-tactile-purple' : 'border-primary shadow-tactile-orange'} mb-8 overflow-hidden`}
        >
          <img 
            src={isAdminLogin ? "https://img.freepik.com/free-vector/grandfather-learning-cartoon_1308-132474.jpg" : "https://img.freepik.com/free-vector/cheerful-rabbit-cartoon-character_1308-164745.jpg"} 
            alt="Character" 
            className="w-32 h-32 object-cover"
          />
        </motion.div>

        <motion.h1 
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          className={`font-headline text-3xl font-black ${isAdminLogin ? 'text-purple-700' : 'text-on-surface'} text-center mb-2`}
        >
          {isAdminLogin ? 'Masuk Mode Pengajar' : isLogin ? 'Halo! Yuk masuk dulu.' : 'Halo! Yuk buat akun dulu ya.'}
        </motion.h1>
        <motion.p 
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.1 }}
          className="text-on-surface-variant font-headline text-center mb-8"
        >
          {isAdminLogin ? 'Kelola pembelajaran dan pantau progres murid.' : isLogin ? 'Siap melanjutkan keseruan belajar?' : 'Bergabunglah dengan keseruan belajar!'}
        </motion.p>

        <motion.form 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          onSubmit={handleSubmit} 
          className="w-full space-y-4"
        >
          {!isLogin && !isAdminLogin && (
            <div className="space-y-2">
              <label className="block font-headline font-bold text-sm ml-4">Nama Anak</label>
              <div className="relative">
                <User className="absolute left-4 top-1/2 -translate-y-1/2 text-primary" size={20} />
                <input 
                  type="text"
                  placeholder="Siapa nama jagoan kecilnya?"
                  className="w-full bg-white border-b-4 border-slate-200 rounded-2xl py-4 pl-12 pr-4 font-headline outline-none focus:border-primary transition-all shadow-sm"
                  value={childName}
                  onChange={(e) => setChildName(e.target.value)}
                />
              </div>
            </div>
          )}

          <div className="space-y-2">
            <label className="block font-headline font-bold text-sm ml-4">Email</label>
            <div className="relative">
              <Mail className={`absolute left-4 top-1/2 -translate-y-1/2 ${isAdminLogin ? 'text-purple-600' : 'text-primary'}`} size={20} />
              <input 
                type="email"
                placeholder={isAdminLogin ? "admin@paud.sch.id" : "ayah.bunda@email.com"}
                className={`w-full bg-white border-b-4 border-slate-200 rounded-2xl py-4 pl-12 pr-4 font-headline outline-none transition-all shadow-sm ${isAdminLogin ? 'focus:border-purple-600' : 'focus:border-primary'}`}
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="block font-headline font-bold text-sm ml-4">Password</label>
            <div className="relative">
              <Lock className={`absolute left-4 top-1/2 -translate-y-1/2 ${isAdminLogin ? 'text-purple-600' : 'text-primary'}`} size={20} />
              <input 
                type={showPassword ? 'text' : 'password'}
                placeholder="Ketik password rahasia..."
                className={`w-full bg-white border-b-4 border-slate-200 rounded-2xl py-4 pl-12 pr-12 font-headline outline-none transition-all shadow-sm ${isAdminLogin ? 'focus:border-purple-600' : 'focus:border-primary'}`}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
              <button 
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400"
              >
                {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
              </button>
            </div>
          </div>

          {error && (
            <motion.div 
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              className="bg-red-100 text-red-600 p-4 rounded-xl text-sm font-headline font-bold border-2 border-red-200 text-center"
            >
              {error}
            </motion.div>
          )}

          <button 
            type="submit"
            disabled={loading}
            className={`w-full py-5 rounded-full border-b-[8px] font-headline font-black text-on-primary-fixed uppercase tracking-widest flex items-center justify-center gap-2 tactile-press disabled:opacity-50 mt-4 ${
              isAdminLogin ? 'bg-purple-600 border-purple-800' : 'bg-primary border-orange-600'
            }`}
          >
            {loading ? (
              <Loader2 className="animate-spin" size={24} />
            ) : (
              <>
                <span>{isAdminLogin ? 'Masuk Panel Admin' : isLogin ? 'Masuk Sekarang' : 'Daftar Sekarang'}</span>
                <ArrowRight size={24} className="stroke-[4px]" />
              </>
            )}
          </button>
        </motion.form>

        <div className="mt-8 flex flex-col items-center gap-4 w-full">
          <button 
            onClick={() => {
              setIsLogin(!isLogin);
              setIsAdminLogin(false);
              setError('');
            }}
            className="font-headline font-bold text-primary-fixed uppercase underline underline-offset-4 tracking-wider"
          >
            {isAdminLogin ? 'Kembali ke Login Anak' : isLogin ? 'Belum punya akun? Daftar gratis' : 'Sudah punya akun? Masuk'}
          </button>

          {!isAdminLogin && (
            <button 
              type="button"
              onClick={handleAdminMode}
              className="flex items-center gap-2 px-6 py-3 bg-slate-100 rounded-full font-headline font-bold text-slate-500 text-xs uppercase tracking-widest hover:bg-purple-50 hover:text-purple-600 transition-all border-b-4 border-slate-200 shadow-sm"
            >
              <ShieldCheck size={16} />
              Khusus Guru / Admin
            </button>
          )}
        </div>
      </motion.div>
    </div>
  );
}
