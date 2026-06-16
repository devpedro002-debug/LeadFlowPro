'use client';

import { LogOut, User } from 'lucide-react';
import { logout } from '@/actions/auth';
import { ThemeToggle } from '@/components/ui/ThemeToggle';
import { useOperator } from '@/components/providers/OperatorProvider';
import { NotificationBell } from '@/features/notifications/NotificationBell';

interface HeaderProps {
  userName: string;
}

export function Header({ userName }: HeaderProps) {
  const { activeOperator, setActiveOperator } = useOperator();

  return (
    <header className="h-16 bg-white/80 dark:bg-slate-950/80 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 fixed top-0 right-0 left-64 z-40 flex items-center justify-between px-6 transition-colors">
      <div className="flex items-center">
        {activeOperator && (
          <div className="flex items-center gap-2 px-3 py-1.5 bg-gold-50 dark:bg-gold-900/20 text-gold-700 dark:text-gold-400 rounded-lg text-sm font-medium border border-gold-100 dark:border-gold-800/50">
            <span className="w-2 h-2 rounded-full bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]" />
            <span className="opacity-70 text-xs uppercase tracking-wider ml-1">Operando como:</span>
            <span>{activeOperator.name}</span>
            <button 
              onClick={() => setActiveOperator(null)}
              className="ml-2 pl-2 border-l border-gold-200 dark:border-gold-800 hover:text-gold-900 dark:hover:text-gold-300 transition-colors text-xs opacity-70 hover:opacity-100"
              title="Trocar operador"
            >
              Trocar
            </button>
          </div>
        )}
      </div>
      <div className="flex items-center gap-4">
        {/* Sino de Notificações */}
        <NotificationBell />

        {/* Toggle de Tema */}
        <ThemeToggle />
        
        <div className="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300 border-l border-slate-200 dark:border-slate-800 pl-4 transition-colors">
          <User className="w-4 h-4" />
          <span className="font-medium">{userName}</span>
        </div>
        <form action={logout}>
          <button
            type="submit"
            className="flex items-center gap-2 text-sm text-slate-400 hover:text-rose-500 transition-colors px-3 py-1.5 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/30"
          >
            <LogOut className="w-4 h-4" />
            Sair
          </button>
        </form>
      </div>
    </header>
  );
}
