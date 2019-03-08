<template>
  <div class="set-learn">
    <div class="my-header">
      <div style="font-size: 3rem;color: white;margin: 1rem">{{set.name}}</div>
      <div style="font-size: 2rem;color: white">{{set.intro+'aaa'}}</div>
    </div>
    <el-scrollbar style="width: 100%;height: 80%;margin-top: 2rem" class="set-learn-list">
      <div class="l-learncard" v-for="(vocabulary,index) in vocabularies">
        <el-row class="l-learncard__l-container">
          <el-col :span="2" style="text-align: center">{{index+1}}</el-col>
          <el-col :span="9">
            <el-input type="textarea" autosize resize="none" class="l-learncard__input" ref="cardTermInput"
                      :class="{'is-active':vocabulary.editable}" @blur="blurCardInput($event,vocabulary)"
                      v-model="vocabulary.term" :readonly="!vocabulary.editable"
                      @click.native="speakVoices(vocabulary.term,vocabulary.editable)"></el-input>
          </el-col>
          <el-col :span="9" :offset="2">
            <el-input type="textarea" autosize resize="none" class="l-learncard__input"
                      :class="{'is-active':vocabulary.editable}" ref="cardDefInput"
                      @click.native="speakVoices(vocabulary.definition,vocabulary.editable)"
                      v-model="vocabulary.definition" :readonly="!vocabulary.editable"
                      @blur="blurCardInput($event,vocabulary)"></el-input>
          </el-col>
          <el-col :span="2" style="text-align: center">
            <v-btn icon style="margin-right: 0rem">
              <v-icon @click="setEditable(vocabulary,index)" >edit</v-icon>
            </v-btn>
            <v-btn icon style="margin-left: 0rem">
              <v-icon @click="speakVoices(vocabulary.term+' '+vocabulary.definition,false)">volume_up</v-icon>
            </v-btn>
          </el-col>
        </el-row>
      </div>
    </el-scrollbar>
    <v-speed-dial
      v-model="fab" style="position: absolute;right: 2rem;bottom: 2rem">
      <v-btn
        slot="activator"
        v-model="fab"
        fab
        dark
        color="#42b983" class="set-learn-fab">
        <v-icon>expand_less</v-icon>
        <v-icon>expand_more</v-icon>
      </v-btn>
      <v-btn
        fab
        dark
        color="#42b983" class="set-learn-fab">
        <v-icon>edit</v-icon>
      </v-btn>
      <v-btn
        fab
        dark
        color="#42b983" class="set-learn-fab">
        <v-icon medium>reply</v-icon>
      </v-btn>
    </v-speed-dial>
  </div>
</template>

<script>
  export default {
    name: "set-learn",
    data() {
      return {
        vocabularies: [],
        set: {},
        curVocabulary: {},
        fab: false
      }
    },
    created() {
      this.init();
      this.fetchData();

    },
    methods: {
      init() {

      },
      speakVoices(text, inputEditable) {
        if (inputEditable) {
          return;
        }
        if (responsiveVoice.isPlaying()) {
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
      blurCardInput(e, vocabulary) {
        if (e.relatedTarget == null || e.relatedTarget.readOnly) {
          if (vocabulary.editable) {
            vocabulary.editable = false;
            if (this.curVocabulary.term != vocabulary.term || this.curVocabulary.definition != vocabulary.definition) {
              this.axios.post('/api/vocabulary/update', {
                vid: vocabulary.vid,
                term: vocabulary.term,
                definition: vocabulary.definition
              });
            }
          }
        }
      },
      setEditable(vocabulary, index) {
        if (vocabulary.editable) {
          return;
        }
        this.curVocabulary = {...vocabulary};
        this.vocabularies.forEach((vocabulary) => {
          vocabulary.editable = false;
        });
        vocabulary.editable = true;
        this.$refs.cardTermInput[index].focus();
      }
    }
  }
</script>

<style scoped>
  .my-header{
    width: 100%;
    height: 10rem;
    background-color: #42b983;
    display: flex;
    align-items: center;
    user-select: none;
    flex-direction: column;
  }
</style>

<style>
  .set-learn-fab {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    vertical-align: middle;
    box-shadow: none !important;
  }

  .set-learn-fab i {
    width: 100% !important;
    height: 100% !important;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    vertical-align: middle;
  }

  .set-learn-list {
    width: 100%;
    height: 80%;
  }

  .set-learn-list .el-scrollbar__wrap {
    overflow-x: hidden;
  }
</style>
