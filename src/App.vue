<template>
  <div id="app">
    <div class="mSidebar" :style="{transform:'translateX('+offsetX+'rem)'}">dfasdf</div>
    <div class="l-app" :style="{transform:'translateX('+offsetX+'rem)'}">
      <el-row class="l-app-header">
        <el-col :span="4" @click.native="showMenu">
          <v-btn icon dark>
            <v-icon medium class="l-app-header__menu">menu</v-icon>
          </v-btn>
        </el-col>
        <el-col :span="16" class="l-app-header__title">
          ewordfun
        </el-col>
        <el-col :span="4" style="display: flex;flex-direction: row-reverse">
          <el-dropdown trigger="click" @command="handleUserDropdown">
            <div class="l-app-header__userInfo">
              {{username}}
              <i class="el-icon-arrow-down el-icon--right"></i>
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="logout">退出</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </el-col>
      </el-row>
      <div class="l-app__main-content">
        <router-view></router-view>
      </div>
    </div>
  </div>
</template>

<script>
  import langStorage from './lang'
  import AnimList from './components/anim-list'
  export default {
    name: 'App',
    components: {AnimList},
    data() {
      return {
        menuItems: [],
        userValidated: false,
        userInfo: {},
        defaultActive:'',
        offsetX:0,
        offsetX2:-20,
        username:"",
        items:[]
      }
    },
    created() {
      this.init();
    },
    methods: {
      addItem(){
        this.$refs.animList.addItem(0,Date.now());
      },
      delItem(){
        this.$refs.animList.delItem(0);
      },
      init() {
        this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
        if(this.userInfo!=null){
          this.username=this.userInfo.name;
        }
        this.defaultActive=this.$route.path=='/'?'/latestLearn':this.$route.path;
        this.fetchData();
      },
      showMenu(){
        if(this.offsetX==0){
          this.offsetX=20;
          this.offsetX2=20;
        }else {
          this.offsetX=0;
          this.offsetX2=0;
        }
      },
      fetchData() {

      },
      changeLocale() {
        let locale = this.$i18n.locale
        locale === 'zh' ? this.$i18n.locale = 'en' : this.$i18n.locale = 'zh'
        // LangStorage.setLang(this.$i18n.locale) //后面会用做切换和将用户习惯存储到本地浏览器
        langStorage.setLang(this.$i18n.locale) // 保存用户习惯
      },
      openCreateSet() {
        this.$router.push('/createSet');
      },
      handleUserDropdown(command){
        if(command=='logout'){
          this.logout();
          return;
        }
      },
      logout() {
        this.axios.post('/api/user/logout').then((res) => {
          localStorage.removeItem('userInfo');
          this.$router.push('/login');
        })
      }
    },
    watch: {
      // 如果路由有变化，会再次执行该方法
      '$route'(to, from) {
        if (from.path == '/login') {
          this.init();
          this.defaultActive=this.$route.path;
        }
      }
    },
  }
</script>

<style>
  @import "../ef-theme/lib/index.css";
  @import "../node_modules/animate.css/animate.css";

  #app {
    width: 100%;
    height: 100%;
    background-color: rgba(211, 221, 229, 0.3);
    position: fixed;
    left: 0;
    top: 0;
    overflow: hidden;
  }
  .mSidebar{
    width: 20rem;
    height: 100%;
    background-color: black;
    position: absolute;
    left: -20rem;
    top: 0;
    transition: all .6s ease-in-out;
  }

  .mm-fab {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    vertical-align: middle;
    box-shadow: none !important;
    z-index: 1;
  }

  .mm-fab i {
    width: 100% !important;
    height: 100% !important;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    vertical-align: middle;
  }
</style>
