import { createRouter, createWebHashHistory } from 'vue-router'
// import LoginView from '../views/LoginView.vue'
import HomeView from '../views/HomeView.vue'
import Welcome from '../views/WelcomeView.vue'

import Userlist from '../views/user/UserList.vue'

import VisualPage from '../views/visuals/VisualPageView.vue'
import VisualBook from '../views/visuals/VisualBookView.vue'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: () => import('@/views/LoginView.vue') },
  {
    path: '/home',
    component: HomeView,
    redirect: '/welcome',
    children: [
      { path: '/welcome', component: Welcome },
      { path: '/userlist', component: Userlist },
      { path: '/visualPage', component: VisualPage },
      { path: '/visualBook', component: VisualBook }
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
