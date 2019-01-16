<template>
  <div class="create-set">
    <div class="list-container">
      <ef-list ref="EfList" :list="list" :wrap-height="'100%'" style="width: 100%;">
        <div class="el-item-container" v-for="(n,index) in list" :key="n">
          <div class="main"></div>
          <el-button type="danger" icon="el-icon-plus" circle class="add"></el-button>
        </div>
      </ef-list>
    </div>
  </div>
</template>

<script>
  import EfList from "./ef-list/list";

  export default {
    name: "create-set",
    components: {EfList},
    data() {
      return {
        list: [1, 2, 3, 4, 5, 6, 7, 9, 10],
      }
    }
  }
</script>

<style scoped>
  .create-set {
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    background-color: white;
    z-index: 1000;
  }

  .list-container {
    width: 100%;
    display: flex;
    justify-content: center;
    height: 100%;
  }

  .el-item-container {
    width: 100%;
    height: 10rem;
    border-radius: 4px;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    flex-direction: column;
  }
  .main{
    width: 80%;
    min-width: 20rem;
    height: 80%;
    background-color: #2c3e50;
    border-radius: 1rem;
    box-shadow: 0px 0px 30px 0px rgba(0, 0, 0, 0.16);
  }
  .add{
    font-size: 1.2rem;
  }
</style>
