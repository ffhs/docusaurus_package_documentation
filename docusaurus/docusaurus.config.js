// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/** @type {import('@docusaurus/types').Config} */
const config = {
    title: 'FFHS Package',
    tagline: 'Metadata are missing',
    favicon: 'img/favicon.ico',

    // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
    future: {
        v4: true, // Improve compatibility with the upcoming Docusaurus v4
    },

    // Set the production url of your site here
    url: 'https://your-docusaurus-site.example.com',
    // Set the /<baseUrl>/ pathname under which your site is served
    // For GitHub pages deployment, it is often '/<projectName>/'
    baseUrl: '/',

    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: 'FFHS', // Usually your GitHub org/user name.
    projectName: 'FFHS Approvals', // Usually your repo name.

    onBrokenLinks: 'throw',

    // Even if you don't use internationalization, you can use this field to set
    // useful metadata like html lang. For example, if your site is Chinese, you
    // may want to replace "en" with "zh-Hans".
    i18n: {
        defaultLocale: 'en',
        locales: ['en'],
    },

    presets: [
        [
            'classic',
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    sidebarPath: './sidebars.js',
                    routeBasePath: '/'
                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    // editUrl:
                    //     'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
                },
                blog: false,
                theme: {
                    customCss: './src/css/custom.css',
                },
            }),
        ],
    ],

    themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            // Replace with your project's social card
            image: 'img/docusaurus-social-card.jpg',
            colorMode: {
                defaultMode: 'dark',
                disableSwitch: true,
                respectPrefersColorScheme: false,
            },
            navbar: {
                title: 'FFHS Approvals',
                logo: {
                    alt: 'Tool Logo',
                    src: 'img/logo.png',
                },
                items: [
                    {
                        type: 'docSidebar',
                        sidebarId: 'docSidebar',
                        position: 'left',
                        label: 'Docs',
                    },
                    {
                        type: 'docsVersionDropdown',
                        position: 'right',
                    },
                    {
                        href: 'https://github.com/ffhs/filament-package_ffhs_approvals',
                        label: 'GitHub',
                        position: 'right',
                    },
                    {
                        href: 'https://www.ffhs.ch/en/',
                        label: 'FFHS',
                        position: 'right',
                    },
                ],
            },
            footer: {
                style: 'dark',
                links: [
                    {
                        title: 'Fernfachhochschule Schweiz',
                        items: [
                            {
                                html: `
                              <p style="padding-top: 15px; font-size: 1.2rem">
                              <strong>Hochschulcampus Brig</strong> <br>
                                Schinerstrasse 18 <br>
                                CH-3900 Brig<br>
                                Telefon +41 27 510 38 00<br>
                                info(at)ffhs.ch
                                </p>
                              `,
                            },
                            {
                                html: `
                              <p style="padding-top: 15px">
                              <strong>Gleisarena Campus Zürich</strong> <br>
                                Zollstrasse 17 <br>
                                CH-8005 Zürich<br>
                               Telefon +41 27 510 38 00<br>
                                empfang.gleisarena(at)ffhs.ch
                                </p>
                              `,
                            },
                            {
                                html: `
                              <p style="padding-top: 15px">
                              <strong>Mitglied der</strong> <br>
                              <img src="/img/logos/supsi_white.png" style="width: 250px" alt="SUPSI Logo">
                                </p>
                              `,
                            },
                        ],
                    },
                    {
                        title: 'Direkteinstieg',
                        items: [

                            {
                                label: 'Medien',
                                to: 'https://www.ffhs.ch/en/medien',
                            },
                            {
                                label: 'Studieninteressierte',
                                to: 'https://www.ffhs.ch/en/studium',
                            },
                            {
                                label: 'Forschende',
                                to: 'https://www.ffhs.ch/en/forschung',
                            },
                            {
                                label: 'Alumni FFHS',
                                to: 'https://www.ffhs.ch/en/alumni-ffhs',
                            },
                            {
                                html: `
                                <div style="padding-top: 132px"></div>
                                <a href="https://www.instagram.com/myffhs/" target="_blank" rel="noopener noreferrer">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" class="footer-icon">
                                            <path d="M224.1 141c-63.6 0-114.9 51.3-114.9 114.9s51.3 114.9 114.9 114.9S339 319.5 339 255.9 287.7 141 224.1 141zm0 189.6c-41.1 0-74.7-33.5-74.7-74.7s33.5-74.7 74.7-74.7 74.7 33.5 74.7 74.7-33.6 74.7-74.7 74.7zm146.4-194.3c0 14.9-12 26.8-26.8 26.8-14.9 0-26.8-12-26.8-26.8s12-26.8 26.8-26.8 26.8 12 26.8 26.8zm76.1 27.2c-1.7-35.9-9.9-67.7-36.2-93.9-26.2-26.2-58-34.4-93.9-36.2-37-2.1-147.9-2.1-184.9 0-35.8 1.7-67.6 9.9-93.9 36.1s-34.4 58-36.2 93.9c-2.1 37-2.1 147.9 0 184.9 1.7 35.9 9.9 67.7 36.2 93.9s58 34.4 93.9 36.2c37 2.1 147.9 2.1 184.9 0 35.9-1.7 67.7-9.9 93.9-36.2 26.2-26.2 34.4-58 36.2-93.9 2.1-37 2.1-147.8 0-184.8zM398.8 388c-7.8 19.6-22.9 34.7-42.6 42.6-29.5 11.7-99.5 9-132.1 9s-102.7 2.6-132.1-9c-19.6-7.8-34.7-22.9-42.6-42.6-11.7-29.5-9-99.5-9-132.1s-2.6-102.7 9-132.1c7.8-19.6 22.9-34.7 42.6-42.6 29.5-11.7 99.5-9 132.1-9s102.7-2.6 132.1 9c19.6 7.8 34.7 22.9 42.6 42.6 11.7 29.5 9 99.5 9 132.1s2.7 102.7-9 132.1z"></path>
                                    </svg>
                                </a>
                                <a href="https://www.linkedin.com/school/fernfachhochschule-schweiz/" target="_blank" rel="noopener noreferrer">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" class="footer-icon">
                                        <path d="M416 32H31.9C14.3 32 0 46.5 0 64.3v383.4C0 465.5 14.3 480 31.9 480H416c17.6 0 32-14.5 32-32.3V64.3c0-17.8-14.4-32.3-32-32.3zM135.4 416H69V202.2h66.5V416zm-33.2-243c-21.3 0-38.5-17.3-38.5-38.5S80.9 96 102.2 96c21.2 0 38.5 17.3 38.5 38.5 0 21.3-17.2 38.5-38.5 38.5zm282.1 243h-66.4V312c0-24.8-.5-56.7-34.5-56.7-34.6 0-39.9 27-39.9 54.9V416h-66.4V202.2h63.7v29.2h.9c8.9-16.8 30.6-34.5 62.9-34.5 67.2 0 79.7 44.3 79.7 101.9V416z"></path>
                                    </svg>
                                </a>
                                <a href="https://de-de.facebook.com/Fernfachhochschule/" target="_blank" rel="noopener noreferrer">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" class="footer-icon" style="padding-bottom: 3px">
                                        <path d="M512 256C512 114.6 397.4 0 256 0S0 114.6 0 256C0 376 82.7 476.8 194.2 504.5V334.2H141.4V256h52.8V222.3c0-87.1 39.4-127.5 125-127.5c16.2 0 44.2 3.2 55.7 6.4V172c-6-.6-16.5-1-29.6-1c-42 0-58.2 15.9-58.2 57.2V256h83.6l-14.4 78.2H287V510.1C413.8 494.8 512 386.9 512 256h0z"></path>
                                    </svg>
                                </a>
                                <br>
                                <img src="/img/logos/sar_label.png" alt="sar label" style="width: 300px; padding-top: 63px">
                                `
                            },
                        ],
                    },
                    {
                        title: 'Über uns',
                        items: [
                            {
                                label: 'Die FFHS im Überblick',
                                to: 'https://www.ffhs.ch/en/portraet',
                            },
                            {
                                label: 'Standorte',
                                to: 'https://www.ffhs.ch/en/standorte',
                            },
                            {
                                label: 'Personensuche',
                                to: 'https://www.ffhs.ch/en/personensuche',
                            },
                            {
                                html: `
                                <div style="padding-top: 194px"></div>
                                <img src="/img/logos/swissuniversities.svg" alt="sar label" style="width: 300px; padding-top: 63px">
                                `
                            },
                        ],
                    },
                    {
                        title: ' ',
                        items: [
                            {
                                html: `
                                <div style="margin-top: -18px">
                                    <a href="https://support.ffhs.ch/" style="font-weight: bold" class="footer__title"> Hilfe und Support</a>
                                </div>
                                `
                            }
                        ],
                    },
                ],
                copyright: `
                    <div style="width: 100%; text-align: start; padding-top: 5px; font-size: 1.1rem">
                        ©${new Date().getFullYear()} FFHS
                        <a href="https://www.ffhs.ch/en/impressum" class="footer_lower_link"> Impressum</a>
                        <a href="https://www.ffhs.ch/en/datenschutzerklaerung" class="footer_lower_link"> Datenschutzerklaerung</a>
                        <a href="https://www.ffhs.ch/fileadmin/dam/upload/studium/reglemente/ffhs-agb.pdf" class="footer_lower_link" > AGB FFHS</a>
                        <a href="https://www.ffhs.ch/fileadmin/dam/upload/studium/reglemente/agb-ffhs-raumvermietung.pdf" class="footer_lower_link"> AGB Raumvermietung</a>
                    </div>
                `,
            },
            prism: {
                theme: prismThemes.github,
                darkTheme: prismThemes.dracula,
                additionalLanguages: ['php'],
            },
        }),
};

export default config;
