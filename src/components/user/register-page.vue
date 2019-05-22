<template>
  <div class="register-page">
    <div class="register-page__title">ewordfun</div>
    <canvas class="m-canvas" width="100%" height="100%" id="canvas"></canvas>
    <el-form ref="mForm" :model="formData" :rules="formRules">
      <el-form-item prop="email">
        <el-input placeholder="邮箱" v-model="formData.email" @keyup.enter.native="submitForm('mForm')">
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input type="password" v-model="formData.password" placeholder="密码" @keyup.enter.native="submitForm('mForm')"></el-input>
      </el-form-item>
      <el-form-item prop="name">
        <el-input v-model="formData.name" placeholder="名字" @keyup.enter.native="submitForm('mForm')"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button style="width:100%" @click="submitForm('mForm')" :loading="isValidating" type="primary">注册</el-button>
      </el-form-item>
      <div style="width: 100%;display: flex;justify-content: space-between">
        <el-button type="text" @click="pushRouter('/login')">登录</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: "",
    data() {
      return {
        formRules: [],
        formData: {},
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
          ],
          password: [
            {required: true, message: '密码不能为空'},
            {min: 6, max: 32, message: '密码长度在 6 到 32 个字符'}
          ],
          name: [
            {required: true, message: '请输入名字'},
            {min: 2, max: 10, message: '密码长度在 2 到 10 个字符'}
          ]
        }
        this.formData = {
          email: "",
          password: "",
          name: ""
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
      submitForm(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.isValidating = true;
          } else {
            console.log('error submit!!');
            return false;
          }
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
  .register-page{
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    z-index: 1000;
  }
</style>
