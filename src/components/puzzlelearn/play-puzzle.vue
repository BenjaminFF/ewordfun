<template>
  <div class="play-puzzle">
    <div class="left-container"></div>
    <div class="middle-container">
      <div class="createPuzzle__cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
        <div class="cell-container" v-for="cell in cells" style="margin: 3px">
          <div class="cp-cell" style="width: 100%;height: 100%"
               :class="{'is-active':cell.isActive,'is-invisible':cell.invisible}" @click="cellClick(cell)">
            <el-input maxlength="1" class="cp-cell__input" v-on:focus="inputFocus($event,cell)" v-model="cell.c"
                      ref="cells" @input="inputChange(cell)"></el-input>
            <div class="cp-cell__h">{{cell.h!=0?cell.h:""}}</div>
            <div class="cp-cell__v">{{cell.v!=0?cell.v:""}}</div>
          </div>
        </div>
      </div>
    </div>
    <div class="right-container"></div>
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
            invisible: true
          });
        }
        let chvps = puzzleData.split(",");
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
        })
        this.cells = cells;
        console.log(this.cells);
      },
      initCards() {
        this.cells.forEach((cell) => {

        });
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
          console.log(res.data);
        });
      },
      getFarthestPos(cell) {             //get the cell's farthest left, right, top, bottom.
        let rowSize = Math.sqrt(this.size);
        let pos_of_row = Math.floor(cell.p / rowSize);
        let pos_of_col = cell.p % rowSize;
        let left, right, top, bottom;
        left = right = top = bottom = cell.p;
        let fl = pos_of_row * rowSize, fr = rowSize * (pos_of_row + 1), ft = pos_of_col,
          fb = (rowSize * rowSize - 1) + pos_of_col;
        while (left >= fl && this.cells[left].c != "") {
          left--;
        }
        while (right < fr && this.cells[right].c != "") {
          right++;
        }
        while (top >= ft && this.cells[top].c != "") {
          top -= rowSize;
        }
        while (bottom <= fb && this.cells[bottom].c != "") {
          bottom += rowSize;
        }
        return {top, bottom, left, right};
      },
      cellClick(cell) {
        let rowSize = Math.sqrt(this.size);
        if (cell.p == this.lastCellClick.p && cell.h != 0 && cell.v != 0) {
          let isHorizontalActive = (cell.p % rowSize != 0 && this.cells[cell.p - 1].isActive) || ((cell.p + 1) % rowSize != 0 && this.cells[cell.p + 1].isActive);
          this.activeCells(cell, isHorizontalActive == true ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        } else {
          let hasHorizontal = (cell.p % rowSize != 0 && this.cells[cell.p - 1].h != 0) || ((cell.p + 1) % rowSize != 0 && this.cells[cell.p + 1].h != 0);
          this.activeCells(cell, hasHorizontal == false ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        }
        this.lastCellClick.p = cell.p;
      },
      activeCells(cell, orientation) {              //cells near focused and filled cell can be active
        let rowSize = Math.sqrt(this.size);
        if (orientation == this.orientation.VERTICAL) {
          this.cells.forEach((mCell) => {
            if (!cell.invisible) {
              mCell.v == cell.v ? mCell.isActive = true : mCell.isActive = false;
            }
          });
        } else {
          this.cells.forEach((mCell) => {
            if (!cell.invisible) {
              mCell.h == cell.h ? mCell.isActive = true : mCell.isActive = false;
            }
          });
        }
      },
      inputFocus(event, cell) {
        this.curCell = cell;
        if (this.isKeyBoardFocus) {
          this.cellClick(cell);
          this.isKeyBoardFocus = false;
        }
        this.$nextTick(() => {
          this.$refs.cells[cell.p].select();
        });
      }
    }
  }
</script>

<style scoped>
  .play-puzzle {
    background-color: #f0f0f0;
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    display: flex;
    align-items: center;
    justify-content: space-evenly;
  }

  .left-container {
    flex: 1 0 0;
  }

  .middle-container {
    flex: 8 0 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .right-container {
    flex: 1 0 0;
  }

  .cell-container {
    width: auto;
    height: auto;
    position: relative;
  }


  .is-invisible {
    display: none;
  }
</style>
