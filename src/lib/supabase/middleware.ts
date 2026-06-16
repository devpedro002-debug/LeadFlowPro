import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          supabaseResponse = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  // Renova o token automaticamente se expirado
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const pathname = request.nextUrl.pathname;

  // ─── Rotas protegidas — redireciona para login se não autenticado ───
  const protectedPaths = ['/leads', '/templates', '/analytics', '/agenda', '/import', '/settings'];
  const isProtected = protectedPaths.some((p) => pathname.startsWith(p));

  if (!user && isProtected) {
    const url = request.nextUrl.clone();
    url.pathname = '/login';
    return NextResponse.redirect(url);
  }

  // ─── Redireciona usuário autenticado que tenta acessar login/registro ───
  if (user && (pathname === '/login' || pathname === '/registro')) {
    const url = request.nextUrl.clone();
    url.pathname = '/leads';
    return NextResponse.redirect(url);
  }

  // ─── Verifica status de acesso do usuário autenticado ───
  if (user && isProtected) {
    try {
      const { data: profile } = await supabase
        .from('profiles')
        .select('access_status')
        .eq('auth_uid', user.id)
        .single();

      const blockedStatuses = ['PAUSADO', 'SUSPENSO', 'CANCELADO'];
      if (profile && blockedStatuses.includes(profile.access_status)) {
        const url = request.nextUrl.clone();
        url.pathname = '/acesso-suspenso';
        return NextResponse.redirect(url);
      }
    } catch {
      // Se falhar ao verificar status, permite continuar (não bloqueia por erro de rede)
    }
  }

  return supabaseResponse;
}
