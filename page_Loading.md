<!DOCTYPE html>
<html lang="ko"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Editorial Theme Loading Screen</title>
<link href="[https://fonts.googleapis.com](https://fonts.googleapis.com/)" rel="preconnect"/>
<link crossorigin="" href="[https://fonts.gstatic.com](https://fonts.gstatic.com/)" rel="preconnect"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&amp;family=Noto+Sans+KR:wght@400;700;900&amp;display=swap" rel="stylesheet"/>
<script src="[https://cdn.tailwindcss.com?plugins=forms,typography](https://cdn.tailwindcss.com/?plugins=forms,typography)"></script>
<script>
tailwind.config = {
darkMode: "class",
theme: {
extend: {
colors: {
primary: "#7C3AED", // Vibrant Purple from the image
"background-light": "#F2F2F7",
"background-dark": "#1C1C1E",
"muted-grey": "#D1D1D6",
},
fontFamily: {
display: ["Inter", "Noto Sans KR", "sans-serif"],
},
borderRadius: {
DEFAULT: "24px",
},
},
},
};
</script>
<style>
body {
font-family: 'Inter', 'Noto Sans KR', sans-serif;
-webkit-tap-highlight-color: transparent;
}
.loading-progress-animation {
animation: progress-pulse 1.5s ease-in-out infinite;
}
@keyframes progress-pulse {
0%, 100% { opacity: 0.3; }
50% { opacity: 1; }
}
.fade-in {
animation: fadeIn 0.8s ease-out forwards;
}
@keyframes fadeIn {
from { opacity: 0; transform: translateY(10px); }
to { opacity: 1; transform: translateY(0); }
}
</style>
<style>
body {
min-height: max(884px, 100dvh);
}
</style>
</head>
<body class="bg-background-light dark:bg-background-dark min-h-screen flex flex-col items-center justify-between py-12 px-8 overflow-hidden">
<header class="w-full flex flex-col items-center space-y-1 fade-in">
<span class="text-[10px] font-bold tracking-[0.2em] text-primary uppercase">
Volume 01
</span>
<h2 class="text-xs font-black tracking-tight text-black dark:text-white uppercase">
Issue No. 01
</h2>
</header>
<main class="flex-1 flex flex-col items-center justify-center text-center fade-in" style="animation-delay: 0.2s;">
<div class="flex items-center space-x-2 mb-8">
<div class="h-1.5 w-10 bg-primary rounded-full"></div>
<div class="h-1.5 w-1.5 bg-muted-grey dark:bg-zinc-700 rounded-full"></div>
<div class="h-1.5 w-1.5 bg-muted-grey dark:bg-zinc-700 rounded-full"></div>
<div class="h-1.5 w-1.5 bg-muted-grey dark:bg-zinc-700 rounded-full"></div>
</div>
<h1 class="text-5xl font-black tracking-tighter text-black dark:text-white mb-4 uppercase">
틀린그림찾기
</h1>
<p class="text-sm font-medium text-zinc-500 dark:text-zinc-400 max-w-[240px] leading-snug">
Curated visual experiences for the curious mind.
</p>
</main>
<footer class="w-full flex flex-col items-center space-y-6 fade-in" style="animation-delay: 0.4s;">
<div class="relative w-48 h-[2px] bg-muted-grey dark:bg-zinc-800 rounded-full overflow-hidden">
<div class="absolute inset-y-0 left-0 bg-primary w-1/3 rounded-full loading-progress-animation"></div>
</div>
<div class="flex flex-col items-center">
<span class="text-[10px] font-bold tracking-[0.2em] text-zinc-400 dark:text-zinc-500 uppercase">
로딩 중...
</span>
</div>
<div class="pt-8 opacity-20">
<div class="w-10 h-10 rounded-full border-2 border-zinc-300 dark:border-zinc-700 flex items-center justify-center">
<svg class="h-5 w-5 text-zinc-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
<path d="M5 15l7-7 7 7" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></path>
</svg>
</div>
</div>
</footer>
<div class="fixed top-0 left-0 w-full h-full pointer-events-none z-[-1] opacity-30 dark:opacity-10">
<div class="absolute top-[-10%] right-[-10%] w-[50%] h-[40%] bg-primary blur-[120px] rounded-full"></div>
<div class="absolute bottom-[-5%] left-[-5%] w-[40%] h-[30%] bg-zinc-400 blur-[100px] rounded-full"></div>
</div>

</body></html>