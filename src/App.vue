<template>
  <div id="app">
    <div class="app-sidebar" :style="{transform:'translateX('+offsetX+'%)'}">
      <div v-for="item in menuItems" class="app-sidebar__item" :class="{'is-selected':item.selected}"
           @click="toggleMenuItem(item)">
        {{item.label}}
      </div>
    </div>
    <div class="l-app">
      <el-row class="l-app-header">
        <el-col :span="6" :xs="4" style="display: flex;align-items: center">
          <v-btn icon dark class="l-app-header__star">
            <i :class="{'el-icon-star-on':stared,'el-icon-star-off':!stared}" style="color: inherit"
               class="l-app-header__star"></i>
          </v-btn>
          <v-btn icon dark @click.native="showMenu" class="l-app-header__menu">
            <v-icon>menu</v-icon>
          </v-btn>
        </el-col>
        <el-col :span="12" class="l-app-header__title" :xs="22">
          ewordfun
        </el-col>
        <el-col :span="6" style="display: flex;flex-direction: row-reverse" :xs="0">
          <el-dropdown trigger="click" @command="handleUserDropdown">
            <div class="l-app-header__userInfo">
              {{username}}
              <i class="el-icon-arrow-down el-icon--right" style="margin-left: 0px"></i>
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

  export default {
    name: 'App',
    data() {
      return {
        menuItems: [],
        userValidated: false,
        userInfo: {},
        defaultActive: '',
        offsetX: 0,
        username: "",
        items: []
      }
    },
    created() {
      window.mobilecheck = function () {
        var check = false;
        (function (a) {
          if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true;
        })(navigator.userAgent || navigator.vendor || window.opera);
        return check;
      };
      this.init();
      this.$nextTick(() => {
        let goFS = document.getElementById("app");
        goFS.addEventListener("dblclick", () => {
          if (window.mobilecheck()) {
            this.toggleFullScreen();
          }
        }, false);
      });
    },
    methods: {
      toggleFullScreen() {
        let doc = window.document;
        let docEl = doc.documentElement;

        let requestFullScreen = docEl.requestFullscreen || docEl.mozRequestFullScreen || docEl.webkitRequestFullScreen || docEl.msRequestFullscreen;
        let cancelFullScreen = doc.exitFullscreen || doc.mozCancelFullScreen || doc.webkitExitFullscreen || doc.msExitFullscreen;

        if (!doc.fullscreenElement && !doc.mozFullScreenElement && !doc.webkitFullscreenElement && !doc.msFullscreenElement) {
          requestFullScreen.call(docEl);
        } else {
          cancelFullScreen.call(doc);
        }
      },
      addItem() {
        this.$refs.animList.addItem(0, Date.now());
      },
      delItem() {
        this.$refs.animList.delItem(0);
      },
      init() {
        this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
        this.menuItems = [
          {label: "最近学习", selected: false, pathName: 'latestLearn'},
          {label: "学习集", selected: false, pathName: 'userSet'},
          {label: "填字游戏", selected: false, pathName: 'puzzleGame'},
          {label: "设置", selected: false, pathName: 'setting'}
        ]
        if (this.userInfo != null) {
          this.username = this.userInfo.name;
        }
        let selectedItem = this.menuItems.find((item) => item.pathName == this.$route.name);
        selectedItem != undefined ? selectedItem.selected = true : null;
        this.defaultActive = this.$route.path == '/' ? '/latestLearn' : this.$route.path;
        this.fetchData();
      },
      showMenu() {
        this.offsetX == 0 ? this.offsetX = 100 : this.offsetX = 0;
      },
      fetchData() {

      },
      changeLocale() {
        let locale = this.$i18n.locale
        locale === 'zh' ? this.$i18n.locale = 'en' : this.$i18n.locale = 'zh'
        // LangStorage.setLang(this.$i18n.locale) //后面会用做切换和将用户习惯存储到本地浏览器
        langStorage.setLang(this.$i18n.locale) // 保存用户习惯
      },
      handleUserDropdown(command) {
        if (command == 'logout') {
          this.logout();
          return;
        }
      },
      logout() {
        this.axios.post('/api/user/logout').then((res) => {
          localStorage.removeItem('userInfo');
          this.$router.push('/login');
        })
      },
      toggleMenuItem(menuItem) {
        this.menuItems.forEach((item) => {
          item.selected = false;
        });
        menuItem.selected = true;
        this.$router.push({name: menuItem.pathName});
      }
    },
    watch: {
      // 如果路由有变化，会再次执行该方法
      '$route'(to, from) {
        if (from.path == '/login') {
          this.init();
          this.defaultActive = this.$route.path;
        }
      }
    },
  }
</script>

<style>
  @import "../ef-theme/lib/index.css";

  #app {
    width: 100%;
    height: 100%;
    background-color: rgba(211, 221, 229, 0.3);
    position: fixed;
    left: 0;
    top: 0;
    overflow: hidden;
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
