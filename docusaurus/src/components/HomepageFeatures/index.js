import clsx from 'clsx';
import {useState, useEffect} from 'react';
import Heading from '@theme/Heading';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './styles.module.css';
import featuresData from './features.json';

function InlineSvg({src, className, title}) {
    const [svgContent, setSvgContent] = useState(null);

    useEffect(() => {
        fetch(src)
            .then((res) => res.text())
            .then((text) => setSvgContent(text))
            .catch(() => setSvgContent(null));
    }, [src]);

    if (!svgContent) {
        return <img src={src} className={className} role="img" alt={title} />;
    }

    return (
        <div
            className={className}
            role="img"
            aria-label={title}
            dangerouslySetInnerHTML={{__html: svgContent}}
        />
    );
}

function Feature({image, title, description}) {
    const imageSrc = useBaseUrl(`/img/features/${image}`);
    const isSvg = image.endsWith('.svg');

    return (
        <div className={clsx('col col--4')}>
            <div className="text--center">
                {isSvg ? (
                    <InlineSvg src={imageSrc} className={styles.featureSvg} title={title} />
                ) : (
                    <img src={imageSrc} className={styles.featureSvg} role="img" alt={title} />
                )}
            </div>
            <div className="text--center padding-horiz--md">
                <Heading as="h3">{title}</Heading>
                <p dangerouslySetInnerHTML={{__html: description}} />
            </div>
        </div>
    );
}

export default function HomepageFeatures() {
    return (
        <section className={styles.features}>
            <div className="container">
                <div className="row">
                    {featuresData.map((props, idx) => (
                        <Feature key={idx} {...props} />
                    ))}
                </div>
            </div>
        </section>
    );
}
