+++
title = "IamWorkingOn"
date = 2024-09-27
draft = true
tags = ["saas"]
+++

I decided to take a break from gamedev (albeit not blogging, I still did work on the game the last few months). So, let's dive into something else for the time being.

I won't just disclose what it's about. But let's talk tech: 

It's going to be a web-app based on [SvelteKit] and [Axum]. You might have heard of Svelte, but maybe not of Axum. Axum is a Rust web framework. This might surprise some, but let me explain: 

I'm mostly a backend developer. I'm not particular fond of using JS or TS on the backend. I won't go into details why here, but if you're interested - let me now. I might consider explaining myself.

My work here is based on [Brendon Otto](https://www.brendonotto.com/)'s post on [Axum and Svelte](https://www.brendonotto.com/posts/hello-world-with-axum-and-svelte).

Let's pickup where he left. I also want `npm run dev` to work. To do that, we modify the `svelte.config.js` file again. Replace the adapter import with two imports:
```JS
import adapterStatic from '@sveltejs/adapter-static';
import adapterAuto from '@sveltejs/adapter-auto';
```

[Node.js](https://nodejs.org/) modifies the [NODE_ENV](https://nodejs.org/en/learn/getting-started/nodejs-the-difference-between-development-and-production), using `production` for production builds (`npm build`). So we will use that:
```JS
const isProduction = process.env.NODE_ENV === 'production';
```

And modify the adapter config to use static/auto depending on the environment:
```JS
        adapter: isProduction ? adapterStatic({
			pages: 'build',
			assets: 'build',
			fallback: undefined,
			precompress: false,
			strict: true
		}) : adapterAuto()
```

Resulting in `svelte.config.js` looking like this:
```JS
import adapterStatic from '@sveltejs/adapter-static';
import adapterAuto from '@sveltejs/adapter-auto';

const isProduction = process.env.NODE_ENV === 'production';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
        adapter: isProduction ? adapterStatic({
			pages: 'build',
			assets: 'build',
			fallback: undefined,
			precompress: false,
			strict: true
		}) : adapterAuto()
	}
};

export default config;
```

[SvelteKit]: https://kit.svelte.dev/
[Axum]: https://github.com/tokio-rs/axum
