<!DOCTYPE html>
<html lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Modern Themes Gameplay V3</title>
<script src="[https://cdn.tailwindcss.com?plugins=forms,container-queries](https://cdn.tailwindcss.com/?plugins=forms,container-queries)"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Spline+Sans:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
tailwind.config = {
darkMode: "class",
theme: {
extend: {
colors: {
"primary": "#7C3AED",
"christmas-red": "#D42426",
"christmas-gold": "#D4AF37",
"cream-bg": "#FFF9F2",
},
fontFamily: {
"display": ["Spline Sans", "sans-serif"]
},
borderRadius: {
"DEFAULT": "1rem",
"lg": "2rem",
"xl": "3rem",
"full": "9999px"
},
},
},
}
</script>
<style type="text/tailwindcss">
:root {
--primary-accent: #7C3AED;
}
.marker-pulse {
border: 2px solid var(--primary-accent);
box-shadow: 0 0 10px var(--primary-accent), inset 0 0 10px var(--primary-accent);
background: transparent;
}
.ios-blur {
backdrop-filter: blur(20px);
-webkit-backdrop-filter: blur(20px);
}
body {
min-height: 100dvh;
}
.pb-safe {
padding-bottom: env(safe-area-inset-bottom);
}
.glow-button {
box-shadow: 0 0 15px rgba(124, 58, 237, 0.4);
}
</style>
<style>
body {
min-height: max(884px, 100dvh);
}
</style>
<style>
body {
min-height: max(884px, 100dvh);
}
</style>
</head>
<body class="bg-cream-bg font-display text-neutral-800 selection:bg-primary/30 overflow-hidden h-screen flex flex-col">
<header class="relative z-50 flex items-center px-4 pt-12 pb-4 bg-cream-bg/80 ios-blur border-b border-orange-100 gap-4">
<button class="flex-shrink-0 flex size-10 items-center justify-center rounded-full bg-white shadow-sm border border-neutral-100 hover:bg-neutral-50 active:scale-95 transition-all">
<span class="material-symbols-outlined text-neutral-800 text-2xl">arrow_back_ios_new</span>
</button>
<div class="flex-1 flex flex-col items-center">
<div class="flex items-center gap-2 mb-1.5">
<span class="text-[10px] font-black tracking-[0.2em] uppercase text-neutral-400">Progress</span>
<span class="text-neutral-900 text-sm font-black leading-none">2/5</span>
</div>
<div class="w-full h-1.5 bg-neutral-200 rounded-full overflow-hidden">
<div class="w-2/5 h-full bg-christmas-red"></div>
</div>
</div>
<div class="flex-shrink-0 flex items-center gap-2">
<button class="flex size-10 items-center justify-center rounded-full bg-white shadow-sm border border-neutral-100 glow-button hover:bg-neutral-50 active:scale-95 transition-all">
<span class="material-symbols-outlined text-primary text-xl">zoom_in</span>
</button>
<button class="flex size-10 items-center justify-center rounded-full bg-primary glow-button hover:brightness-110 active:scale-95 transition-all">
<span class="material-symbols-outlined text-white text-xl" style="font-variation-settings: 'FILL' 1">lightbulb</span>
</button>
</div>
</header>
<main class="flex-1 flex flex-col gap-3 p-3 overflow-hidden">
<div class="relative flex-1 rounded-2xl overflow-hidden border-2 border-white shadow-xl">
<div class="absolute inset-0 bg-center bg-cover" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuC0JdOXu5kUeqUAFc6DFBnwcK4RRKC8FxGN0IMaWwmcbU-_Z09eywtfqKbZQiJ8Obd675Cqqil9jPkQ9g66m6uoQYSLyO7-JyPBhRVfLUfIp1vFJssxY0i4yOckIeKFwmPaUQiLFldF4RU6RlW0_26y9JM4QIoRWFZwkm6gV1vQQQUCkOJnb9t7Go4B-_od5lqhAoZg95Qgd7-Nz1-LoHHlj1VNU9gALAIz-tKgJ1bI1obRihwSJFgDkwZ4hV0uTcGjw2q_W8GgVpw');"></div>
<div class="marker-pulse absolute top-[45%] left-[25%] size-12 rounded-full pointer-events-none"></div>
<div class="marker-pulse absolute top-[20%] right-[35%] size-12 rounded-full pointer-events-none"></div>
<div class="absolute top-3 left-3 px-3 py-1 bg-black/40 rounded-sm text-[10px] font-bold uppercase tracking-widest text-white ios-blur">Original</div>
</div>
<div class="relative flex-1 rounded-2xl overflow-hidden border-2 border-white shadow-xl">
<div class="absolute inset-0 bg-center bg-cover" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCz2f3RrS9Q2RWoBLp79EiB6LxjZQkHLDsR3wn4GqBwhsGUMlaP13VLU4KN2n1RnFvXDrjMNRe4oBkaOBTvSYRYDwZ41cFwnJk6y3mlfhkRC3OO7AGv4R2J6c4Zff7K0gv6cBJ4XEGC94RIwfjumWbDlvvqklqzxdhWYBFR9GePLurym_2D454p1fIHSxwbbc2EAoapUHeNLaBhlgO0iXe5fH03D0SuAj40EkEy-0_BUaQLyuTQ2xYMTMorK7oiZJsYVaXlXhJonpI');"></div>
<div class="marker-pulse absolute top-[45%] left-[25%] size-12 rounded-full pointer-events-none"></div>
<div class="marker-pulse absolute top-[20%] right-[35%] size-12 rounded-full pointer-events-none"></div>
<div class="absolute top-3 left-3 px-3 py-1 bg-primary/90 rounded-sm text-[10px] font-bold uppercase tracking-widest text-white ios-blur">Find the Changes</div>
</div>
</main>
<footer class="w-full">
<div class="w-full h-16 bg-neutral-900 flex items-center justify-center relative">
<div class="absolute top-0 left-0 bg-primary px-2 py-0.5 text-[9px] font-bold uppercase text-white">Ad</div>
<div class="flex items-center gap-4 w-full px-6">
<div class="w-8 h-8 rounded bg-neutral-800 border border-neutral-700 flex-shrink-0"></div>
<div class="flex flex-col flex-1">
<span class="text-[11px] text-white font-bold tracking-wide uppercase">Modern Living Expo</span>
<span class="text-[9px] text-neutral-500">Sponsored • Integrated Experience</span>
</div>
<button class="px-4 py-1.5 bg-white text-black text-[10px] font-black rounded-full uppercase tracking-tighter hover:bg-neutral-200 transition-colors">Visit</button>
</div>
</div>
<div class="bg-cream-bg pb-safe">
<div class="h-1 bg-neutral-300 w-32 mx-auto mt-4 mb-2 rounded-full"></div>
</div>
</footer>

</body></html>