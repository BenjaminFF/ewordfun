<template>
  <div class="playPuzzle">
    <div class="playPuzzle__left">
      <el-scrollbar class="pp-scrollbar">
        <div v-for="card in vCards"
             class="pp-card"
             @click="activeCells(card.index,orientation.VERTICAL)">
          <div class="pp-card__inner">
            <div class="pp-card__definition">{{card.definition}}</div>
            <div :class="{'is-active':card.isActive}" class="pp-card__index">{{card.index}}</div>
          </div>
        </div>
      </el-scrollbar>
    </div>
    <div class="playPuzzle__middle">
      <div class="playPuzzle__cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
        <div class="cell-container" v-for="cell in cells" style="margin: 3px">
          <div class="cp-cell" style="width: 100%;height: 100%"
               :class="{'is-active':cell.isActive,'is-invisible':cell.invisible}" @click="cellClick(cell)">
            <el-input maxlength="1" class="cp-cell__input" v-on:focus="inputFocus($event,cell)" v-model="cell.c"
                      ref="cells" @input="inputChange(cell)" :disabled="cell.answerCorrect"></el-input>
            <div class="cp-cell__h">{{cell.h!=0&&cell.isHhead?cell.h:""}}</div>
            <div class="cp-cell__v">{{cell.v!=0&&cell.isVhead?cell.v:""}}</div>
          </div>
        </div>
      </div>
    </div>
    <div class="playPuzzle__right">
      <el-scrollbar class="pp-scrollbar">
        <div v-for="card in hCards"
             class="pp-card"
             @click="activeCells(card.index,orientation.HORIZONTAL)">
          <div class="pp-card__inner">
            <div style="font-size: 1.2rem;">{{card.definition}}</div>
            <div :class="{'is-active':card.isActive}" class="pp-card__index">{{card.index}}</div>
          </div>
        </div>
      </el-scrollbar>
    </div>
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
      }
    },
    created() {
      this.fetchData();
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
      initCards() {
        let vIndices = [], hIndices = [];
        let cards = this.vocabularies.sort((c1, c2) => {
          return c1.vid - c2.vid
        });
        cards.forEach((card, index) => {
          card.index = index + 1;
          card.isActive = false;
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
      },
      cellClick(cell) {
        let rowSize = Math.sqrt(this.size);
        if (cell.p == this.lastCellClick.p && cell.h != 0 && cell.v != 0) {
          let isHorizontalActive = (cell.p % rowSize != 0 && this.cells[cell.p - 1].isActive) || ((cell.p + 1) % rowSize != 0 && this.cells[cell.p + 1].isActive);
          this.activeCells(isHorizontalActive ? cell.v : cell.h, isHorizontalActive ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        } else {
          let hasHorizontal = (cell.p % rowSize != 0 && this.cells[cell.p - 1].h != 0) || ((cell.p + 1) % rowSize != 0 && this.cells[cell.p + 1].h != 0);
          this.activeCells(hasHorizontal ? cell.h : cell.v, !hasHorizontal ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        }
        this.lastCellClick.p = cell.p;
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
        if (this.isKeyBoardFocus) {
          this.cellClick(cell);
          this.isKeyBoardFocus = false;
        }
        this.$nextTick(() => {
          this.$refs.cells[cell.p].select();
        });
      },
      inputChange(cell) {
        this.$refs.cells[cell.p].select();
        let answer = "";
        let correctAnswer = this.cards.find((card) => card.isActive).term;
        for (let cell of this.cells) {
          cell.isActive ? answer += cell.c : null;
        }
        this.cells.forEach((cell) => {
          cell.isActive && answer == correctAnswer ? cell.answerCorrect = true : null;
          console.log(cell.answerCorrect);
        });
      }
    }
  }
</script>

<style scoped>

  .cell-container {
    width: auto;
    height: auto;
    position: relative;
  }

  .is-active {
    color: black;
  }


  .is-invisible {
    display: none;
  }
</style>
