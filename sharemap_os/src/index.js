import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: () => import('./components/LoginView.vue') },
  {
    path: '/home',
    component: () => import('./components/HomeView.vue'),
    redirect: '/welcome',
    children: [
      { path: '/welcome', component: () => import('./components/WelcomeView.vue') },
      { path: '/userlist', component: () => import('./components/UserList.vue') },
      { path: '/visual', component: () => import('./components/visuals/VisualView.vue') },
      { path: '/visualPage', component: () => import('./components/visuals/VisualPageView.vue') },
      { path: '/visualBook', component: () => import('./components/visuals/VisualBookView.vue') }
    ]
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// router guide
router.beforeEach((to, from, next) => {
  if (to.path === '/login') return next()
  const tokenStr = window.sessionStorage.getItem('token')
  if (!tokenStr) return next('/login')
  // valid token?
  next()
})
export default router
