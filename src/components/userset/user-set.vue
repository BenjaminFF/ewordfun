<template>
  <div class="user-set">
    <el-row class="us-control-bar">
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
        <v-btn icon class="us-control-bar__icon" @click="filterByStared">
          <i :class="{'el-icon-star-on':stared,'el-icon-star-off':!stared}" style="color: inherit"></i>
        </v-btn>
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
    <el-scrollbar class="user-set__list">
      <div v-for="set in curSets" v-if="setsVisible">
        <div style="width: 100%;height: fit-content">
          <div class="us-list-item__date" v-if="set.isDateVisible">
            {{curSortOption=='createtime'?dateFormat(set.createtime):dateFormat(set.latest_learntime)}}
          </div>
            <el-row class="us-list-item animated fadeIn" :style="{backgroundColor:set.backgroundColor}" @click.native="openItem(set)">
              <el-col :span="18" class="us-list-item__info-container">
                <div class="us-list-item__name">{{set.name}}</div>
                <div class="us-list-item__intro">{{set.intro}}</div>
              </el-col>
              <el-col :span="6" class="us-list-item__icons">
                <v-btn icon style="font-size:inherit;cursor: pointer;color: inherit;margin-right: 0rem" @click.stop="starToServer(set)">
                  <i :class="{'el-icon-star-on':set.stared,'el-icon-star-off':!set.stared}" style="color: inherit"></i>
                </v-btn>
                <v-btn icon style="font-size:inherit;cursor: pointer;color: inherit">
                  <i class="el-icon-more" style="color: inherit"></i>
                </v-btn>
              </el-col>
            </el-row>
        </div>
      </div>
    </el-scrollbar>
    <v-btn
      fab
      dark
      class="user-set__add-button mm-fab" @click="createSet">
      <i class="ef-icon-add" style="font-size: 1.2rem"></i>
    </v-btn>
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
        curSets: [],
        stared:false,
        curSids:[],
        setsVisible:true
      }
    },
    created() {
      this.init();
    },
    methods: {
      init() {
        this.sortOptions = [
          {value: 'createTime', label: 'createTime'},
          {value: 'proficiency', label: 'proficiency'},
          {value: 'latestLearn', label: 'latestLearn'},
        ]
        this.curSids=[];
        this.fetchData();
      },
      async fetchData() {
        await this.axios.get('/api/set/list_of_user').then((res) => {
          res.data.forEach((set,index) => {
            set.isDateVisible = false;
            set.backgroundColor=this.getSpecialColor();
            if(index!=0){
              while (set.backgroundColor==res.data[index-1].backgroundColor){
                set.backgroundColor=this.getSpecialColor();
              }
            }
            this.curSids.push(set.sid);
            console.log(set);
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
        this.curSets=[];
        if (typeof this.curFolderId == "number") {
          this.axios.get('/api/folder/listSet', {
            params: {
              fid: this.curFolderId
            }
          }).then((res) => {
            this.curSids = res.data;
            this.filterSet(this.curSids);
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
      createSet(){
        this.$router.push('createSet');
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
        this.setsVisible=false;
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
        setTimeout(()=>{
          this.setsVisible=true;
        },10);
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
      openItem(set) {
        window.open(window.location.origin + '/#/setLearn/'+set.uid+'/'+set.sid);
      },
      dateFormat(timeStamp) {
        let date = new Date(timeStamp);
        return date.getFullYear() + '年' + (1 + date.getMonth()) + '月' + date.getDate() + '日';
      },
      filterByStared(){
        this.stared=!this.stared;
        if(this.stared){
          this.curSets=this.curSets.filter(set=>set.stared);
          if(this.curSets.length!=0){
            this.onSortChange();
          }
        }else {
          this.filterSet(this.curSids);
        }
      },
      starToServer(set){
        set.stared=set.stared==1?0:1;
        let setRecordJson=JSON.stringify({
          sid:set.sid,
          uid:set.uid,
          stared:set.stared
        })
        this.axios.post('/api/set/updateRecord',{
          setRecord:setRecordJson
        })
      }
    }
  }
</script>
