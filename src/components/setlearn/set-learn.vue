<template>
  <div class="set-learn">
    <div class="set-learn__inner animated fadeIn">
      <div class="set-learn-header" v-if="vocabularies.length>0">
        <div style="font-size: 3rem;color: white;margin: 1rem">{{set.name}}</div>
        <div style="font-size: 2rem;color: white">{{set.intro}}</div>
      </div>
      <el-scrollbar style="width: 100%;height: 80%;margin-top: 2rem" class="set-learn__list">
        <div class="l-learncard" v-for="(vocabulary,index) in vocabularies"
             :style="{backgroundColor:vocabulary.backgroundColor}">
          <el-row class="l-learncard__l-container">
            <el-col :span="2" style="text-align: center" class="l-learncard__id">{{index+1}}</el-col>
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
              <v-btn icon style="margin-right: 0rem" @click="setEditable(vocabulary,index)">
                <v-icon class="l-learncard__icon">edit</v-icon>
              </v-btn>
              <v-btn icon style="margin-left: 0rem" @click="speakVoices(vocabulary.term+' '+vocabulary.definition,false)">
                <v-icon class="l-learncard__icon">volume_up</v-icon>
              </v-btn>
            </el-col>
          </el-row>
        </div>
      </el-scrollbar>
      <v-speed-dial
        v-model="fab" class="set-learn__fab-container">
        <v-btn
          slot="activator"
          v-model="fab"
          fab
          dark
          color="#42b983" class="set-learn__fab">
          <v-icon>expand_less</v-icon>
          <v-icon>expand_more</v-icon>
        </v-btn>
        <v-btn
          fab
          dark
          color="#42b983" class="set-learn__fab">
          <v-icon @click="pushRouter('/matrixLearn')">edit</v-icon>
        </v-btn>
        <v-btn
          fab
          dark
          color="#42b983" class="set-learn__fab">
          <v-icon medium>reply</v-icon>
        </v-btn>
      </v-speed-dial>
    </div>
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
          this.set = res.data.set;
          this.vocabularies = res.data.vocabularies;
          this.vocabularies.forEach((vocabulary, index) => {
            let backgroundColor = this.getSpecialColor();
            if (index != 0) {
              while (backgroundColor == this.vocabularies[index - 1].backgroundColor) {
                backgroundColor = this.getSpecialColor();
              }
            }
            Vue.set(vocabulary, 'editable', false);
            Vue.set(vocabulary, 'backgroundColor', backgroundColor);
          })
        })
      },
      blurCardInput(e, vocabulary) {
        if (e.relatedTarget == null || e.relatedTarget.readOnly || e.relatedTarget.readOnly == undefined) {
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
      },
      pushRouter(routerName) {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        this.$router.push(routerName + '/' + uid + '/' + sid);
      }
    }
  }
</script>
