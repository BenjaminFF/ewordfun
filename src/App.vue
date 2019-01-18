<template>
  <el-row id="app">
    <el-col class="sidebar" :span="4">
      <div class="sidebar-header"></div>
      <div class="sidebar-menu">
        <div>{{$t('sidebar.latestLearning')}}</div>
        <div>{{$t('sidebar.yourSet')}}</div>
      </div>
      <div class="sidebar-footer"></div>
    </el-col>
    <el-col class="main" :span="20">
      <router-view></router-view>
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
    background-color: #17bfc8;
    height: 100%;
  }

  .sidebar-header {
    width: 100%;
    height: 20%;
    background-color: #2c3e50;
  }

  .sidebar-menu {
    width: 100%;
    height: 70%;
    background-color: darkcyan;
  }

  .sidebar-footer {
    width: 100%;
    height: 10%;
    background-color: lightcoral;
  }

</style>
