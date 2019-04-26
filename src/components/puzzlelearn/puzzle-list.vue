<template>
  <div class="puzzle-list">
    <el-scrollbar class="list-scrollbar">
      <div style="display: flex;align-items: center;flex-direction: column;width: 100%">
        <div class="p-row" v-for="row in puzzles">
          <div v-for="puzzle in row" class="puzzle">
            <div class="createPuzzle__cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}" style="'--size':1rem">
              <div class="cell-container" v-for="cell in puzzle.cells" style="margin: 3px">
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-scrollbar>
  </div>
</template>

<script>
  export default {
    name: "",
    data() {
      return {
        puzzles: [],
        size: 256,
      }
    },
    created() {
      this.fetchData();
    },
    methods: {
      init() {

      },
      fetchData() {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        this.axios.get('/api/puzzle/list_of_user', {
          params: {
            uid: uid
          }
        }).then((res) => {
          let puzzles = res.data.filter((puzzle) => puzzle.sid == sid);
          //let puzzles = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          puzzles.forEach((puzzle) => {
            puzzle.cells = this.restoreCells(puzzle.puzzle_progress);
          });
          let numsPerGroup = 3;
          this.puzzles = this.groupPuzzles(puzzles, numsPerGroup);
          console.log(this.puzzles);
        })
      },
      restoreCells(puzzleData) {
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
            invisible: true,
            isHhead: false,
            isVhead: false,
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
        return cells;
      },
      groupPuzzles(cards, numsPerGroup) {
        let groupedCards = [];
        let m = 0;
        while (m < cards.length && numsPerGroup > 0) {
          let sliceCount = numsPerGroup < cards.length - m ? numsPerGroup : cards.length - m;
          groupedCards.push(cards.slice(m, m + sliceCount));
          m += sliceCount;
        }
        console.log(2);
        return groupedCards;
      },
    }
  }
</script>

<style scoped>
  .puzzle-list {
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    overflow: hidden;
    background-color: #f0f0f0;
    display: flex;
    align-items: center;
  }

  .p-row {
    display: flex;
  }

  .puzzle {
    width: 25rem;
    height: 25rem;
    background-color: white;
    margin: 10px;
    flex-grow: 0;
    flex-shrink: 0;
  }
</style>

<style>
  .list-scrollbar {
    width: 100%;
    height: 90%;
  }

  .list-scrollbar .el-scrollbar__wrap {
    overflow-x: hidden;
  }
</style>
