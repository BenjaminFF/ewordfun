<template>
  <div class="user-set">
    <el-row class="control-bar">
      <el-col :span="12" style="display: flex;align-items: center">
        <div style="margin-right: 1rem">Sort By</div>
        <el-select v-model="curSortOption" placeholder="请选择">
          <el-option
            v-for="item in sortOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
        <i class="el-icon-star-off" style="font-size: 1.5rem;margin-left: 1rem"></i>
      </el-col>
      <el-col :span="12" style="display: flex;justify-content: flex-end">
        <el-select v-model="curFolder">
          <el-option
            v-for="item in folders"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-col>
    </el-row>
    <el-scrollbar class="list user-set-scrollbar">
      <el-row class="list-item" v-for="set in sets">
        <el-col :span="2" style="display: flex;justify-content: center;align-items: center">
          <div class="degree"></div>
        </el-col>
        <el-col :span="20" style="height: 100%">
          <div class="name">{{set.name}}</div>
          <div class="intro">{{set.intro}}</div>
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
        sets:[],
        sortOptions:[],
        curSortOption:"",
        folders:[],
        curFolder:""
      }
    },
    created() {
      this.init();
    },
    methods:{
      init(){
        this.fetchData();
        this.sortOptions=[
          {value:'time',label:'time'},
          {value:'proficiency',label:'proficiency'},
          {value:'termCount',label:'termCount'}
        ]
      },
      async fetchData(){
        await this.axios.get('/api/set/list_of_author').then((res)=>{
          this.sets=res.data;
        });
        await this.axios.get('/api/folder/list').then((res)=>{
          res.data.forEach((folder)=>{
            this.folders.push({
              label:folder.name,
              value:folder.fid
            })
          });
        });
      }
    }
  }
</script>

<style scoped>
  .user-set {
    width: 100%;
    height: 100%;
  }

  .control-bar {
    width: 90%;
    height: 20%;
    margin-left: 5%;
    display: flex;
    align-items: center;
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
