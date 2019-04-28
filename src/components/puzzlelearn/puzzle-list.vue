<template>
  <div class="puzzleList">
    <div class="sk-three-bounce" v-if="dataLoading">
      <div class="sk-child sk-bounce1 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce2 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce3 matrix-learn__loading"></div>
    </div>
    <el-scrollbar class="puzzleList__scrollbar animated fadeIn" v-if="!dataLoading">
      <div class="puzzleList__inner">
        <div v-for="row in puzzles" class="puzzleList__row">
          <div v-for="puzzle in row" class="puzzleList__item" @click="enterPuzzle(puzzle)">
            <div class="pl-cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
              <div v-for="cell in puzzle.cells" :class="{'is-active':cell.isActive}" class="pl-cells__cell">
              </div>
            </div>
          </div>
        </div>
        <div class="puzzleList__item" v-if="puzzles.length==0" @click="createPuzzle()">
          <div class="pl-cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
            <div v-for="cell in demoCells" :class="{'is-active':cell.isActive}" class="pl-cells__cell">
            </div>
          </div>
        </div>
      </div>
    </el-scrollbar>
    <v-btn
      fab
      dark
      class="user-set__add-button mm-fab" @click="createPuzzle">
      <i class="ef-icon-add" style="font-size: 1.2rem"></i>
    </v-btn>
  </div>
</template>

<script>
  export default {
    name: "",
    data() {
      return {
        puzzles: [],
        size: 256,
        dataLoading: true,
        demoCells: []
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
            puzzle.isAdd = false;
          });
          let numsPerGroup = 1;
          this.puzzles = this.groupPuzzles(puzzles, numsPerGroup);
          this.makeDemoCells();
          setTimeout(() => {
            this.dataLoading = false;
          }, 200);
        })
      },
      makeDemoCells() {
        let cells = [], activeIndexes = [];
        let i = 39, j = 40, k = 114, m = 130;
        for (let t = 0; t < 12; t++) {
          activeIndexes.push(i, j);
          i += 16;
          j += 16;
        }
        for (let t = 0; t < 12; t++) {
          activeIndexes.push(k++, m++);
        }
        while (cells.length < this.size) {
          let isActive = activeIndexes.includes(cells.length);
          cells.push({
            p: cells.length,
            isActive: isActive,
          });
        }
        this.demoCells = cells;
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
            isActive: false,
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
          cells[p].isActive = true;
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
      createPuzzle() {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        this.$router.push({name: "createPuzzle", params: {uid: uid, sid: sid}});
      },
      enterPuzzle(puzzle) {
        let sid = this.$route.params.sid;
        let uid = this.$route.params.uid;
        this.$router.push({name: 'playPuzzle', params: {uid: uid, sid: sid, pid: puzzle.pid}})
      }
    }
  }
</script>
