<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

class LocalOnlyFilter implements FilterInterface
{
    private const ALLOWED_IPS = ['127.0.0.1', '::1'];
    private const ALLOWED_HOSTS = ['localhost', '127.0.0.1'];

    public function before(RequestInterface $request, $arguments = null)
    {
        if (ENVIRONMENT !== 'development') {
            return null;
        }

        if (PHP_SAPI === 'cli') {
            return null;
        }

        $ip = trim((string) $request->getIPAddress());
        $host = strtolower((string) $request->getServer('HTTP_HOST'));
        $host = preg_replace('/:\d+$/', '', $host) ?? $host;

        $isIpAllowed = in_array($ip, self::ALLOWED_IPS, true) 
            || str_starts_with($ip, '172.') 
            || str_starts_with($ip, '192.168.');

        $isHostAllowed = in_array($host, self::ALLOWED_HOSTS, true)
            || str_starts_with($host, '172.')
            || str_starts_with($host, '192.168.');

        if ($isIpAllowed && $isHostAllowed) {
            return null;
        }

        return service('response')
            ->setStatusCode(403)
            ->setHeader('Content-Type', 'text/plain; charset=UTF-8')
            ->setBody('Akses ditolak. Mode keamanan lokal hanya mengizinkan localhost.');
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        return $response;
    }
}
