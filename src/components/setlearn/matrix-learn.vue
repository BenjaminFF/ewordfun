<template>
  <div class="matrix-learn">
    <div class="sk-three-bounce" v-if="dataLoading">
      <div class="sk-child sk-bounce1 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce2 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce3 matrix-learn__loading"></div>
    </div>
    <div class="matrix-learn__inner animated fadeIn" v-if="!dataLoading">
      <div class="matrix-learn__controlBar">
        <v-btn icon style="font-size:inherit;cursor: pointer;color: inherit" @click="routerGo('-1')">
          <i class="ef-icon-cross" style="color: inherit"></i>
        </v-btn>
        <div class="ml-progress">
          <div class="ml-progress__inner" :style="{width:progress.percentage+'%'}"></div>
        </div>
        <div style="margin-left: 1rem;color: inherit">{{progress.cur+'/'+progress.total}}</div>
      </div>
      <div class="matrix-learn__content-layout animated fadeIn" v-for="(curCard,index) in curCards"
           v-if="index==progress.cur&&progress.cur!=curCards.length">
        <div class="ml-underlines" @click="withDrawMatrixCell">
          <div class="ml-underlines__underline" v-for="underline in curCard.underlines"
               :class="{
             'is-active':underline.isActive,
             'is-space':underline.isSpace,
              'is-error':answerStateId==2,
             'is-success':answerStateId==1,
             }">
            {{underline.isActive?underline.text:""}}
          </div>
        </div>
        <el-scrollbar class="ml-definition">
          {{curCard.definition}}
        </el-scrollbar>
        <div class="ml-matrix">
          <div class="ml-matrix__inner">
            <div v-for="cell in curCard.matrixCells" class="ml-matrix__cell" @click="activeMatrixCell(cell)"
                 :class="{
               'is-active':cell.isActive,
               'is-error':answerStateId==2&&cell.isActive,
               'is-success':answerStateId==1&&cell.isActive,
               }">
              {{cell.text}}
            </div>
          </div>
        </div>
      </div>
      <div class="ml-list animated fadeIn" v-if="progress.stepStateId==2||progress.stepStateId==3">
        <div class="ml-list__title" :class="{'is-unpassed':progress.stepStateId==2}">{{progress.stepStateId==2?'错误单词'+progress.unpassCards.length+'个':"复习"}}</div>
        <el-scrollbar class="ml-list__scrollbar">
          <el-row v-for="card in progress.unpassCards" class="ml-list__item">
            <el-col :span="2" class="unpassed_count" :class="{'is-zero':card.rmatrix_unpass_count==0}">{{card.rmatrix_unpass_count==0?"+1":"-"+card.rmatrix_unpass_count}}</el-col>
            <el-col :span="8">{{card.term}}</el-col>
            <el-col :span="14">{{card.definition}}</el-col>
          </el-row>
        </el-scrollbar>
      </div>
    </div>
    <el-row class="ml-bottom-bar animated fadeIn"
            :class="{'is-error':answerStateId==2,'is-success':answerStateId==1}"
            v-if="!dataLoading">
      <el-col :span="12" style="display: flex;justify-content: center;align-items: center;height: 100%">
        <div class="ml-bottom-bar__button is-plain"
             :class="{'is-invisible':answerStateId!=0||curCards.length==progress.cur}"
             @click="skipCard">跳过
        </div>
        <el-progress type="circle" :percentage="totalProgress.percentage" width="110" stroke-width="8"
                     class="ml-bottom-bar__progress"
                     v-if="curCards.length==progress.cur"></el-progress>
        <div style="width: fit-content;position: absolute;display: flex"
             v-if="answerStateId!=0">
          <i class="ml-bottom-bar__info-icon animated zoomIn faster"
             :class="{
             'is-error':answerStateId==2,
             'is-success':answerStateId==1,
             'ef-icon-error':answerStateId==2,
             'ef-icon-success':answerStateId==1
             }"></i>
          <div class="ml-bottom-bar__info-text is-error" v-if="answerStateId==2">
            正确答案
            <div>{{curCards[progress.cur].term}}</div>
          </div>
        </div>
      </el-col>
      <el-col :span="12" style="display: flex;justify-content: center;align-items: center;height: 100%">
        <button class="ml-bottom-bar__button is-primary" @click="nextStep"
             :class="{'is-error':answerStateId==2,'is-success':answerStateId==1,'is-disabled':getStepState.Id==0&&!canCheckAnswer}" :disabled="getStepState.Id==0&&!canCheckAnswer">
          {{getStepState.text}}
        </button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import _ from 'lodash'

  export default {
    name: "",
    data() {
      return {
        set: {},
        progress: {},
        curCards: [],
        dataLoading: true,
        stepStates: [],
        totalProgress: {},
        totalCards: []              //用来显示重新学习页面card没有通过的次数
      }
    },
    created() {
      this.init();
      this.fetchData();
    },
    watch: {
      'progress.cur': 'updateStepState'
    },
    computed: {
      getStepState() {
        return this.stepStates.filter((state) => state.Id == this.progress.stepStateId)[0];
      },
      //0表示没有checkAnswer,1表示right answer，2表示wrong answer
      answerStateId() {
        let stepState = this.stepStates.filter((state) => state.Id == this.progress.stepStateId)[0];
        if (stepState.Id != 1) {
          return 0;
        } else {
          let curCard = this.curCards[this.progress.cur];
          return curCard.Passed ? 1 : 2;
        }
      },
      canCheckAnswer(){
        if(this.progress.cur<this.curCards.length){
          let curCard = this.curCards[this.progress.cur];
          return curCard.curPos==curCard.underlines.length;
        }else {
          return false;
        }
      }
    },
    methods: {
      init() {
        this.stepStates = [
          {Id: 0, text: "检查", func: this.checkAnswer},
          {Id: 1, text: "继续", func: this.startNextCard},
          {Id: 2, text: "下一轮", func: this.startNextRound},
          {Id: 3, text: "重新学习", func: this.reLearn}
        ]
        this.totalCards=[];
        this.curCards=[];
        this.totalProgress={};
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
          this.curCards = this.buildCards(res.data.vocabularies);         //初始时的curCards包含所有card,passed会在数据开头，后面的curCards只包含unpassed cards如果全部Pass了，自动刷新
          this.curCards.forEach((card)=>{
            this.totalCards.push({
              term:card.term,
              definition:card.definition,
              rmatrix_unpass_count: card.rmatrix_unpass_count,
              rid:card.rid
            })
          })
          console.log(this.set);
          let cur = this.curCards.filter((card) => card.Passed).length;
          let total = this.totalCards.length;
          this.progress = {
            cur: cur,
            total: total,
            percentage: (cur / total) * 100,
            stepStateId: 0,
            unpassCards: this.totalCards,
            checkedAnswer: false
          }
          this.totalProgress = {
            cur: cur,
            total: this.totalCards.length,
            percentage: 0,
          }
          setTimeout(() => {
            this.dataLoading = false;
          }, 500);
        });
      },
      updateStepState() {
        if (this.progress.total == this.progress.cur) {            //表示一轮结束
          this.progress.stepStateId = (this.curCards.filter((card) => !card.Passed).length == 0) ? 3 : 2;      //当全部Passed时候就是3
        } else {
          this.progress.stepStateId = this.progress.checkedAnswer ? 1 : 0;
        }
      },
      checkAnswer() {
        let curCard = this.curCards[this.progress.cur];
        let answer = "";
        curCard.underlines.forEach((underline) => {
          answer += underline.text;
        });
        if (curCard.term == answer) {
          curCard.Passed = true;
          this.totalProgress.cur++;
          this.axios.post('/api/v_record/update', {
            v_record: JSON.stringify({rid: curCard.rid, rmatrix: 1})
          });
        } else {
          curCard.rmatrix_unpass_count++;
          this.totalCards.filter((card)=>card.rid==curCard.rid)[0].rmatrix_unpass_count++;
          this.axios.post('/api/v_record/update', {
            v_record: JSON.stringify({rid: curCard.rid, rmatrix_unpass_count: curCard.rmatrix_unpass_count})
          });
        }

        this.progress.checkedAnswer = true;
        this.updateStepState();
      },
      //skipCard means that you didn't pass the curCard.
      skipCard(){
        let curCard = this.curCards[this.progress.cur];
        curCard.rmatrix_unpass_count++;
        this.totalCards.filter((card)=>card.rid==curCard.rid)[0].rmatrix_unpass_count++;
        this.axios.post('/api/v_record/update', {
          v_record: JSON.stringify({rid: curCard.rid, rmatrix_unpass_count: curCard.rmatrix_unpass_count})
        });
        this.startNextCard();
      },
      startNextCard() {
        this.progress.checkedAnswer = false;
        this.progress.cur++;              //这部会自动刷新stepStateId,所以后面要用nextTick
        this.$nextTick(()=>{
          let stepStateId = this.progress.stepStateId;
          if (stepStateId == 2 || stepStateId == 3) {              //表示一轮结束或全部学习完成
            this.progress.percentage = 100;
            this.progress.unpassCards = stepStateId == 2 ? this.curCards.filter((card) => !card.Passed) : this.totalCards;
            this.progress.unpassCards=this.progress.unpassCards.sort((card1,card2)=>{
              return card2.rmatrix_unpass_count-card1.rmatrix_unpass_count
            });
            this.totalProgress.percentage = (this.totalProgress.cur / this.totalProgress.total).toFixed(3) * 100;
            if(stepStateId==3){
              let sid = this.$route.params.sid;
              let uid = this.$route.params.uid;
              let setRecord={
                sid:sid,
                uid:uid,
                rmatrix:this.set.rmatrix+1
              };
              this.axios.post('/api/set/updateRecord',{setRecord:JSON.stringify(setRecord)});
            }
          } else {
            this.progress.percentage = (this.progress.cur / this.progress.total) * 100;
          }
        })
      },
      startNextRound() {
        this.curCards = this.washCards(this.curCards);
        this.progress.cur = 0;
        this.progress.total = this.curCards.length;
        this.progress.percentage = 0;
      },
      //重新学习页面显示所有card和它们错误的次数
      reLearn() {
        this.dataLoading=true;
        this.init();
        this.fetchData();
      },
      nextStep() {
        this.stepStates.filter((state) => {
          return state.Id == this.progress.stepStateId;
        })[0].func.call(this);
      },
      routerGo(step) {
        this.$router.go(step);
      },
      washCards(cards) {
        cards = cards.filter((card) => !card.Passed);
        cards.forEach((card) => {
          card.underlines.forEach((underline) => {
            underline.isActive = false;
            underline.text = "";
          })
          card.matrixCells.forEach((cell) => {
            cell.isActive = false;
          })
          card.matrixCells = _.shuffle(card.matrixCells);
          card.curPos = 0;
        });
        return cards;
      },
      buildCards(vocabularies) {
        let cards = vocabularies.filter((vocabulary) => vocabulary.rmatrix == 0);        //筛选没有学习过的
        if(cards.length==0){              //全部学习完成
          vocabularies.forEach((vocabulary)=>{
            vocabulary.rmatrix_unpass_count=0;
            vocabulary.rmatrix=0;
            cards.push(vocabulary);
          })
          this.axios.post("/api/v_record/updateMany",{
            v_records:JSON.stringify(cards)
          })
        }
        cards=_.shuffle(cards);
        cards.forEach((card) => {
          let splitStrs = this.splitString(card.term);            //将term拆分成多个字符串
          let underlines = [];
          splitStrs.forEach((str) => {
            let isSpace = (str == " ");
            underlines.push({
              isSpace: isSpace,
              text: "",
              isActive: false             //isActive为true表示填入了str
            })
          });

          let matrixStrs = [...splitStrs].filter((str) => str != " ");        //matrix里面没有空格
          while (matrixStrs.length < 9) {          //凑够9个
            let randomChars = this.mixStr(matrixStrs[Math.floor(Math.random() * matrixStrs.length)]);
            matrixStrs.push(randomChars);
          }
          let matrixCells = [];
          matrixStrs.forEach((str) => {
            matrixCells.push({
              text: str,
              isActive: false
            })
          })
          card.underlines = underlines;
          card.matrixCells = _.shuffle(matrixCells);
          card.Passed = false;
          card.curPos = 0;
        })
        vocabularies.forEach((vocabulary) => {            //这个步骤很有必要，因为要与progress同步
          if (vocabulary.rmatrix == 1) {
            vocabulary.Passed = true;
            cards.unshift(vocabulary);
          }
        })
        return cards;
      },
      withDrawMatrixCell() {
        let curCard = this.curCards[this.progress.cur];
        let underlines = curCard.underlines;
        let matrixCells = curCard.matrixCells;
        if (curCard.curPos != 0) {
          curCard.curPos = underlines[curCard.curPos - 1].isSpace ? curCard.curPos - 2 : curCard.curPos - 1;
          for (let cell of matrixCells) {
            //matrixCells中可能有相同text的cell,并且两个cell都被Active了，所以有了一次之后就return,并且一定只能unActive已经Active过的了
            if (cell.text == underlines[curCard.curPos].text && cell.isActive) {
              cell.isActive = false;
              underlines[curCard.curPos].text = "";
              underlines[curCard.curPos].isActive = false;
              return;
            }
          }
        }
      },
      activeMatrixCell(cell) {
        let curCard = this.curCards[this.progress.cur];
        if (!cell.isActive && curCard.curPos <= curCard.underlines.length - 1) {
          cell.isActive = true;
          let underlines = curCard.underlines;
          let curPos = curCard.curPos;
          if (underlines[curPos].isSpace) {
            underlines[curPos].text = " ";          //空格也要填，后面好判断答案是否正确
            underlines[curPos + 1].isActive = true;
            underlines[curPos + 1].text = cell.text;
            curCard.curPos += 2;
          } else {
            underlines[curPos].isActive = true;
            underlines[curPos].text = cell.text;
            curCard.curPos++;
          }
        }
      },
      mixStr(str) {
        let midPos = Math.floor(str.length / 2);
        let chars = str.split("");
        let randomChar;
        do {
          let randomCharCode = Math.floor(Math.random() * 26) + 97;
          randomChar = String.fromCharCode(randomCharCode);
        } while (chars[midPos] == randomChar)

        chars[midPos] = randomChar;
        return chars.join("");
      },
      //str.len<=26
      splitString(str) {
        let words = str.split(" ");           //考虑到空格的情况，将str先按空格拆分
        let spaceCount = words.length - 1;
        if (str.length - spaceCount <= 6) {
          return str.split("");
        }
        let minChars = str.length - spaceCount <= 14 ? 1 : 2;               //str.len>14则最小的chars为2

        while (true) {
          let cells = [];
          let splitCount = Math.floor(Math.random() * 3) + 5;     //5~7
          words.forEach((word, index) => {
            let pos = 0;
            while (pos < word.length && splitCount != 0) {
              let charCount = Math.floor(Math.random() * 4) + minChars;
              let start = pos;
              let end = pos + charCount >= word.length ? word.length : pos + charCount;
              pos += charCount;
              splitCount--;
              cells.push(word.substring(start, end));
            }
            if (index != words.length - 1) {
              cells.push(" ");
            }
          });
          if (cells.join("") == str && cells[cells.length - 1].length <= minChars+2) {               //没有提前spilt并且split结束后的最后一个cell的字符数<=minChars+2
            return cells;
          }
        }
      }
    }
  }
</script>
<style>
  .el-progress-circle__track {
    stroke: transparent !important;
  }

  .el-progress__text {
    font-size: 1.2rem !important;
  }

  .el-progress-circle__path {
    stroke: #42b983;
  }
</style>
