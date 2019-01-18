// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.

import App from './App'
import router from './router'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VueI18n from 'vue-i18n'
import langStorage from './lang'

Vue.use(VueAxios, axios)

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
  i18n: new VueI18n({
    // locale: LangStorage.getLang('zh'),          // 语言标识，后面会用做切换和将用户习惯存储到本地浏览器
    locale: langStorage.getLang('en'),   // 语言标识
    messages: {
      'zh': require('./assets/lang/zh'),
      'en': require('./assets/lang/en')
    }
  }),
})
