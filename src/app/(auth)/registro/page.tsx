import Link from 'next/link';
import { UserX } from 'lucide-react';

export const metadata = {
  title: 'Registro — LeadFlowPro',
};

export default function RegisterPage() {
  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="text-center">
        <div className="inline-flex items-center gap-3 mb-6">
          <div className="bg-red-500/10 border border-red-500/20 p-3 rounded-2xl shadow-lg transition-transform">
            <UserX className="w-8 h-8 text-red-500" />
          </div>
        </div>
        <h1 className="text-3xl font-extrabold text-white tracking-tight">
          Cadastro Indisponível
        </h1>
        <p className="text-slate-400 mt-4 max-w-sm mx-auto leading-relaxed">
          O cadastro público está temporariamente desativado. O acesso à plataforma LeadFlowPro é feito exclusivamente através de convite ou criação manual por um administrador.
        </p>
      </div>

      <div className="pt-6">
        <Link
          href="/login"
          className="w-full bg-white/5 hover:bg-white/10 text-white font-semibold py-3 px-4 rounded-xl transition-all flex items-center justify-center gap-2"
        >
          Voltar para o Login
        </Link>
      </div>
    </div>
  );
}
