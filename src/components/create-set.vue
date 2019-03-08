<template>
  <transition enter-active-class="animated slideInDown" leave-active-class="animated fadeOut" v-on:after-enter="afterEnter">
    <div class="l-create-set">
      <div class="l-create-set__list-container">
        <anim-list ref="animList" :items="cards" style="width: 100%;height: 75%;margin-top: 5%;">
          <div class="l-create-set-card" v-for="(card,index) in cards" :key="card.key" :class="{'animated bounceInLeft':card.isInitialCard}">
            <el-row class="l-create-set-card__main" @mouseenter.native="card.hovered=true" ref="cards"
                    @mouseleave.native="card.hovered=false" :style="{backgroundColor:card.backgroundColor}">
              <el-col class="l-create-set-card__id" :span="1">{{index+1}}</el-col>
              <el-col class="term" :span="11">
                <el-input type="textarea" autosize resize="none" style="margin-rigt: 5%" v-model="card.term" ref="termInput"></el-input>
              </el-col>
              <el-col class="definition" :span="11">
                <el-input type="textarea" autosize resize="none" style="margin-left: 5%"
                          v-model="card.definition" ref="defInput"></el-input>
              </el-col>
              <el-col class="delete" :span="1" style="text-align: center;cursor: pointer;font-size: 1.2rem">
                <i class="ef-icon-trash" @click="delCard(index)" v-if="card.hovered" v-ripple></i>
              </el-col>
              <div class="l-create-set-card__bottom-add" v-if="index==cards.length-1" @click="addCard(index-1)" :style="{backgroundColor:card.backgroundColor}">
                {{$t('createSet.addCard')}}
              </div>
            </el-row>
            <div style="width: 70%;text-align: center;height: 3rem" @mouseenter="card.addVisible=true"
                 @mouseleave="card.addVisible=false">
            <span class="l-create-set-card__add-button animated fadeIn" @click="addCard(index)" :style="{backgroundColor:card.backgroundColor}"
                  v-if="card.addVisible&&index<cards.length-2" v-ripple>
              <i class="ef-icon-add"></i>
            </span>
            </div>
          </div>
        </anim-list>
        <span class="l-create-set__confirm-fab" @mouseover="confirmHovered=true" @mouseleave="confirmHovered=false"
              :class="[{'animated tada':confirmHovered}]" @click="openDialog">
        <i class="ef-icon-tick"></i>
      </span>
      </div>
      <i class="l-create-set__return ef-icon-return" @click="createSetReturn"></i>
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
  import AnimList from "./anim-list";

  export default {
    name: "create-set",
    components: {AnimList},
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
      //this.init();
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
        let cards=[];
        let card1 = {
          key:Date.now(),
          term: "",
          definition: "",
          hovered: false,
          addVisible: false,
          backgroundColor: "",
          isInitialCard:true,
        }
        let card2 = {
          key:Date.now(),
          term: "",
          definition: "",
          hovered: false,
          addVisible: false,
          backgroundColor: "",
          isInitialCard:true,
        }
        let card3 = {
          term: "",
          definition: "",
          hovered: false,
          addVisible: false,
          backgroundColor: "",
          isInitialCard:true
        }
        let card4 = {
          term: "",
          definition: "",
          hovered: false,
          addVisible: false,
          backgroundColor: "",
          isInitialCard:true
        }
        cards.push(card1, card2, card3,card4);
        cards.forEach((card,index)=>{
          card.backgroundColor=this.getSpecialColor();
          if(index!=0){
            while (card.backgroundColor==cards[index-1].backgroundColor){
              card.backgroundColor=this.getSpecialColor();
            }
          }
          if(index!=cards.length-1){
            while (card.backgroundColor==cards[index+1].backgroundColor){
              card.backgroundColor=this.getSpecialColor();
            }
          }
        });
        this.cards=cards;
        setTimeout(()=>{
          this.cards.forEach((card)=>{
            card.isInitialCard=false;
          });
        },1000);
      },
      afterEnter(){
        this.init();
      },
      delCard(index) {
        this.$refs.animList.delItem(index);
      },
      addCard(index) {
        let backgroundColor=this.getSpecialColor();
        if(index!=0){
          while (backgroundColor==this.cards[index-1].backgroundColor){
            backgroundColor=this.getSpecialColor();
          }
        }
        this.$refs.animList.addItem(index+1, {
          key:Date.now(),
          term: "",
          definition: "",
          hovered: false,
          addVisible: false,
          backgroundColor: backgroundColor,
          isInitialCard:false
        });
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

  }
</style>

<style>
  .createSetDialog{
    min-width: 30rem;
  }

  .createSetDialog .el-dialog__title{
    font-size: 1.8rem;
  }
</style>
