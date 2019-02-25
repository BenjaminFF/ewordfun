<template>
  <div class="set-learn">
    <div class="header">
      <div style="margin-top: 1rem;font-size: 2.5rem">{{set.name}}</div>
      <div style="margin-top: 1rem;font-size: 2rem">{{set.intro+'aaaaaa'}}</div>
    </div>
    <el-scrollbar style="width: 100%;height: 80%;margin-top: 2rem" class="set-learn-list">
      <el-row v-for="(vocabulary,index) in vocabularies" class="l-learncard">
        <el-col :span="2" style="text-align: center">{{index+1}}</el-col>
        <el-col :span="9">
          <el-input type="textarea" autosize resize="none" class="l-learncard__input" ref="cardTermInput"
                    :class="{'is-active':vocabulary.editable}" @blur="blurCardInput($event,vocabulary)"
                    v-model="vocabulary.term" :readonly="!vocabulary.editable" @click.native="speakVoices(vocabulary.term,vocabulary.editable)"></el-input>
        </el-col>
        <el-col :span="9" :offset="2">
          <el-input type="textarea" autosize resize="none" class="l-learncard__input"
                    :class="{'is-active':vocabulary.editable}" ref="cardDefInput" @click.native="speakVoices(vocabulary.definition,vocabulary.editable)"
                    v-model="vocabulary.definition" :readonly="!vocabulary.editable" @blur="blurCardInput($event,vocabulary)"></el-input>
        </el-col>
        <el-col :span="2" style="text-align: center">
          <i class="ewordfun ef-pen" :span="1" style="font-size: 1.5rem;cursor: pointer;margin-right: 0.5rem"
             @click="setEditable(vocabulary,index)"></i>
          <i class="ewordfun ef-voice" :span="1"  style="font-size: 1.5rem;cursor: pointer"
             @click="speakVoices(vocabulary.term+' '+vocabulary.definition,false)"></i>
        </el-col>
      </el-row>
    </el-scrollbar>
  </div>
</template>

<script>
  export default {
    name: "set-learn",
    data() {
      return {
        vocabularies: [],
        set: {},
        curVocabulary:{}
      }
    },
    created() {
      this.fetchData();
    },
    methods: {
      speakVoices(text,inputEditable){
        if(inputEditable){
          return;
        }
        if(responsiveVoice.isPlaying()){
          responsiveVoice.cancel();
        }
        responsiveVoice.speak(text);
      },
      fetchData() {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        this.axios.get('/api/set/acquire', {
          params: {
            uid: uid,
            sid: sid
          }
        }).then((res) => {
          this.set = res.data.set[0];
          this.vocabularies = res.data.vocabularies;
          this.vocabularies.forEach((vocabulary) => {
            Vue.set(vocabulary, 'editable', false);
          })
        })
      },
      blurCardInput(e,vocabulary) {
        if(e.relatedTarget==null||e.relatedTarget.readOnly){
          if(vocabulary.editable){
            vocabulary.editable=false;
            if(this.curVocabulary.term!=vocabulary.term||this.curVocabulary.definition!=vocabulary.definition){
              this.axios.post('/api/vocabulary/update',{
                vid:vocabulary.vid,
                term:vocabulary.term,
                definition:vocabulary.definition
              });
            }
          }
        }
      },
      setEditable(vocabulary,index){
        if(vocabulary.editable){
          return;
        }
        this.curVocabulary={...vocabulary};
        this.vocabularies.forEach((vocabulary)=>{
          vocabulary.editable=false;
        });
        vocabulary.editable=true;
        this.$refs.cardTermInput[index].focus();
      }
    }
  }
</script>

<style scoped>
  .container {
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: white;
    z-index: 1000;
  }

  .header {
    width: 100%;
    height: 15%;
    color: white;
    font-size: 2rem;
    background-color: #42b983;
    display: flex;
    align-items: center;
    flex-direction: column;
  }
</style>

<style>

</style>
