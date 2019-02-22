<template>
  <div id="app">
    <div class="mSidebar" :style="{transform:'translateX('+offsetX+'rem)'}">dfasdf</div>
    <div class="container" :style="{transform:'translateX('+offsetX+'rem)'}">
      <el-row class="main-header">
        <el-col :span="2" @click.native="showMenu" style="cursor: pointer">
          <i class="el-icon-menu" style="margin-left: 1rem" ></i>
          menu
        </el-col>
      </el-row>
      <div class="main-content">
        <router-view></router-view>
      </div>
    </div>
  </div>
</template>

<script>
  import langStorage from './lang'
  export default {
    name: 'App',
    data() {
      return {
        menuItems: [],
        userValidated: false,
        userInfo: {},
        defaultActive:'',
        offsetX:0,
        offsetX2:-20
      }
    },
    created() {
      this.init();
    },
    methods: {
      init() {
        this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
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
  }

  .container{
    width: 100%;
    height: 100%;
    overflow: hidden;
    transition: all .6s ease-in-out;
    position: absolute;
    left: 0;
    top: 0;
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

  .main-header {
    width: 100%;
    height: 5rem;
    display: flex;
    align-items: center;
    background-color: white;
    box-shadow: 20px 0px 30px 0px rgba(0, 0, 0, 0.11);
  }

  .app-main-header-input {
    font-size: 2rem;
    display: flex;
    justify-content: center;
    padding: 2rem;
    align-items: center;
    height: 100%;
    box-sizing: border-box;
  }

  .app-main-header-input .el-input__inner {
    border: none !important;
  }

  .main-content {
    width: 100%;
    height: 90%;
  }

  .sidebar {
    height: 100%;
    box-shadow: 0px 0px 30px rgba(0, 0, 0, 0.11);
    background-color: #334150;
  }

  .sidebar-header {
    width: 100%;
    height: 10%;
    box-sizing: border-box;
    display: flex;
    align-items: center;
    font-size: 2rem;
    color: white;
    padding-left: 2rem;
  }

  .sidebar-menu {
    width: 100%;
    height: 80%;
  }

  .sidebar-footer {
    width: 100%;
    height: 10%;
  }

  .el-menu {
    background-color: transparent;
    border-right-width: 0px;
  }

  .el-menu-item{
    font-size: 1rem;
    height: 4rem;
    transition: none;
    color: #dedfe7;
    padding-left: 2rem !important;
  }

  .el-menu-item i{
    color: #dedfe7;
  }

  .el-menu-item:hover {
    color: #42b983 !important;
    background-color: rgba(0, 0, 0, 0.2) !important;
  }

  .el-menu-item.is-active {
    color: #42b983 !important;
    border-right: 5px solid #42b983;
    background-color: rgba(0, 0, 0, 0.2) !important;
  }

</style>
