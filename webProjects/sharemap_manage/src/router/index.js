import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: () => import('@/views/LoginView.vue') },
  {
    path: '/home',
    component: () => import('@/views/HomeView.vue'),
    redirect: '/welcome',
    children: [
      { path: '/welcome', component: () => import('@/views/WelcomeView.vue') },
      { path: '/userlist', component: () => import('@/views/user/UserList.vue') },
      { path: '/visual', component: () => import('@/views/visuals/VisualView.vue') },
      { path: '/visualPage', component: () => import('@/views/visuals/VisualPageView.vue') },
      { path: '/visualBook', component: () => import('@/views/visuals/VisualBookView.vue') }
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
