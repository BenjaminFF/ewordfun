<template>
  <el-row id="app">
    <el-col class="sidebar" :span="4">
      <div class="sidebar-header"></div>
      <div class="sidebar-menu">
        <el-menu
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
        <el-col :span="16" class="app-main-header-input">
          <i class="el-icon-search"></i>
          <el-input :placeholder="$t('appHeader.search')" style="font-size: 2rem"></el-input>
        </el-col>
        <el-col :span="2" style="height: 100%;display: flex;align-items: center;justify-content: center">
          <el-button @click="openCreateSet">{{$t('appHeader.createSet')}}</el-button>
        </el-col>
        <el-col :span="2" style="font-size: 1.5rem;display: flex;justify-content: space-around">
          <i class="el-icon-message"></i>
          <i class="el-icon-bell"></i>
        </el-col>
        <el-col :span="4">
          <div class="user-info">
            <div class="user-info-img"></div>
            <span class="user-info-name">
              tony
              <i class="el-icon-caret-bottom"></i>
            </span>
          </div>
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
        menuItems: []
      }
    },
    created() {
      this.init();
    },
    methods: {
      init() {
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
      openCreateSet(){
        this.$router.push('/createSet');
      }
    }
  }
</script>

<style>
  @import "../ef-theme/lib/index.css";
  @import "../node_modules/animate.css/animate.css";
  body, html {
    width: 100%;
    height: 100%;
  }

  body, html, div {
    padding: 0;
    margin: 0;
  }

  #app {
    width: 100%;
    height: 100%;
  }

  .sidebar {
    height: 100%;
  }

  .main {
    height: 100%;
  }

  .main-header{
    width: 100%;
    height: 10%;
    display: flex;
    align-items: center;
  }

  .app-main-header-input{
    font-size: 2rem;
    display: flex;
    justify-content: center;
    padding: 2rem;
    align-items: center;
    height: 100%;
    box-sizing: border-box;
  }

  .app-main-header-input .el-input__inner{
    border: none !important;
  }

  .user-info{
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    user-select: none;
  }

  .user-info-img{
    width: 3rem;
    height: 3rem;
    border-radius: 3rem;
    background-color: #42b983;

  }

  .user-info-name{
    cursor: pointer;
    margin-left: 1rem;
  }

  .main-content{
    width: 100%;
    height: 90%;
    background-color: #42b983;
  }

  .sidebar-header {
    width: 100%;
    height: 10%;
    background-color: #2c3e50;
  }

  .sidebar-menu {
    width: 100%;
    height: 80%;
    background-color: darkcyan;
  }

  .sidebar-footer {
    width: 100%;
    height: 10%;
    background-color: lightcoral;
  }

  .el-menu{
    background-color: transparent;
    border-right-width: 0px;
  }

</style>
