<template>
  <div class="matrix-learn">
    <div class="matrix-learn__inner">
      <div class="matrix-learn__controlBar">
        <v-btn icon style="font-size:inherit;cursor: pointer;color: inherit" @click="routerGo('-1')">
          <i class="ef-icon-cross" style="color: inherit"></i>
        </v-btn>
        <div class="ml-progress">
          <div class="ml-progress__inner"></div>
        </div>
        <div style="margin-left: 1rem;color: inherit">{{progress.cur+'/'+progress.total}}</div>
      </div>
      <div class="ml-underlines">
        <div class="ml-underlines__underline" v-for="underline in curCard.underlines"
             :class="{
             'is-active':underline.isActive,
             'is-space':underline.isSpace,
              'is-error':bottomBar.answerError,
             'is-success':bottomBar.answerSuccess,
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
               'is-error':bottomBar.answerError&&cell.isActive,
               'is-success':bottomBar.answerSuccess&&cell.isActive,
               }">
            {{cell.text}}
          </div>
        </div>
      </div>
    </div>
    <el-row class="ml-bottom-bar" :class="{'is-error':bottomBar.answerError,'is-success':bottomBar.answerSuccess}">
      <el-col :span="12" style="display: flex;justify-content: center;align-items: center;height: 100%">
        <div class="ml-bottom-bar__button" @click="skipCard"
             :class="{'is-invisible':bottomBar.answerSuccess||bottomBar.answerError}">跳过
        </div>
        <div style="width: fit-content;position: absolute;display: flex"
             v-if="bottomBar.answerSuccess||bottomBar.answerError">
          <i class="ml-bottom-bar__info-icon animated zoomIn faster"
             :class="{
             'is-error':bottomBar.answerError,
             'is-success':bottomBar.answerSuccess,
             'ef-icon-error':bottomBar.answerError,
             'ef-icon-success':bottomBar.answerSuccess
             }"></i>
          <div class="ml-bottom-bar__info-text is-error" v-if="bottomBar.answerError">
            正确答案
            <div>{{curCard.term}}</div>
          </div>
        </div>
      </el-col>
      <el-col :span="12" style="display: flex;justify-content: center;align-items: center;height: 100%">
        <div class="ml-bottom-bar__button" @click="checkAnswer"
             :class="{'is-error':bottomBar.answerError,'is-success':bottomBar.answerSuccess}">{{bottomBar.checkText}}
        </div>
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
        vocabularies: [],
        set: {},
        curCard: {},
        progress: {},
        curCards: [],
        unPassedCards: [],
        bottomBar: {}
      }
    },
    created() {
      this.init();
      this.fetchData();
    },
    methods: {
      init() {
        this.progress = {
          cur: "",
          total: ""
        }
        this.bottomBar = {
          answerSuccess: false,
          answerError: false,
          checkText: "检查"
        }
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
          this.curCards = this.vocabularies.filter((vocabulary) => vocabulary.rmatrix == 0);
          this.curCards.forEach((card) => {
            let splitStrs = this.splitString(card.term);
            let matrixCells = [...splitStrs].filter((str) => str != " ");
            while (matrixCells.length < 9) {
              let randomChars = splitStrs[Math.floor(Math.random() * splitStrs.length)];
              matrixCells.push(this.mixStr(randomChars));
            }
            Vue.set(card, "splitStrs", splitStrs);
            Vue.set(card, "matrixCells", _.shuffle(matrixCells));
          });

          this.progress = {
            cur: 1,
            total: this.curCards.length
          }
          this.setCurCard(this.curCards[0]);
        });
      },
      routerGo(step) {
        this.$router.go(step);
      },
      setCurCard(card) {
        this.curCard = card;
        let matrixCells = [];
        let underLines = [];
        card.matrixCells.forEach((cellText) => {
          matrixCells.push({
            text: cellText,
            isActive: false
          })
        });
        card.splitStrs.forEach((str) => {
          let isSpace = false;
          if (str == " ") {
            isSpace = true;
          }
          underLines.push({
            isActive: false,
            text: "",
            isSpace: isSpace
          })
        })
        this.curCard.matrixCells = matrixCells;
        Vue.set(this.curCard, "underlines", underLines);
        Vue.set(this.curCard, "curPos", 0);
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
        let words = str.split(" ");
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
              let charCount = Math.floor(Math.random() * 3) + minChars;
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
          if (cells.join("") == str && cells[cells.length - 1].length <= 3) {               //没有提前spilt并且split结束后的最后一个cell的字符数<=3
            return cells;
          }
        }

      },
      activeMatrixCell(cell) {
        if (!cell.isActive && this.curCard.curPos <= this.curCard.underlines.length - 1) {
          cell.isActive = true;
          let underlines = this.curCard.underlines;
          let curPos = this.curCard.curPos;
          if (underlines[curPos].isSpace) {
            underlines[curPos].text = " ";          //空格也要填，好判断
            underlines[curPos + 1].isActive = true;
            underlines[curPos + 1].text = cell.text;
            this.curCard.curPos += 2;
          } else {
            underlines[curPos].isActive = true;
            underlines[curPos].text = cell.text;
            this.curCard.curPos++;
          }
        }
      },
      checkAnswer() {
        console.log(this.curCard.term);
        let answer = "";
        this.curCard.underlines.forEach((underline) => {
          answer += underline.text;
        });
        if (this.curCard.term == answer) {
          this.bottomBar.answerSuccess = true;
        } else {
          this.bottomBar.answerError = true;
        }
        this.bottomBar.checkText = "继续";
      },
      skipCard() {

      }
    }
  }
</script>
