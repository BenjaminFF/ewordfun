<template>
  <el-row id="app">
    <el-col class="sidebar" :span="4">
      <div class="sidebar-header">
      </div>
      <div class="sidebar-menu">
        <el-menu
          background-color="transparent"
          router="true"
          default-active="2">
          <el-menu-item index="/latestLearn">
            <i class="el-icon-menu"></i>
            <span slot="title">{{$t('sidebar.latestLearn')}}</span>
          </el-menu-item>
          <el-menu-item index="/userSet">
            <i class="el-icon-menu"></i>
            <span slot="title">{{$t('sidebar.yourSet')}}</span>
          </el-menu-item>
          <el-menu-item index="/helpCenter">
            <i class="el-icon-menu"></i>
            <span slot="title">{{$t('sidebar.helpCenter')}}</span>
          </el-menu-item>
          <el-menu-item index="/setting">
            <i class="el-icon-menu"></i>
            <span slot="title">{{$t('sidebar.setting')}}</span>
          </el-menu-item>
        </el-menu>
      </div>
      <div class="sidebar-footer"></div>
    </el-col>
    <el-col class="main" :span="20">
      <el-row class="main-header">
        <el-col :span="15" class="app-main-header-input">
          <i class="el-icon-search"></i>
          <el-input :placeholder="$t('appHeader.search')" style="font-size: 2rem"></el-input>
        </el-col>
        <el-col :span="9" style="display: flex;align-items: center">
          <div @click="openCreateSet" style="background-color: #42b983;text-align: center;
          padding: 0.8rem 1.2rem;border-radius: 5px;box-shadow: 0px 0px 30px 0px rgba(66,185,131,0.21);color: white;cursor: pointer;user-select: none;min-width: 5rem;width: 5rem">
            {{$t('appHeader.createSet')}}
          </div>
          <div style="width: 6rem;height: 3rem;text-align: center;line-height: 3rem;border-left: 1px solid #dadada;margin-left: 2rem;border-right: 1px solid #dadada">
            <i class="el-icon-search" style="font-size: 1.5rem"></i>
          </div>
          <div style="width: 6rem;height: 3rem;text-align: center;line-height: 3rem;border-right: 1px solid #dadada">
            <el-badge :value="12">
              <i class="el-icon-search" style="font-size: 1.5rem"></i>
            </el-badge>
          </div>
          <div style="width: 3rem;height: 3rem;border-radius: 4rem;background-color: #42b983;margin-left: 2rem">
          </div>
          <el-dropdown style="margin-left: 2rem;cursor: pointer;user-select: none;outline: none" trigger="click">
            <span style="font-size: 1.2rem">
              {{userInfo!=null?userInfo.name:'????/'}}
              <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item>黄金糕</el-dropdown-item>
              <el-dropdown-item>狮子头</el-dropdown-item>
              <el-dropdown-item>螺蛳粉</el-dropdown-item>
              <el-dropdown-item>双皮奶</el-dropdown-item>
              <el-dropdown-item>蚵仔煎</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </el-col>
      </el-row>
      <div class="main-content">
        <router-view></router-view>
      </div>
    </el-col>
  </el-row>
</template>

<script>
  import langStorage from './lang'

  export default {
    name: 'App',
    data() {
      return {
        menuItems: [],
        userValidated: false,
        userInfo: {}
      }
    },
    created() {
      this.init();
    },
    methods: {
      init() {
        this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
        this.fetchData();
      },
      fetchData() {

      },
      changeLocale() {
        let locale = this.$i18n.locale
        locale === 'zh' ? this.$i18n.locale = 'en' : this.$i18n.locale = 'zh'
        // LangStorage.setLang(this.$i18n.locale) //后面会用做切换和将用户习惯存储到本地浏览器
        langStorage.setLang(this.$i18n.locale) // 保存用户习惯
        console.log("change locale")
      },
      openCreateSet() {
        this.$router.push('/createSet');
      },
      logout() {
        this.axios.post('/api/user/logout').then((res) => {
          console.log(res.data);
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
    background-color: rgba(225, 235, 243, 0.3);
  }

  .main {
    height: 100%;
  }

  .main-header {
    width: 100%;
    height: 10%;
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
