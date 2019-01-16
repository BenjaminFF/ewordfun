import Vue from 'vue'
import Router from 'vue-router'
import createSet from '@/components/create-set'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'index',
      component: createSet
    },
  ]
})
