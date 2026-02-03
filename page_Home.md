<!DOCTYPE html>
<html lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Clean White Home Screen Variant</title>
<script src="[https://cdn.tailwindcss.com?plugins=forms,container-queries](https://cdn.tailwindcss.com/?plugins=forms,container-queries)"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
tailwind.config = {
theme: {
extend: {
colors: {
"app-bg": "#F8F9FA",
"card-bg": "#FFFFFF",
"text-main": "#1A1A1A",
"text-secondary": "#6B7280",
"border-light": "#E5E7EB",
"accent-blue": "#3B82F6",
},
fontFamily: {
"sans": ["Inter", "sans-serif"]
},
borderRadius: {
"card": "1.75rem",
"button": "1.5rem"
},
boxShadow: {
'soft': '0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05)',
'card-hover': '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)',
}
},
},
}
</script>
<style type="text/tailwindcss">
.no-scrollbar::-webkit-scrollbar {
display: none;
}
.no-scrollbar {
-ms-overflow-style: none;
scrollbar-width: none;
}
.text-shadow-sm {
text-shadow: 0 1px 2px rgba(0,0,0,0.1);
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
<body class="bg-app-bg font-sans text-text-main antialiased">
<div class="relative min-h-screen max-w-[430px] mx-auto flex flex-col bg-app-bg shadow-xl">
<header class="flex items-center justify-end p-6 pt-10 gap-3">
<button aria-label="Music" class="w-12 h-12 bg-white border border-border-light rounded-full flex items-center justify-center active:bg-gray-100 transition-colors shadow-sm">
<span class="material-symbols-outlined text-gray-600 text-2xl">music_note</span>
</button>
<button aria-label="Vibration" class="w-12 h-12 bg-white border border-border-light rounded-full flex items-center justify-center active:bg-gray-100 transition-colors shadow-sm">
<span class="material-symbols-outlined text-gray-600 text-2xl">vibration</span>
</button>
<button aria-label="Settings" class="w-12 h-12 bg-white border border-border-light rounded-full flex items-center justify-center active:bg-gray-100 transition-colors shadow-sm">
<span class="material-symbols-outlined text-gray-600 text-2xl">settings</span>
</button>
</header>
<main class="flex-1 flex flex-col pt-2">
<div class="px-6 mb-8">
<h2 class="text-xs font-bold uppercase tracking-[0.2em] text-text-secondary mb-4 px-1">Today's Highlight</h2>
<div class="relative w-full aspect-[4/5] bg-card-bg rounded-card overflow-hidden cursor-pointer active:scale-[0.98] transition-all duration-200 shadow-soft group border border-border-light">
<div class="absolute inset-0 bg-cover bg-center" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuBnuB3AxHyy3pak8isPvtPJ5E4dVi1Iwy4iWxvqQKSKZUURq4pvqP9WyrlBLX1VqffVaqpEoHiINgEuqfBzeYqkr2t2djg0JKnHjfgAPkrw2bjh-wi1t4E3G1Xkg4UUHgjLtKOdjcib9nqnNCfXf0v6lAqR7AG8FWda71s2fFBZXRLmz9gsZYqCXsdyAY41CZOfGqYtk4pz5U1qg5stu4UWgWR1B2ZNVOjvugZdagJHuQO2homwjpsT_Z3KpYkCZn1lGAwAJovyI0s');"></div>
<div class="absolute inset-0 bg-gradient-to-t from-white via-white/40 to-transparent"></div>
<div class="absolute inset-0 p-8 flex flex-col justify-end">
<h1 class="text-5xl font-extrabold text-text-main mb-6 leading-tight tracking-tight">Cat vs.<br/>Smartphone</h1>
<div class="space-y-6">
<div class="space-y-2">
<div class="flex justify-between items-end mb-1">
<span class="text-[10px] font-bold text-text-secondary uppercase tracking-widest">Your Progress</span>
<span class="text-xs font-black text-white bg-accent-blue px-2.5 py-0.5 rounded-full">0/20</span>
</div>
<div class="relative h-4 w-full bg-gray-200/60 rounded-full overflow-hidden border border-black/5">
<div class="absolute inset-y-0 left-0 bg-accent-blue rounded-full" style="width: 5%"></div>
</div>
</div>
<div class="flex justify-center pt-2">
<button class="flex items-center justify-center gap-2 bg-accent-blue px-10 py-3.5 rounded-full shadow-lg shadow-blue-500/30 group-active:translate-y-0.5 active:scale-95 transition-all">
<span class="material-symbols-outlined text-white fill-1 text-2xl">play_arrow</span>
<span class="text-white font-bold text-xl uppercase tracking-widest">Play</span>
</button>
</div>
</div>
</div>
</div>
</div>
<div class="flex-1">
<h3 class="text-xs font-bold uppercase tracking-[0.2em] text-text-secondary mb-4 px-7">More Themes</h3>
<div class="flex overflow-x-auto gap-4 pb-8 px-6 no-scrollbar snap-x snap-mandatory">
<div class="min-w-[175px] snap-center flex flex-col cursor-pointer active:scale-95 transition-transform group">
<div class="relative w-full aspect-[3/4] rounded-3xl overflow-hidden mb-3 border border-border-light shadow-soft bg-white">
<div class="absolute inset-0 bg-cover bg-center opacity-90 group-hover:opacity-100 transition-opacity" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuAO4pIYCf8FqypCqWjNQm8DpHQFdgpLnQaVYb3fBOLcCkkijIPCf2Q5rnUxFxRTxfdQidbLJwXMUPknsbtBWwv3pBrBm6qVpt4FGvM6CNB-zXuSR9yTrJDLRibXoo5PQJqKaS0GdxEFLxv528MzP3Q606dqKbrRL5TmlsqQ-RoFhaoZK7o1I89M82TLTH9SrhMsSGOgaVnA9FWnjPZ3gC6IKbtIpZPCSkPNTGmJajXBrG5Pq4ygBk4kcQLlBDfeyX_IVTZgkRVo2dE');"></div>
<div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
<div class="absolute bottom-4 left-4 right-4">
<p class="text-white font-bold text-lg mb-2">Skater Gramps</p>
<div class="w-full h-1.5 bg-white/30 rounded-full overflow-hidden">
<div class="h-full bg-accent-blue" style="width: 40%"></div>
</div>
</div>
</div>
</div>
<div class="min-w-[175px] snap-center flex flex-col cursor-pointer active:scale-95 transition-transform group">
<div class="relative w-full aspect-[3/4] rounded-3xl overflow-hidden mb-3 border border-border-light shadow-soft bg-white">
<div class="absolute inset-0 bg-cover bg-center opacity-90 group-hover:opacity-100 transition-opacity" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCmCH0BIokIttePy6dJbnp5xChpOPZd36x9uTnBOdpRE8RkB7eNff7x6eC4k-OABxENF-1QgNxCDIUguLdVI79pZqBhzuyddXLMjzhtI6qCN0aqYWdfXaJL1T98UhTr9KYOpmIrqnPsulYB5aEvcW2dLOCanv7zwLNNczKllF0Ze9NPkkGKifTedbbpOF0bbG3j7VDSEw23BWHORYPUxY0M7uY-149qiDQSgj-5I_-x2Sz3LzZGtbq1FXZW29dcPlLogX4W6kbfpH4');"></div>
<div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
<div class="absolute bottom-4 left-4 right-4">
<p class="text-white font-bold text-lg mb-2">News Doggo</p>
<div class="w-full h-1.5 bg-white/30 rounded-full overflow-hidden">
<div class="h-full bg-accent-blue" style="width: 15%"></div>
</div>
</div>
</div>
</div>
<div class="min-w-[175px] snap-center flex flex-col cursor-pointer active:scale-95 transition-transform group">
<div class="relative w-full aspect-[3/4] rounded-3xl overflow-hidden mb-3 border border-border-light shadow-soft bg-white">
<div class="absolute inset-0 bg-cover bg-center opacity-90 group-hover:opacity-100 transition-opacity" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuAmhYyGlXzdZ4PssTUpUl1YyEG_mp5Udphr1IBYDqRVC-j1VYgPsfMz_cOSQnGPaL8u054X27OQG8Ye4eQmHtea0JtCYDTt80D4HMTwsZc2I7djcJ-184qS1K8tUc_iTXbujHt0HsPgf7NIJvdG0wA2T3xeP54UpFgtpiId-c_YtK_CpQTwrs5AC3v2REPfkLAOI4nuE5anXnQ4yV7MaM50i6tsVcYAB194X_ax2J-QwLmesNce1jjcIgEWW2yCjW9DLw_oLTDAdew');"></div>
<div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
<div class="absolute bottom-4 left-4 right-4">
<p class="text-white font-bold text-lg mb-2">Robo-Pasta</p>
<div class="w-full h-1.5 bg-white/30 rounded-full overflow-hidden">
<div class="h-full bg-accent-blue" style="width: 0%"></div>
</div>
</div>
</div>
</div>
</div>
<div class="flex justify-center items-center gap-2 pb-10">
<div class="w-8 h-2 rounded-full bg-accent-blue shadow-sm"></div>
<div class="w-2 h-2 rounded-full bg-gray-300"></div>
<div class="w-2 h-2 rounded-full bg-gray-300"></div>
</div>
</div>
</main>
<footer class="h-8"></footer>
</div>

</body></html>