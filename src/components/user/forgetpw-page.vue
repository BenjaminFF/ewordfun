<template>
  <div class="forgetpw-page">
    <div class="forgetpw-page__title">ewordfun</div>
    <canvas class="m-canvas" width="100%" height="100%" id="canvas">
    </canvas>
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
      <el-form-item>
        <el-button style="width:100%" @click="submitForm('mForm')" :loading="isValidating" type="primary">重置密码
        </el-button>
      </el-form-item>
      <div style="width: 100%;display: flex;justify-content: space-between">
        <el-button type="text" @click="pushRouter('/login')">登录</el-button>
        <el-button type="text" @click="pushRouter('/register')">注册</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: "",
    data() {
      return {
        isValidating: false,
        formRules: [],
        formData: {},
        suggestEmails: []
      }
    },
    created() {
      this.init();
      this.initCanvas();
    },
    methods: {
      init() {
        this.formRules = {
          email: [
            {required: true, message: '请输入邮箱地址'},
            {type: 'email', message: '请输入正确的邮箱地址'}
          ]
        }
        this.formData = {
          email: "",
        }
        if (localStorage.getItem("suggestEmails") != undefined) {
          this.suggestEmails = JSON.parse(localStorage.getItem("suggestEmails"));
        }
      },
      initCanvas() {
        this.$nextTick(() => {
          let canvas = document.getElementById("canvas");
          canvas.width = canvas.offsetWidth;
          canvas.height = canvas.offsetHeight;
          let ctx = canvas.getContext("2d");
          ctx.lineWidth = 0.05;
          ctx.clearRect(0, 0, canvas.width, canvas.height);
          let grid_cols = 60;
          let grid_rows = 60;
          let cell_width = 35;
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
      fetchData() {

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
            this.sendPWChangeMail();
          } else {
            console.log('error submit!!');
            return false;
          }
        });
      },
      sendPWChangeMail() {
        this.axios.post('/api/user/sendPWChangeMail', {
          email: this.formData.email
        }).then((res) => {
          if (res.data.code == 1) {
            this.$message({
              message: "邮件发送失败，请查收邮件",
              type: 'success',
              duration: 5000
            });
          } else if (res.data.code == -1) {
            this.$message({
              message: "邮箱未注册，请先注册！",
              type: 'success',
            });
          } else {
            this.$message({
              message: "邮件发送失败，请重试！",
              type: 'success',
            });
          }
          this.isValidating = false;
        });
      },
      pushRouter(routerName) {
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
