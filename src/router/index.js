import Vue from 'vue'
import Router from 'vue-router'
import loginPage from '@/components/login-page'
import createSet from '@/components/create-set'
import latestLearn from '@/components/latestlearn/latest-learn'
import userSet from '@/components/userset/user-set'
import helpCenter from '@/components/helpcenter/help-center'
import setting from '@/components/setting/setting'
import setLearn from '@/components/setlearn/set-learn'
import matrixLearn from '@/components/setlearn/matrix-learn'
import createPuzzle from '@/components/puzzlelearn/create-puzzle'
import playPuzzle from '@/components/puzzlelearn/play-puzzle'
import puzzleList from '@/components/puzzlelearn/puzzle-list'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'userSet',
      component: userSet
    },
    {
      path: '/login',
      name: 'login',
      component: loginPage
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
    },
    {
      path: '/setLearn/:uid/:sid',
      name: 'setLearn',
      component: setLearn
    },
    {
      path: '/matrixLearn/:uid/:sid',
      name: 'matrixLearn',
      component: matrixLearn
    },
    {
      path:'/createPuzzle/:uid/:sid',
      name:'createPuzzle',
      component:createPuzzle
    },
    {
      path:'/playPuzzle/:uid/:sid/:pid',
      name:'playPuzzle',
      component:playPuzzle
    },
    {
      path:'/puzzleList/:uid/:sid',
      name:'puzzleList',
      component:puzzleList
    }
  ]
});

router.beforeEach((to, from, next) => {
  let userInfo=localStorage.getItem('userInfo');
  if(userInfo!=null){
    if(Date.now()-JSON.parse(userInfo).loginTime<=24*3600*1000*15){
      next({path:to.path=='/login'?'/latestLearn':null});
    }else {
      localStorage.removeItem('userInfo');
      next({path:to.path=='/login'?null:'/login'});
    }
  }else {
    next({path:to.path=='/login'?null:'/login'});
  }
});

export default router;
