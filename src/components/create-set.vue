<template>
  <transition enter-active-class="animated slideInDown" leave-active-class="animated slideOutUp">
    <div class="l-create-set">
      <div class="l-create-set__list-container">
        <ef-list ref="EfList" :list="cards" :wrap-height="'100%'" style="width: 100%;">
          <div class="l-create-set-card" v-for="(card,index) in cards" :key="n">
            <el-row class="l-create-set-card__main" @mouseenter.native="card.hovered=true" ref="cards"
                    @mouseleave.native="card.hovered=false">
              <el-col class="id" :span="1" style="text-align: center;color: black">{{index+1}}</el-col>
              <el-col class="term" :span="11">
                <el-input type="textarea" autosize resize="none" style="margin-rigt: 5%" v-model="card.term" ref="termInput"></el-input>
              </el-col>
              <el-col class="definition" :span="11">
                <el-input type="textarea" autosize resize="none" style="margin-left: 5%"
                          v-model="card.definition" ref="defInput"></el-input>
              </el-col>
              <el-col class="delete" :span="1" style="text-align: center;cursor: pointer;font-size: 1.2rem">
                <i class="el-icon-delete" style="color: black" @click="delCard(index)" v-if="card.hovered"></i>
              </el-col>
              <div class="l-create-set-card__bottom-add" v-if="index==cards.length-1" @click="addCard(index-1)">
                {{$t('createSet.addCard')}}
              </div>
            </el-row>
            <div style="width: 70%;text-align: center;height: 3rem" @mouseenter="card.addVisible=true"
                 @mouseleave="card.addVisible=false">
            <span class="l-create-set-card__add-button animated bounceIn" @click="addCard(index)"
                  v-if="card.addVisible&&index<cards.length-2">
              <i class="el-icon-plus"></i>
            </span>
            </div>
          </div>
        </ef-list>
        <span class="confirm-fab" @mouseover="confirmHovered=true" @mouseleave="confirmHovered=false"
              :class="[{'animated tada':confirmHovered}]" @click="openDialog">
        <i class="el-icon-check"></i>
      </span>
      </div>
      <el-button class="create-set-return" @click="createSetReturn">{{$t('createSet.return')}}</el-button>
      <el-dialog
        :title="$t('createDialog.header')"
        :center="true"
        :visible.sync="dialogVisible"
        :modal-append-to-body="false"
        :custom-class="'createSetDialog'"
        width="20%">
        <el-form :rules="rules" :model="set" ref="createSetForm">
          <el-form-item prop="name">
            <el-input :placeholder="$t('createDialog.name')" style="font-size: 1.5rem" v-model="set.name"></el-input>
          </el-form-item>
          <el-form-item>
            <el-input type="textarea" min-row resize="none" :autosize="{ minRows: 4, maxRows: 6 }" :placeholder="$t('createDialog.introduction')"
                      style="font-size: 1.2rem;margin-top: 2rem" v-model="set.intro"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button style="width: 100%;margin-top: 4rem;" type="primary" @click="submitForm('createSetForm')">{{$t('createDialog.submit')}}</el-button>
          </el-form-item>
        </el-form>
      </el-dialog>
    </div>
  </transition>
</template>

<script>
  import EfList from "./ef-list/list";

  export default {
    name: "create-set",
    components: {EfList},
    data() {
      return {
        cards: [],
        set: {},
        confirmHovered: false,
        dialogVisible: false,
        rules:{},
      }
    },
    created() {
      this.init();
    },
    methods: {
      init() {
        this.set={
          name:"",
          intro:""
        }
        this.rules={
          name:[
            { required: true, message: this.$t('createDialog.nameEmpty'), trigger: 'blur' }
          ]
        }
        let card1 = {
          term: "",
          definition: "",
          hovered: false,
          addVisible: false
        }
        let card2 = {
          term: "",
          definition: "",
          hovered: false,
          addVisible: false
        }
        let card3 = {
          term: "",
          definition: "",
          hovered: false,
          addVisible: false
        }
        this.cards.push(card1, card2, card3);
      },
      delCard(index) {
        this.$refs.EfList.delItem(index);
        console.log(this.cards);
      },
      addCard(index) {
        this.$refs.EfList.addItem(index, {
          term: "",
          definition: "",
          hovered: false,
          addVisible: false
        });
        console.log(this.cards);
      },

      openDialog() {
        let cards = [...this.cards];
        cards.pop();
        for (let [index, card] of cards.entries()) {
          if (card.term == "") {
            this.$message({
                message: this.$t('createSet.termEmpty', {row: index + 1}),
                duration: 1500,
                type: 'error'
              }
            );
            this.$refs['termInput'][index].focus();
            return;
          }
          if (card.definition == "") {
            this.$message({
                message: this.$t('createSet.defEmpty', {row: index + 1}),
                duration: 1500,
                type: 'error'
              }
            );
            this.$refs['defInput'][index].focus();
            return;
          }
        }
        this.dialogVisible = true;
      },
      submitForm(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            let cards = [...this.cards];
            cards.pop();
            this.axios.post('/api/set/create',{
              set:JSON.stringify(this.set),
              vocabularies:JSON.stringify(cards),
            }).then((res)=>{
              this.$router.go(-1);
            });
          } else {
            return false;
          }
        });
      },
      createSetReturn(){
        this.$router.go(-1);
      }
    }
  }
</script>

<style scoped>
  .confirm-fab {
    width: 4rem;
    height: 4rem;
    box-shadow: 0px 0px 30px 0px rgba(0, 0, 0, 0.16);
    border-radius: 3rem;
    position: absolute;
    right: 5%;
    bottom: 5%;
    background-color: black;
    text-align: center;
    color: white;
    line-height: 4rem;
    font-size: 1.5rem;
    cursor: pointer;
  }

  .create-set-return{
    position: absolute;
    left: 2rem;
    top: 2rem;
  }
</style>

<style>
  .l-create-set-card .el-textarea {
    width: 95%;
    padding-top: 1rem;
    padding-bottom: 2rem;
  }

  .l-create-set-card .el-textarea__inner {
    border: none;
    border-bottom: 2px solid black;
    font-size: 1.5rem;
    background-color: transparent;
  }

  .createSetDialog{
    min-width: 30rem;
  }

  .createSetDialog .el-dialog__title{
    font-size: 1.8rem;
  }
</style>
