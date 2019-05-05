<template>
  <div class="playPuzzle">
    <div class="sk-three-bounce" v-if="dataLoading">
      <div class="sk-child sk-bounce1 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce2 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce3 matrix-learn__loading"></div>
    </div>
    <div class="playPuzzle__left animated fadeIn" v-if="!dataLoading">
      <el-scrollbar class="pp-scrollbar">
        <div v-for="card in vCards"
             class="pp-card"
             @click="activeCells(card.index,orientation.VERTICAL)">
          <div class="pp-card__inner" :class="{'is-active':card.isActive,'is-success':card.isSuccess}">
            <div class="pp-card__definition">{{card.definition}}</div>
            <div class="pp-card__index">{{card.index}}</div>
          </div>
        </div>
      </el-scrollbar>
    </div>
    <div class="playPuzzle__middle animated fadeIn" v-if="!dataLoading">
      <div class="playPuzzle__cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
        <div class="pp-cell" v-for="cell in cells">
          <div class="pp-cell__inner"
               :class="{'is-active':cell.isActive,'is-invisible':cell.invisible,'is-success':cell.answerCorrect}"
               @click="cellClick(cell)">
            <el-input maxlength="1" class="pp-cell__input" v-on:focus="inputFocus($event,cell)" v-model="cell.c"
                      ref="cells" @input="inputChange(cell)" :disabled="cell.invisible"
                      :class="{'is-invisible':cell.invisible}"
            ></el-input>
            <div class="cp-cell__h">{{cell.h!=0&&cell.isHhead?cell.h:""}}</div>
            <div class="cp-cell__v">{{cell.v!=0&&cell.isVhead?cell.v:""}}</div>
          </div>
        </div>
      </div>
    </div>
    <div class="playPuzzle__right animated fadeIn" v-if="!dataLoading">
      <el-scrollbar class="pp-scrollbar">
        <div v-for="card in hCards"
             class="pp-card"
             @click="activeCells(card.index,orientation.HORIZONTAL)">
          <div class="pp-card__inner" :class="{'is-active':card.isActive,'is-success':card.isSuccess}">
            <div class="pp-card__definition">{{card.definition}}</div>
            <div :class="{'is-active':card.isActive}" class="pp-card__index">{{card.index}}</div>
          </div>
        </div>
      </el-scrollbar>
    </div>
    <i class="playPuzzle__return ef-icon-return" @click="compReturn"></i>
    <el-dialog
      title="你已完成了，是否再来一次？"
      :center="true"
      :visible.sync="dialogVisible"
      :modal-append-to-body="false"
      width="20%">
      <div slot="footer" class="dialog-footer">
        <el-button @click="outerVisible = false">取 消</el-button>
        <el-button type="primary" @click="innerVisible = true">打开内层 Dialog</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: "play_puzzle",
    data() {
      return {
        size: 256,
        cells: [],
        vocabularies: [],
        puzzleInfo: {},
        lastCellClick: {},
        orientation: {},
        cards: [],
        vCards: [],               //vertical cards
        hCards: [],                //horizontal cards
        dataLoading: true,
        allSuccess: false
      }
    },
    created() {
      this.fetchData();
      //close or flush browser save the data to server
      window.onbeforeunload = (e) => {
        if (this.$route.name == 'playPuzzle') {
          this.update2Server();
        } else {
          window.onbeforeunload = null;
        }
      };
    },
    methods: {
      init() {

      },
      initCells(puzzleData) {
        let cells = [];
        this.orientation = {
          VERTICAL: 'vertical',
          HORIZONTAL: 'horizontal'
        }
        while (cells.length < this.size) {
          cells.push({
            c: "",     //char
            h: 0,     //horizontal mark,mark 对应card的Id,0代表没有
            v: 0,     //vertical mark
            p: cells.length,
            isActive: false,
            invisible: true,
            isHhead: false,
            isVhead: false,
            answerCorrect: false        //当这个术语成功
          });
        }
        let chvps = puzzleData.split(",");
        let hHeadIndices = [], vHeadIndices = [];
        chvps.forEach((chvp) => {
          let c = chvp.length == 7 ? chvp.substring(0, 1) : chvp.substring(0, 2);
          let hvp = chvp.length == 7 ? chvp.substring(1, 7) : chvp.substring(2, 8);
          let h = parseInt(hvp.substring(0, 2), 16);
          let v = parseInt(hvp.substring(2, 4), 16);
          let p = parseInt(hvp.substring(4, 6), 16);
          cells[p].c = (c == '?') ? "" : c;
          cells[p].h = h;
          cells[p].v = v;
          cells[p].invisible = false;
          !hHeadIndices.includes(h) && h != 0 ? (cells[p].isHhead = true, hHeadIndices.push(h)) : null;
          !vHeadIndices.includes(v) && v != 0 ? (cells[p].isVhead = true, vHeadIndices.push(v)) : null;
        })
        this.cells = cells;
      },
      updateCellState(cells) {
        let mMap = new Map();
        let mCells = cells.filter((cell) => !cell.invisible);
        mCells.forEach((cell) => {
          if (cell.h != 0) {
            let value = mMap.get(cell.h);
            value != undefined ? mMap.set(cell.h, value += cell.c) : mMap.set(cell.h, cell.c);
          }
          if (cell.v != 0) {
            let value = mMap.get(cell.v);
            value != undefined ? mMap.set(cell.v, value += cell.c) : mMap.set(cell.v, cell.c);
          }
        })
        for (let [key, value] of mMap) {
          if (value == this.cards.find((card) => card.index == key).term) {
            mCells.forEach((cell) => {
              cell.h == key || cell.v == key ? cell.answerCorrect = true : null;
            })
          }
        }
      },
      initCards() {
        let vIndices = [], hIndices = [];
        let cards = this.vocabularies.sort((c1, c2) => {
          return c1.vid - c2.vid
        });
        cards.forEach((card, index) => {
          card.index = index + 1;
          card.isActive = false;
          card.isSuccess = false;
        });
        this.cells.forEach((cell) => {
          if (!cell.invisible) {
            !vIndices.includes(cell.v) && cell.v != 0 ? vIndices.push(cell.v) : null;
            !hIndices.includes(cell.h) && cell.h != 0 ? hIndices.push(cell.h) : null;
          }
        });
        cards.forEach((card) => {
          vIndices.includes(card.index) ? this.vCards.push(card) : null;
          hIndices.includes(card.index) ? this.hCards.push(card) : null;
        });
        this.cards = cards;
      },
      async fetchData() {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        let pid = this.$route.params.pid;
        await this.axios.get('/api/puzzle/list_of_user', {
          params: {
            uid: uid
          }
        }).then((res) => {
          let puzzles = res.data;
          this.puzzleInfo = puzzles.find((puzzle) => puzzle.pid == pid && puzzle.sid == sid);
          this.initCells(this.puzzleInfo.puzzle_progress);
        });
        await this.axios.get('/api/set/acquire', {
          params: {
            uid: uid,
            sid: sid
          }
        }).then((res) => {
          this.vocabularies = res.data.vocabularies;
        });
        this.initCards();
        this.updateCellState(this.cells);
        setTimeout(() => {
          this.dataLoading = false;
        }, 100);
      },
      cellClick(cell) {
        if (cell.invisible || cell.answerCorrect) {
          return;
        }
        let rowSize = Math.sqrt(this.size);
        if (cell.p == this.lastCellClick.p && cell.h != 0 && cell.v != 0) {
          let isHorizontalActive = (cell.p % rowSize != 0 && this.cells[cell.p - 1].isActive) || ((cell.p + 1) % rowSize != 0 && this.cells[cell.p + 1].isActive);
          this.activeCells(isHorizontalActive ? cell.v : cell.h, isHorizontalActive ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        } else {
          let hasHorizontal = (cell.p % rowSize != 0 && this.cells[cell.p - 1].h != 0) || ((cell.p + 1) % rowSize != 0 && this.cells[cell.p + 1].h != 0);
          this.activeCells(hasHorizontal ? cell.h : cell.v, !hasHorizontal ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        }
        this.lastCellClick.p = cell.p;
        this.$nextTick(() => {
          this.$refs.cells[cell.p].select();
        });
      },
      activeCells(activeIndex, orientation) {
        let rowSize = Math.sqrt(this.size);
        this.cards.forEach((card) => {
          card.index == activeIndex ? card.isActive = true : card.isActive = false;
        })
        if (orientation == this.orientation.VERTICAL) {
          this.cells.forEach((mCell) => {
            if (!mCell.invisible) {
              mCell.v == activeIndex ? mCell.isActive = true : mCell.isActive = false;
            }
          });
        } else {
          this.cells.forEach((mCell) => {
            if (!mCell.invisible) {
              mCell.h == activeIndex ? mCell.isActive = true : mCell.isActive = false;
            }
          });
        }
      },
      inputFocus(event, cell) {
        if (cell.invisible || cell.answerCorrect) {
          return false;
        }
        if (this.isKeyBoardFocus) {
          this.cellClick(cell);
          this.isKeyBoardFocus = false;
        }
        this.$nextTick(() => {
          this.$refs.cells[cell.p].select();
        });
      },
      inputChange(cell) {
        if (cell.invisible || cell.answerCorrect) {
          return false;
        }
        this.$refs.cells[cell.p].select();
        let answer = "";
        let correctAnswer = this.cards.find((card) => card.isActive).term;
        for (let cell of this.cells) {
          cell.isActive ? answer += cell.c : null;
        }
        if (correctAnswer == answer) {
          let activeCells = this.cells.filter((cell) => cell.isActive);
          activeCells.forEach((cell) => cell.answerCorrect = true);
          activeCells[1].p - activeCells[0].p == 1 ? this.hCards.find((card) => card.index == activeCells[0].h).isSuccess = true :
            this.vCards.find((card) => card.index == activeCells[0].v).isSuccess = true;
          this.allSuccess = (this.cards.filter((card) => card.isSuccess).length == this.hCards.length + this.vCards.length);
        }
        this.cells.forEach((cell) => {
          cell.isActive && answer == correctAnswer ? cell.answerCorrect = true : null;
        });
      },
      compReturn() {
        this.$router.go(-1);
        this.update2Server();
      },
      //返回、答对一个、刷新更新.
      update2Server() {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        let pid = this.$route.params.pid;
        let puzzle_progress = "";
        this.cells.forEach((cell) => {
          if (!cell.invisible) {
            let h = cell.h > 16 ? cell.h.toString(16) : 0 + cell.h.toString(16);
            let v = cell.v > 16 ? cell.v.toString(16) : 0 + cell.v.toString(16);
            let p = cell.p > 16 ? cell.p.toString(16) : 0 + cell.p.toString(16);
            cell.c == "" ? puzzle_progress += "?" : puzzle_progress += cell.c;
            puzzle_progress += h + v + p + ",";          //progress中的字符用“？”表示
          }
        });
        this.axios.post("/api/puzzle/updateProgress", {
          puzzleInfo: JSON.stringify({
            sid: sid,
            uid: uid,
            pid: pid,
            puzzle_progress: puzzle_progress.substring(0, puzzle_progress.length - 1)
          })
        });
      }
    }
  }
</script>
