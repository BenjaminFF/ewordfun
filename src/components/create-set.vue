<template>
  <transition enter-active-class="animated slideInDown" leave-active-class="animated slideOutUp" v-on:after-enter="afterEnter">
    <div class="l-create-set" v-if="createSetVisible">
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
        :custom-class="'cs-dialog'"
        width="20%">
        <el-form :rules="rules" :model="set" ref="createSetForm">
          <el-form-item prop="name">
            <el-input :placeholder="$t('createDialog.name')" style="font-size: 1.5rem" v-model="set.name" maxlength="32"></el-input>
          </el-form-item>
          <el-form-item prop="intro">
            <el-input type="textarea" min-row resize="none" :autosize="{ minRows: 8, maxRows: 8 }" :placeholder="$t('createDialog.introduction')"
                      style="font-size: 1.2rem;margin-top: 1rem" v-model="set.intro"  maxlength="200"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button style="width: 100%;margin-top: 2rem;" type="primary" @click="submitForm('createSetForm')">{{$t('createDialog.submit')}}</el-button>
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
        createSetVisible:false
      }
    },
    created() {
      this.createSetVisible=false;
      setTimeout(()=>{
        this.createSetVisible=true;
      });
      //close or flush browser save the data to localStorage
      window.onbeforeunload = (e)=> {
        if(this.$route.path=='/createSet'){
          this.saveTempData();
        }else {
          window.onbeforeunload=null;
        }
      };
      //offline to on line reload createSet
      window.addEventListener('online', ()=>{
        this.createSetVisible=false;
        setTimeout(()=>{
          this.createSetVisible=true;
        });
      });
      //save the data to localStorage when it's offline
      window.addEventListener('offline', ()=>{
        this.saveTempData();
      });
    },
    watch:{
      dialogVisible(){
        if(!this.dialogVisible){
          setTimeout(()=>{
            this.$refs.createSetForm.clearValidate();
          },100);
        }
      }
    },
    methods: {
      init() {
        this.set={
          name:"",
          intro:""
        }
        this.rules={
          name:[
            { required: true, message: this.$t('createDialog.nameEmpty'), trigger: 'blur' },
            ]
        }
        let cards=[];
        let tempData=localStorage.getItem("createSet_tempData");
        console.log(tempData);
        if(tempData!=null){
          let tempVocabularies=JSON.parse(tempData);
          tempVocabularies.forEach((vocabulary)=>{
            cards.push({
              key:Date.now(),
              term: vocabulary.term,
              definition: vocabulary.definition,
              hovered: false,
              addVisible: false,
              backgroundColor: "",
              isInitialCard:true
            })
          })
        }
        while (cards.length<3){
          cards.push({
            key:Date.now(),
            term: "",
            definition: "",
            hovered: false,
            addVisible: false,
            backgroundColor: "",
            isInitialCard:true,
          });
        }
        cards.push({                 //最后一个为add Set
          key:Date.now(),
          term: "",
          definition: "",
          hovered: false,
          addVisible: false,
          backgroundColor: "",
          isInitialCard:true,
        });
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
        console.log('afterEnter');
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
        cards.pop();                     //最后一个单词卡无效
        for (let [index, card] of cards.entries()) {
          if (card.term == ""||card.term.length>32) {
            this.$message({
                message: this.$t('createSet.termLenError', {row: index + 1}),
                duration: 2000,
                type: 'error'
              }
            );
            this.$refs['termInput'][index].focus();
            return;
          }
          if (card.definition == ""||card.definition.length>1024) {
            this.$message({
                message: this.$t('createSet.defLenError', {row: index + 1}),
                duration: 2000,
                type: 'error'
              }
            );
            this.$refs['defInput'][index].focus();
            return;
          }
        }
        this.dialogVisible = true;
      },
      //when submit success, clear localData
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
              localStorage.removeItem("createSet_tempData");
            });
          } else {
            return false;
          }
        });
      },
      //save the data when click return button
      createSetReturn(){
        this.$router.go(-1);
        this.saveTempData();
      },
      saveTempData(){
        let tempVocabularies=[];
        this.cards.forEach((card)=>{
          if(card.term!=""||card.definition!=""){
            tempVocabularies.push({
              term:card.term,
              definition:card.definition
            })
          }
        })
        if(tempVocabularies.length!=0){
          localStorage.setItem("createSet_tempData",JSON.stringify(tempVocabularies));
        }
      }
    }
  }
</script>

