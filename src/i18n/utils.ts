import es from './es.json';
import en from './en.json';

export type Lang = 'es' | 'en';

const translations = { es, en } as const;

export function getLangFromUrl(url: URL): Lang {
  const [, lang] = url.pathname.split('/');
  if (lang in translations) return lang as Lang;
  return 'es';
}

export function useTranslations(lang: Lang) {
  return function t(key: string): any {
    const keys = key.split('.');
    let result: any = translations[lang];
    for (const k of keys) {
      if (result === undefined || result === null) return key;
      result = result[k];
    }
    return result ?? key;
  };
}

export function getLocalePath(lang: Lang, path: string): string {
  if (lang === 'es') return path;
  return `/en${path}`;
}

export const pageRoutes: Record<string, Record<Lang, string>> = {
  home:        { es: '/',              en: '/en/' },
  trajectory:  { es: '/trayectoria',  en: '/en/trajectory' },
  education:   { es: '/formacion',    en: '/en/education' },
  interviews:  { es: '/entrevistas',  en: '/en/interviews' },
  coaching:    { es: '/asesoramiento',en: '/en/coaching' },
  contact:     { es: '/contacto',     en: '/en/contact' },
};

export function getAlternateLangPath(currentLang: Lang, currentPath: string): string {
  const altLang: Lang = currentLang === 'es' ? 'en' : 'es';
  for (const routes of Object.values(pageRoutes)) {
    if (routes[currentLang] === currentPath) {
      return routes[altLang];
    }
  }
  return altLang === 'es' ? '/' : '/en/';
}
