/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['localhost'],
  },
  // This adds support for styled-jsx
  compiler: {
    styledComponents: true,
  },
  // Environment variables available on the client
  publicRuntimeConfig: {
    // Will be available as process.env.NEXT_PUBLIC_*
  },
  // Allow communication with Payload API
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${
          process.env.NODE_ENV === 'production'
            ? process.env.NEXT_PUBLIC_PAYLOAD_URL
            : 'http://payload:3000'
        }/api/:path*`,
      },
    ];
  },
};

module.exports = nextConfig;