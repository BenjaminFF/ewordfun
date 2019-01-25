import Vue from 'vue'
import Router from 'vue-router'
import createSet from '@/components/create-set'
import latestLearn from '@/components/latestlearn/latest-learn'
import userSet from '@/components/userset/user-set'
import helpCenter from '@/components/helpcenter/help-center'
import setting from '@/components/setting/setting'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'index',
      component: latestLearn
    },
    {
      path: '/latestLearn',
      name: 'latestLearn',
      component: latestLearn
    },
    {
      path: '/userSet',
      name: 'userSet',
      component: userSet
    },
    {
      path: '/helpCenter',
      name: 'helpCenter',
      component: helpCenter
    },
    {
      path: '/setting',
      name: 'setting',
      component: setting
    },
    {
      path: '/createSet',
      name: 'createSet',
      component: createSet
    }
  ]
})
