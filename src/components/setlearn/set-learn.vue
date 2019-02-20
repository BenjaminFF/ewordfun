<template>
  <div class="container">
    <div class="header">
      <div style="margin-top: 1rem;font-size: 3rem">{{set.name}}</div>
      <div style="margin-top: 2rem;font-size: 2rem">{{set.intro+'aaaaaa'}}</div>
    </div>
    <div class="tools">
      <div class="tool" v-for="n in 4"></div>
    </div>
    <el-scrollbar style="width: 100%;height: 60%;" class="set-learn-list">
      <el-row v-for="(vocabulary,index) in vocabularies" class="l-learncard">
        <el-col :span="7" :offset="1">
          <el-input type="textarea" autosize resize="none" class="l-learncard__input" ref="cardTermInput"
                    :class="{'is-active':vocabulary.editable}" @blur="blurCardInput($event,vocabulary)"
                    v-model="vocabulary.term" :readonly="!vocabulary.editable"></el-input>
        </el-col>
        <el-col :span="13" :offset="1">
          <el-input type="textarea" autosize resize="none" class="l-learncard__input"
                    :class="{'is-active':vocabulary.editable}" ref="cardDefInput"
                    v-model="vocabulary.definition" :readonly="!vocabulary.editable" @blur="blurCardInput($event,vocabulary)"></el-input>
        </el-col>
        <el-col :span="2">
          <i class="el-icon-edit" :span="1" style="font-size: 1.5rem;cursor: pointer;margin-right: 1rem"
             @click="setEditable(vocabulary,index)"></i>
          <i class="el-icon-edit" :span="1"  style="font-size: 1.5rem;cursor: pointer"
             @click="setEditable(vocabulary,index)"></i>
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
      }
    },
    created() {
      this.fetchData();
    },
    methods: {
      speakVoices(){
        let msg = new SpeechSynthesisUtterance('hello world');
        msg.voice = speechSynthesis.getVoices().filter(function (voice) {
          return voice.name == 'Google US English';
        })[0];
        msg.rate=0.9;
        speechSynthesis.speak(msg);
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
          vocabulary.editable=false;
        }
      },
      setEditable(vocabulary,index){
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
    height: 30%;
    color: black;
    font-size: 2rem;
    background-color: #42b983;
    display: flex;
    align-items: center;
    flex-direction: column;
  }

  .tools {
    width: 100%;
    height: fit-content;
    display: flex;
    justify-content: center;
    transform: translateY(-50%);
  }

  .tool {
    width: 6rem;
    height: 6rem;
    background-color: black;
    margin-left: 2rem;
    margin-right: 2rem
  }
</style>

<style>

</style>
