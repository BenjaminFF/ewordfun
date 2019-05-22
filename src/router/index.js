import Vue from 'vue'
import Router from 'vue-router'
import loginPage from '@/components/user/login-page'
import forgetpwPage from '@/components/user/forgetpw-page'
import registerPage from '@/components/user/register-page'
import createSet from '@/components/userset/create-set'
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
      name: 'index',
      component: loginPage
    },
    {
      path: '/login',
      name: 'login',
      component: loginPage
    },
    {
      path: '/forget-pw',
      name: 'forget-pw',
      component: forgetpwPage
    },
    {
      path: '/register',
      name: 'register',
      component: registerPage
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
      path: '/createPuzzle/:uid/:sid',
      name: 'createPuzzle',
      component: createPuzzle
    },
    {
      path: '/playPuzzle/:uid/:sid/:pid',
      name: 'playPuzzle',
      component: playPuzzle
    },
    {
      path: '/puzzleList/:uid/:sid',
      name: 'puzzleList',
      component: puzzleList
    }
  ]
});

router.beforeEach((to, from, next) => {
  console.log(to.path);
  let userInfo = localStorage.getItem('userInfo');
  let notLoginPaths = ['/login', '/forget-pw','/register','/'];
  if (userInfo != null) {
    if (Date.now() - JSON.parse(userInfo).loginTime <= 24 * 3600 * 1000 * 15) {
      if (notLoginPaths.includes(to.path)) {
        next({path: '/latestLearn'});
      } else {
        next({path: null});
      }
    } else {
      localStorage.removeItem('userInfo');
      if (notLoginPaths.includes(to.path)) {
        next({path: null});
      } else {
        next({path: '/login'});
      }
    }
  } else {
    if (notLoginPaths.includes(to.path)) {
      next({path: null});
    } else {
      next({path: '/login'});
    }
  }
});

export default router;
