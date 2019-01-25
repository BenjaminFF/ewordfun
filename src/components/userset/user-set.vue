<template>
  <div class="user-set">
    <div class="control-bar"></div>
    <el-scrollbar class="list user-set-scrollbar">
      <el-row class="list-item" v-for="set in sets">
        <el-col :span="2" style="display: flex;justify-content: center;align-items: center">
          <div class="degree"></div>
        </el-col>
        <el-col :span="20" style="height: 100%">
          <div class="name">dasfasfadsf</div>
          <div class="intro">adsfasfdfas</div>
        </el-col>
        <el-col :span="2" style="display: flex;justify-content: center;font-size: 1.5rem">
          <i class="el-icon-star-off" style="margin-right: 1rem"></i>
          <i class="el-icon-more"></i>
        </el-col>
      </el-row>
    </el-scrollbar>
  </div>
</template>

<script>
  export default {
    name: "user-set",
    data(){
      return{
        sets:[]
      }
    },
    created() {
      this.init();
    },
    methods:{
      init(){
        this.fetchData();
      },
      fetchData(){
        this.sets=[1,2,3,4,5,6,7,8];
        console.log(this.axios.get('/api/set/acquire'));
        this.axios.get('/api/set/acquire').then((res)=>{

        });
      }
    }
  }
</script>

<style scoped>
  .user-set {
    width: 100%;
    height: 100%;
    background-color: lightgrey;
  }

  .control-bar {
    width: 100%;
    height: 20%;
  }

  .list {
    width: 100%;
    height: 75%;
  }

  .list-item{
    width: 100%;
    height: 6rem;
    margin-bottom: 2rem;
    background-color: white;
    display: flex;
    align-items: center;
  }

  .degree{
    width: 4.5rem;
    height: 4.5rem;
    background-color: #42b983;
    border-radius: 4.5rem;
  }

  .name{
    margin-top: 1rem;
    font-size: 1.8rem;
  }
  .intro{
    font-size: 1rem;
    margin-top: 0.5rem;
  }
</style>

<style>
  .user-set-scrollbar .el-scrollbar__wrap{
    overflow-x: hidden;
    padding-bottom: 10rem;
    padding-left: 5%;
    padding-right: 5%;
  }
</style>
