import { ShieldAlert } from 'lucide-react';
import Link from 'next/link';

export const metadata = { title: 'Acesso Suspenso — LeadFlowPro' };

export default function AcessoSuspensoPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-[#0a0c10] p-4">
      <div className="max-w-md w-full bg-[#13161f] border border-[#2d3148] rounded-2xl p-8 text-center shadow-2xl">
        <div className="w-16 h-16 bg-red-500/10 border border-red-500/20 rounded-2xl flex items-center justify-center mx-auto mb-6">
          <ShieldAlert className="w-8 h-8 text-red-500" />
        </div>
        <h1 className="text-2xl font-bold text-white mb-3">Acesso Indisponível</h1>
        <p className="text-slate-400 text-sm mb-8 leading-relaxed">
          Sua conta encontra-se temporariamente pausada ou suspensa. Por favor, entre em contato com o suporte ou seu gerente de conta para regularizar seu acesso.
        </p>
        <div className="space-y-3">
          <a
            href="mailto:suporte@leadflowpro.com"
            className="block w-full bg-amber-500 hover:bg-amber-600 text-white font-semibold py-3 px-4 rounded-xl transition-all"
          >
            Falar com Suporte
          </a>
          <Link
            href="/login"
            className="block w-full bg-white/5 hover:bg-white/10 text-white font-semibold py-3 px-4 rounded-xl transition-all"
          >
            Voltar para Login
          </Link>
        </div>
      </div>
    </div>
  );
}
