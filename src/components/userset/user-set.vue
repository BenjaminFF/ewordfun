<template>
  <div class="user-set">
    <el-row class="control-bar">
      <el-col :span="12" style="display: flex;align-items: center">
        <div style="margin-right: 1rem">Sort By</div>
        <el-select v-model="curSortOption" placeholder="请选择" @change="onSortChange()">
          <el-option
            v-for="item in sortOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
        <i class="el-icon-star-off" style="font-size: 1.5rem;margin-left: 1rem"></i>
      </el-col>
      <el-col :span="12" style="display: flex;justify-content: flex-end;align-items: center">
        <div style="margin-right: 1rem">Folder</div>
        <el-select v-model="curFolderId" clearable @change="onFolderChange()">
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
      <el-row v-for="set in curSets" @click.native="openItem(set.id)">
        <div style="width: 100%;height: fit-content">
          <div style="margin-bottom: 2rem;font-size: 1.5rem" v-if="set.isDateVisible">
            {{curSortOption=='createtime'?dateFormat(set.createtime):dateFormat(set.latest_learntime)}}
          </div>
          <div class="list-item">
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
          </div>
        </div>
      </el-row>
    </el-scrollbar>
  </div>
</template>

<script>
  export default {
    name: "user-set",
    data() {
      return {
        sets: [],
        sortOptions: [],
        curSortOption: "",
        folders: [],
        curFolderId: "",
        curSets: []
      }
    },
    created() {
      this.init();
    },
    methods: {
      init() {
        this.fetchData();
        this.sortOptions = [
          {value: 'createTime', label: 'createTime'},
          {value: 'proficiency', label: 'proficiency'},
          {value: 'latestLearn', label: 'latestLearn'},
        ]
      },
      async fetchData() {
        await this.axios.get('/api/set/list_of_user').then((res) => {
          res.data.forEach((set) => {
            set.isDateVisible = false;
          })
          this.sets = this.curSets = res.data;
        });
        this.curSortOption = 'latestLearn';
        this.curSets.sort((set2, set1) => {
          return set1.latest_learntime - set2.latest_learntime;
        });
        this.groupDate(this.curSets, 'latest_learntime');
        await this.axios.get('/api/folder/list').then((res) => {
          res.data.forEach((folder) => {
            this.folders.push({
              label: folder.name,
              value: folder.fid
            })
          });
        });
      },
      onFolderChange() {
        if (typeof this.curFolderId == "number") {
          this.axios.get('/api/folder/listSet', {
            params: {
              fid: this.curFolderId
            }
          }).then((res) => {
            let sids = res.data;
            this.filterSet(sids);
            if(this.curSets.length!=0){
              this.onSortChange();
            }
          });
        } else {
          this.curSets = this.sets;
          if(this.curSets.length!=0){
            this.onSortChange();
          }
        }
      },
      filterSet(sids) {
        this.curSets = [];
        this.sets.forEach((set) => {
          sids.forEach((sid) => {
            if (set.sid == sid) {
              this.curSets.push(set);
            }
          })
        })
      },
      onSortChange() {
        this.curSets.forEach((set) => {
          set.isDateVisible = false;
        });
        if (this.curSortOption == 'proficiency') {
          this.curSets.sort((set2, set1) => {
            return set1.rmatrix + set1.rwrite - (set2.rmatrix + set2.rwrite);
          })
        } else if (this.curSortOption == 'createTime') {
          this.curSets.sort((set2, set1) => {
            return set1.createtime - set2.createtime;
          });
          this.groupDate(this.curSets, 'createtime');
        } else if (this.curSortOption == 'latestLearn') {
          this.curSets.sort((set2, set1) => {
            return set1.latest_learntime - set2.latest_learntime;
          });
          this.groupDate(this.curSets, 'latest_learntime');
        }
        console.log(this.curSortOption);
      },
      groupDate(sets, property) {
        let curDate = new Date(sets[0][property]);
        sets[0].isDateVisible = true;
        for (let set of sets) {
          let mDate = new Date(set[property]);
          if (mDate.getFullYear() == curDate.getFullYear() && mDate.getMonth() == curDate.getMonth() && mDate.getDate() == curDate.getDate()) {
            continue;
          } else {
            set.isDateVisible=true;
            curDate=mDate;
          }
        }
      },
      openItem() {
        window.open(window.location.origin + '/');
        console.log('gg');
      },
      dateFormat(timeStamp) {
        let date = new Date(timeStamp);
        return date.getFullYear() + '年' + (1 + date.getMonth()) + '月' + date.getDate() + '日';
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

  .list-item {
    width: 100%;
    height: 6rem;
    margin-bottom: 2rem;
    background-color: white;
    display: flex;
    align-items: center;
    cursor: pointer;
  }

  .degree {
    width: 4.5rem;
    height: 4.5rem;
    background-color: #42b983;
    border-radius: 4.5rem;
  }

  .name {
    margin-top: 1rem;
    font-size: 1.8rem;
  }

  .intro {
    font-size: 1rem;
    margin-top: 0.5rem;
  }
</style>

<style>
  .user-set-scrollbar .el-scrollbar__wrap {
    overflow-x: hidden;
    padding-bottom: 10rem;
    padding-left: 5%;
    padding-right: 5%;
  }
</style>
