import { AppProps } from 'next/app'
import Head from 'next/head'
import { MantineProvider } from '@mantine/core'

export default function App(props: AppProps) {
  const { Component, pageProps } = props

  return (
    <>
      <Head>
        <title>Generate NFT</title>
        <meta name="description" content="Whitelist-Dapp" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <MantineProvider
        withGlobalStyles
        withNormalizeCSS
        theme={{
          /** Put your mantine theme override here */
          colorScheme: 'dark',
          // breakpoints: {
          //   xs: 500,
          //   sm: 800,
          //   md: 1000,
          //   lg: 1200,
          //   xl: 1400,
          // },
        }}
      >
        <Component {...pageProps} />
      </MantineProvider>
    </>
  )
}
