import React, { useEffect, useState } from 'react';
import Head from 'next/head';
import axios from 'axios';

interface Settings {
  siteName: string;
  siteDescription: string;
}

export default function Home() {
  const [settings, setSettings] = useState<Settings | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchSettings = async () => {
      try {
        const response = await axios.get(`${process.env.NEXT_PUBLIC_PAYLOAD_URL}/api/globals/settings`);
        setSettings(response.data);
        setLoading(false);
      } catch (err) {
        console.error('Error fetching settings:', err);
        setError('Failed to load settings from CMS');
        setLoading(false);
      }
    };

    fetchSettings();
  }, []);

  return (
    <div className="container">
      <Head>
        <title>{settings?.siteName || 'ZerviOS'}</title>
        <meta name="description" content={settings?.siteDescription || 'A modern CMS-powered platform'} />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className="main">
        <h1 className="title">
          Welcome to {settings?.siteName || 'ZerviOS'}!
        </h1>

        {loading && <p>Loading...</p>}
        {error && <p className="error">{error}</p>}

        {settings && (
          <div className="description">
            <p>{settings.siteDescription}</p>
          </div>
        )}

        <div className="grid">
          <div className="card">
            <h2>Payload CMS &rarr;</h2>
            <p>Access the Payload CMS admin panel to manage content.</p>
            <a href={`${process.env.NEXT_PUBLIC_PAYLOAD_URL}/admin`} target="_blank" rel="noopener noreferrer">
              Open Admin Panel
            </a>
          </div>

          <div className="card">
            <h2>API Example &rarr;</h2>
            <p>See how the frontend communicates with the Payload API.</p>
          </div>

          <div className="card">
            <h2>Documentation &rarr;</h2>
            <p>Find detailed documentation on project structure and features.</p>
          </div>
        </div>
      </main>

      <footer className="footer">
        <p>Powered by ZerviOS</p>
      </footer>

      <style jsx>{`
        .container {
          min-height: 100vh;
          padding: 0 0.5rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        .main {
          padding: 5rem 0;
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        .footer {
          width: 100%;
          height: 100px;
          border-top: 1px solid #eaeaea;
          display: flex;
          justify-content: center;
          align-items: center;
        }

        .title {
          margin: 0;
          line-height: 1.15;
          font-size: 4rem;
          text-align: center;
        }

        .description {
          text-align: center;
          line-height: 1.5;
          font-size: 1.5rem;
          margin: 2rem 0;
        }

        .grid {
          display: flex;
          align-items: center;
          justify-content: center;
          flex-wrap: wrap;
          max-width: 800px;
          margin-top: 3rem;
        }

        .card {
          margin: 1rem;
          flex-basis: 45%;
          padding: 1.5rem;
          text-align: left;
          color: inherit;
          text-decoration: none;
          border: 1px solid #eaeaea;
          border-radius: 10px;
          transition: color 0.15s ease, border-color 0.15s ease;
        }

        .card:hover,
        .card:focus,
        .card:active {
          color: #0070f3;
          border-color: #0070f3;
        }

        .card h2 {
          margin: 0 0 1rem 0;
          font-size: 1.5rem;
        }

        .card p {
          margin: 0;
          font-size: 1.25rem;
          line-height: 1.5;
        }

        .error {
          color: #ff0000;
        }
      `}</style>

      <style jsx global>{`
        html,
        body {
          padding: 0;
          margin: 0;
          font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto,
            Oxygen, Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue,
            sans-serif;
        }

        * {
          box-sizing: border-box;
        }
      `}</style>
    </div>
  );
}