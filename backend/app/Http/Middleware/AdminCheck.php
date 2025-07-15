<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;

class AdminCheck
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Cek apakah user sudah login DAN rolenya adalah 'admin'
        if (Auth::check() && Auth::user()->role == 'admin') {
            // Jika ya, izinkan request untuk melanjutkan
            return $next($request);
        }

        // Jika tidak, kembalikan user ke halaman dashboard
        return redirect('/dashboard')->with('error', 'You do not have admin access.');
    }
}