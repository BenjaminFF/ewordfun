<template>
  <div class="login-page">
    <div class="login-page__title">ewordfun</div>
    <canvas class="m-canvas" width="100%" height="100%" id="canvas"></canvas>
    <el-form ref="mForm" :model="formData" :rules="formRules">
      <el-form-item prop="email" autocomplete="on">
        <el-autocomplete
          placeholder="邮箱"
          class="inline-input"
          :fetch-suggestions="querySearch"
          :trigger-on-focus="true"
          v-model="formData.email" @keyup.enter.native="submitForm('mForm')">
        </el-autocomplete>
      </el-form-item>
      <el-form-item prop="password">
        <el-input type="password" v-model="formData.password" placeholder="密码" @keyup.enter.native="submitForm('mForm')"></el-input>
      </el-form-item>
      <el-form-item label="验证码" prop="captcha" v-if="showCaptcha">
        <el-input v-model="formData.captcha"></el-input>
        <div v-html="captchaData"></div>
      </el-form-item>
      <el-form-item>
        <el-button style="width:100%" @click="submitForm('mForm')" :loading="isValidating" type="primary">登陆</el-button>
      </el-form-item>
      <div style="width: 100%;display: flex;justify-content: space-between">
        <el-button type="text" @click="pushRouter('/forget-pw')">忘记密码？</el-button>
        <el-button type="text" @click="pushRouter('/register')">注册</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: "login-page",
    data() {
      return {
        formRules: [],
        formData: {},
        captchaData: "",
        showCaptcha: false,
        isValidating: false,
        suggestEmails: [],
      }
    },
    created() {
      this.init();
      this.initCanvas();
    },
    mounted() {

    },
    methods: {
      initCanvas() {
        this.$nextTick(() => {
          let canvas = document.getElementById("canvas");
          canvas.width=canvas.offsetWidth;
          canvas.height=canvas.offsetHeight;
          let ctx = canvas.getContext("2d");
          ctx.lineWidth =0.05;
          ctx.clearRect(0,0,canvas.width,canvas.height);
          let grid_cols = 100;
          let grid_rows = 100;
          let cell_width=35;
          ctx.beginPath();
          for (let row = 0; row <= grid_rows; row++) {
            let y = row * cell_width;
            ctx.moveTo(0, y);
            ctx.lineTo(canvas.width, y);
          }
          for (let col = 0; col <= grid_cols; col++) {
            let x = col * cell_width;
            ctx.moveTo(x, 0);
            ctx.lineTo(x, canvas.height);
          }
          ctx.stroke();
        })
      },
      init() {
        this.formRules = {
          email: [
            {required: true, message: '请输入邮箱地址'},
            {type: 'email', message: '请输入正确的邮箱地址'}
          ],
          password: [
            {required: true, message: '密码不能为空'},
            {min: 6, max: 32, message: '密码长度在 6 到 32 个字符'}
          ],
          captcha: [
            {required: true, message: '请输入验证码', trigger: 'blur'},
            {min: 6, max: 6, message: '请输入正确的验证码', trigger: 'blur'}
          ]
        }
        this.formData = {
          email: "",
          password: "",
          captcha: ""
        }
        if (localStorage.getItem("suggestEmails") != undefined) {
          this.suggestEmails = JSON.parse(localStorage.getItem("suggestEmails"));
        }
      },
      querySearch(queryString, cb) {
        let data = [];
        this.suggestEmails.forEach((email) => {
          data.push({
            value: email
          })
        })
        cb(data);
      },
      submitForm(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.isValidating = true;
            this.validatePass();
          } else {
            console.log('error submit!!');
            return false;
          }
        });
      },
      validatePass() {
        this.axios.post('/api/user/login', {
          email: this.formData.email,
          password: this.formData.password
        }).then((res) => {
          this.isValidating = false;
          if (res.data.validated) {
            let userInfo = {
              name: res.data.name,
              email: res.data.email,
              loginTime: Date.now()
            }
            let suggestEmails = [];
            if (localStorage.getItem("suggestEmails") != undefined) {
              suggestEmails = JSON.parse(localStorage.getItem("suggestEmails"));
              if (suggestEmails.find((email) => email == userInfo.email) == undefined) {
                suggestEmails.unshift(userInfo.email);
              }
            } else {
              suggestEmails.unshift(userInfo.email);
            }
            localStorage.setItem("suggestEmails", JSON.stringify(suggestEmails.slice(0, 4)));
            localStorage.setItem('userInfo', JSON.stringify(userInfo));
            this.$router.push('/userSet');
          } else {
            this.$message({
              message: '邮箱或密码错误',
              type: 'warning'
            });
          }
        });
      },
      pushRouter(routerName){
        this.$router.push(routerName);
      }
    }
  }
</script>

<style scoped>
  .m-canvas {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: white;
    z-index: -1;
  }
</style>
