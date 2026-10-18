// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://chxmxii.github.io',
  base: '/kubegoros',
  integrations: [
    starlight({
      title: 'kubegoros',
      description: 'A kubeadm homelab cluster run from git: Ansible for the nodes, ArgoCD for everything on top.',
      logo: { src: './src/assets/mark.svg', replacesTitle: false },
      social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/chxmxii/kubegoros' }],
      editLink: { baseUrl: 'https://github.com/chxmxii/kubegoros/edit/main/site/' },
      lastUpdated: true,
      customCss: [
        '@fontsource/geist-sans/400.css',
        '@fontsource/geist-sans/500.css',
        '@fontsource/geist-sans/600.css',
        '@fontsource/geist-mono/400.css',
        './src/styles/theme.css',
      ],
      sidebar: [
        { label: 'Getting started', items: [{ autogenerate: { directory: 'getting-started' } }] },
        { label: 'Architecture', items: [{ autogenerate: { directory: 'architecture' } }] },
        { label: 'Operations', items: [{ autogenerate: { directory: 'operations' } }] },
        { label: 'Reference', items: [{ autogenerate: { directory: 'reference' } }] },
      ],
    }),
  ],
});
