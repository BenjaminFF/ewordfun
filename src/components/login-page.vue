<template>
    <div class="login-page">
      <el-form ref="mForm" :model="formData" label-width="80px" :rules="formRules">
        <el-form-item label="邮箱" prop="email" autocomplete="on">
          <el-autocomplete
            class="inline-input"
            :fetch-suggestions="querySearch"
            :trigger-on-focus="false"
            v-model="formData.email">
          </el-autocomplete>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="formData.password"></el-input>
        </el-form-item>
        <el-form-item label="验证码" prop="captcha" v-if="showCaptcha">
          <el-input v-model="formData.captcha"></el-input>
          <div v-html="captchaData"></div>
        </el-form-item>
        <el-form-item>
          <el-button style="width:100%" @click="submitForm('mForm')" :loading="isValidating">登陆</el-button>
        </el-form-item>
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
          captchaData:"",
          showCaptcha:false,
          isValidating:false,
          suggestEmails:[]
        }
      },
      created() {
        this.init();
      },
      methods: {
        init() {
          this.formRules = {
            email: [
              {required: true, message: '请输入邮箱地址', trigger: 'blur'},
              {type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change']}
            ],
            password: [
              {required: true, message: '密码不能为空', trigger: 'blur'},
              {min: 6, max: 32, message: '密码长度在 6 到 32 个字符', trigger: 'blur'}
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
          if(localStorage.getItem("suggestEmails")!=undefined){
            this.suggestEmails=JSON.parse(localStorage.getItem("suggestEmails"));
          }
          console.log(this.suggestEmails);
          this.fetchData();
        },
        fetchData(){

        },
        querySearch(queryString, cb) {
          let data=[];
          this.suggestEmails.forEach((email)=>{
            data.push({
              value:email
            })
          })
          cb(data);
        },
        submitForm(formName) {
          this.$refs[formName].validate((valid) => {
            if (valid) {
              this.isValidating=true;
              this.validatePass();
            } else {
              console.log('error submit!!');
              return false;
            }
          });
        },
        validatePass(){
          this.axios.post('/api/user/login',{email:this.formData.email,password:this.formData.password}).then((res)=>{
            this.isValidating=false;
            if(res.data.validated){
              let userInfo= {
                name: res.data.name,
                email: res.data.email,
                loginTime: Date.now()
              }
              let suggestEmails=[];
              if(localStorage.getItem("suggestEmails")!=undefined){
                suggestEmails=JSON.parse(localStorage.getItem("suggestEmails"));
                suggestEmails.unshift(userInfo.email);
              }else {
                suggestEmails.unshift(userInfo.email);
              }
              localStorage.setItem("suggestEmails",JSON.stringify(suggestEmails.slice(0,4)));
              localStorage.setItem('userInfo',JSON.stringify(userInfo));
              this.$router.push('/userSet');
            }else {
              this.$message({
                message: '密码错误',
                type: 'warning'
              });
            }
          });
        }
      }
    }
</script>

<style scoped>
  .login-page{
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
