<template>
  <div class="m-container">
    <div class="puzzle-container">
      <div class="cells-container" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
        <div style="position: absolute;width: 2rem;height: 2rem;background-color: #42b983;right: 5px;top: -3rem" @click="saveDataToServer"></div>
        <div class="cell" v-for="cell in cells" :class="{'is-active':cell.isActive}" @click="cellClick(cell)">
          <el-input maxlength="1" style="width: 100%;height: 100%" v-on:focus="inputFocus($event,cell)" v-model="cell.c"
                    ref="cells" @input="inputChange(cell)"></el-input>
          <div style="position: absolute;left: 0.1rem;top: 0.1rem">{{cell.h}}</div>
          <div style="position: absolute;left: 0.1rem;bottom: 0.1rem">{{cell.v}}</div>
        </div>
      </div>
    </div>
    <div class="list-container">
      <el-scrollbar style="width: 100%;height: 90%;">
        <el-row justify="center" type="flex" :gutter="20" style="width: 100%;padding-left: 10px;padding-right: 10px">
          <el-col v-for="cards in groupedCards" :span="Math.floor(24/listCol)"
                  style="display: flex;flex-direction: column">
            <div v-for="card in cards"
                 style="width: 100%;min-height: 12rem;margin-bottom: 20px;user-select: none;cursor: pointer;position: relative"
                 @click="markCells(card.index)">
              <div
                style="width: 100%;height: 100%;background-color: white;padding:2rem;border-radius: 10px;box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);color: gray;margin: 10px">
                <div style="width: 100%;height: fit-content;text-align: center;padding-bottom: 2rem;font-size: 1.5rem">
                  {{card.term}}
                </div>
                <div style="display: flex;justify-content: center;align-items: center;font-size: 1.2rem">
                  {{card.definition}}
                </div>
                <div style="position: absolute;right: 50%;bottom: 1rem;text-align: center;transform: translateX(50%)"
                     :class="{'is-selected':card.selected}">{{card.index}}
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </el-scrollbar>
    </div>
  </div>
</template>

<script>
  export default {
    name: "",
    data() {
      return {
        cells: [],
        vocabularies: [],
        cards: [],
        size: 256,
        lastCellClick: {},
        groupedCards: [],
        listCol: 3,
        orientation: {},
        lastInputChar: "",
        isKeyBoardFocus: false,           //key board event invoke focus
        curCell: {}             //for Arrow move
      }
    },
    created() {
      this.init();
      this.fetchData();
      this.onBindKey();
    },
    methods: {
      onBindKey() {
        document.onkeydown = (ev) => {
          this.isKeyBoardFocus = true;
          this.moveCell(this.curCell.p, ev.key);
        }
      },
      moveCell(pos, eventKey) {
        let rowSize = Math.sqrt(this.size);
        let pos_of_row = Math.floor(pos / rowSize);
        let pos_of_col = pos % rowSize;
        switch (eventKey) {
          case "ArrowUp":
            pos_of_row == 0 ? this.$refs.cells[this.size - rowSize + pos % rowSize].focus() : this.$refs.cells[pos - rowSize].focus();
            break;
          case "ArrowDown":
            pos_of_row == rowSize - 1 ? this.$refs.cells[pos % rowSize].focus() : this.$refs.cells[pos + rowSize].focus();
            break;
          case "ArrowLeft":
            pos_of_col == 0 ? this.$refs.cells[pos + rowSize - 1].focus() : this.$refs.cells[pos - 1].focus();
            break;
          case "ArrowRight":
            pos_of_col == rowSize - 1 ? this.$refs.cells[pos - rowSize + 1].focus() : this.$refs.cells[pos + 1].focus();
            break;
        }
      },
      groupCards(cards, groupCount) {
        let groupedCards = [];
        if (cards.length <= groupCount) {
          cards.forEach((card) => {
            groupedCards.push([card]);
          });
          return;
        }
        for (let i = 0; i < groupCount; i++) {
          let subArr = [];
          for (let j = i; j < cards.length; j += groupCount) {
            subArr.push(cards[j]);
          }
          groupedCards.push(subArr);
        }
        return groupedCards;
      },
      init() {
        let cells = [];
        this.orientation = {
          VERTICAL: 'vertical',
          HORIZONTAL: 'horizontal'
        }
        while (cells.length < this.size) {
          cells.push({
            c: "",     //char
            h: "",     //horizontal mark,mark 对应card的Id,-1代表没有
            v: "",     //vertical mark
            p: cells.length,
            isActive: false,
          });
        }
        this.cells = cells;
        this.curCell = this.cells[Math.floor(Math.random() * this.size)];
        this.lastCellClick = {
          p: -1,
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
          this.cards = res.data.vocabularies.sort((c1, c2) => {
            return c1.vid - c2.vid
          });
          this.cards.forEach((card, index) => {
            card.index = index + 1;
            card.selected = false;
          });
          this.groupedCards = this.groupCards(this.cards, this.listCol);
        });
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
      },
      inputChange(cell) {
        this.$refs.cells[cell.p].select();
        if (this.lastInputChar == "" || this.lastInputChar == cell.c || cell.c == "") {              //this.lastInputChar == cell.c是为了换方向
          this.cellClick(cell);
        }
        let rowSize = Math.sqrt(this.size);
        let pos_of_row = Math.floor(cell.p / rowSize);
        let pos_of_col = cell.p % rowSize;
        this.updateRowMarks(pos_of_row);
        this.updateColMarks(pos_of_col);
        this.updateCards();
        this.lastInputChar = cell.c;
      },
      cellClick(cell) {
        this.lastInputChar = cell.c;
        if (cell.c == "") {
          this.lastCellClick.p = -1;           //从没有填充到有填充规定为重新点击
          this.cells.forEach((cell) => {
            cell.isActive = false
          });
          return;
        }
        let rowSize = Math.sqrt(this.size);
        let farthestPos = this.getFarthestPos(cell);
        let isVerticalFill = (farthestPos.bottom - farthestPos.top > rowSize * 2);
        let isHorizontalFill = (farthestPos.right - farthestPos.left > 2);
        if (this.lastCellClick.p == cell.p && isHorizontalFill && isVerticalFill) {       //上下左右都有填充才能交换
          let isHorizontalActive = (this.cells[farthestPos.left + 1].isActive && this.cells[farthestPos.right - 1].isActive);
          this.cells.forEach((cell) => {
            cell.isActive = false
          });
          this.activeCells(cell, isHorizontalActive == true ? this.orientation.VERTICAL : this.orientation.HORIZONTAL);
        } else {
          if (isHorizontalFill || isVerticalFill) {
            this.cells.forEach((cell) => {
              cell.isActive = false
            });
            this.activeCells(cell, isHorizontalFill ? this.orientation.HORIZONTAL : this.orientation.VERTICAL);
          }
        }
        this.lastCellClick.p = cell.p;
      },
      activeCells(cell, orientation) {              //cells near focused and filled cell can be active
        let farthestPos = this.getFarthestPos(cell);
        let rowSize = Math.sqrt(this.size);
        if (orientation == this.orientation.VERTICAL) {
          for (let i = farthestPos.top + rowSize; i < farthestPos.bottom; i += rowSize) {
            this.cells[i].isActive = true;
          }
        } else {
          for (let i = farthestPos.left + 1; i < farthestPos.right; i++) {
            this.cells[i].isActive = true;
          }
        }
      },
      updateCards() {
        let markedIndexes = [];
        this.cells.forEach((cell) => {
          cell.h !== "" ? markedIndexes.push(cell.h) : null;
          cell.v !== "" ? markedIndexes.push(cell.v) : null;
        });
        console.log(markedIndexes);
        this.cards.forEach((card) => {
          markedIndexes.find((markIndex) => markIndex == card.index) != undefined ? card.selected = true : card.selected = false;
        });
      },
      updateRowMarks(row) {
        let rowSize = Math.sqrt(this.size);
        let cells = this.cells;
        for (let i = rowSize * row; i < rowSize * (row + 1); i++) {     //remove
          if (cells[i].c == "") {                  //如果没有填充，就清除标记
            cells[i].h = "";
            cells[i].v = "";
          } else {
            let leftCell = (i == rowSize * row) ? null : cells[i - 1];
            if (leftCell != null && leftCell.h != "" && leftCell.c != "") {
              cells[i].h = leftCell.h;
            } else {
              let j = i + 1;
              while (j < rowSize * (row + 1) && cells[j].c != "") {
                if (cells[j].h != "") {
                  cells[i].h = cells[j].h;
                  break;
                }
                j++;
              }
            }
          }
        }
        let markedIndexes = [];
        for (let i = rowSize * row; i < rowSize * (row + 1); i++) {                 //处理删除某个填充字符后，重复填充的问题
          if (cells[i].c != "") {
            markedIndexes.find((mIndex) => mIndex == cells[i].h) != undefined ? cells[i].h = "" : null;
          } else {
            (i != rowSize * row && cells[i - 1].h != "") ? markedIndexes.push(cells[i - 1].h) : null;
          }
        }

        for (let i = rowSize * row; i < rowSize * (row + 1); i++) {                 //处理孤立的又标注了的cell
          let isLeftEmpty = (i == rowSize * row || cells[i - 1].c == "");
          let isRightEmpty = (i == rowSize * (row + 1) - 1 || cells[i + 1].c == "");
          (isLeftEmpty && isRightEmpty) ? cells[i].h = "" : null;
        }
      },
      updateColMarks(col) {
        let rowSize = Math.sqrt(this.size);
        let cells = this.cells;
        for (let i = col; i <= rowSize * (rowSize - 1) + col; i += rowSize) {
          console.log(i);
          if (cells[i].c == "") {                  //如果没有填充，就清除标记
            cells[i].h = "";
            cells[i].v = "";
          } else {
            let topCell = (i == col) ? null : cells[i - rowSize];
            if (topCell != null && topCell.v != "" && topCell.c != "") {
              cells[i].v = topCell.v;
            } else {
              let j = i + rowSize;
              while (j <= rowSize * (rowSize - 1) + col && cells[j].c != "") {
                if (cells[j].v != "") {
                  cells[i].v = cells[j].v;
                  break;
                }
                j += rowSize;
              }
            }
          }
        }
        let markedIndexes = [];
        for (let i = col; i <= rowSize * (rowSize - 1) + col; i += rowSize) {                 //处理删除某个填充字符后，重复填充的问题
          if (cells[i].c != "") {
            markedIndexes.find((mIndex) => mIndex == cells[i].v) != undefined ? cells[i].v = "" : null;
          } else {
            (i != col && cells[i - rowSize].v != "") ? markedIndexes.push(cells[i - rowSize].v) : null;
          }
        }

        for (let i = col; i <= rowSize * (rowSize - 1) + col; i += rowSize) {            //处理孤立的又标注了的cell
          let isTopCellEmpty = (i == col || cells[i - rowSize].c == "") ? true : false;        //临界的top只判断bottom
          let isBottomCellEmpty = (i == rowSize * (rowSize - 1) + col || cells[i + rowSize].c == "") ? true : false;     //临界的bottom只判断top
          if (isTopCellEmpty && isBottomCellEmpty) {
            cells[i].v = "";
          }
        }
      },
      markCells(markIndex) {
        let activedCells = [];
        this.cells.forEach((cell) => {
          cell.isActive ? activedCells.push(cell) : null;
        });
        if (activedCells.length <= 1) {
          return;
        }
        this.cells.forEach((cell) => {
          cell.h == markIndex ? cell.h = "" : null;  //之前有cell标记为该index的就清除它的index
          cell.v == markIndex ? cell.v = "" : null;
        });
        let isHorizontal = (activedCells[1].p - activedCells[0].p == 1);
        activedCells.forEach((cell) => {
          isHorizontal ? cell.h = markIndex : cell.v = markIndex;
        });
        this.updateCards();
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
      saveDataToServer(){
        let c="𠮷";
        let h=5;
        let v=29;
        let p=99;
        let chvp=String.fromCodePoint(c.codePointAt(0),h,v,p);
        console.log(typeof chvp);
        for (let ch of chvp) {
          console.log(ch.codePointAt(0));
        }
        let puzzle={
          name:"test",
          intro:"aaa",
          sid:5,
          info:c
        }
        console.log(JSON.stringify(puzzle));
        this.axios.post("/api/puzzle/create",{
          puzzle:JSON.stringify(puzzle)
        }).then((res)=>{
          console.log(res.data);
        });
      },
    }
  }
</script>

<style scoped>
  .m-container {
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

  .puzzle-container {
    height: 100%;
    display: flex;
    align-items: center;
  }

  .list-container {
    height: 100%;
    display: flex;
    align-items: center;
    width: 40%;
  }

  .cells-container {
    --size: 3.8rem;
    width: fit-content;
    height: fit-content;
    display: grid;
    grid-template-columns: repeat(var(--row), var(--size));
    grid-template-rows: repeat(var(--column), var(--size));
    position: relative;
  }

  .cell {
    background-color: white;
    box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.10);
    border-radius: 3px;
    margin: 3px;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    color: gray;
    position: relative;
  }

  .is-active {
    background-color: lightgrey;
  }

  .is-selected {
    color: black;
    border: 1px solid black;
  }

  .col-box {

  }
</style>

<style>
  .el-input__inner {
    background-color: transparent;
    border: none;
    color: transparent;
    font-size: 1.5rem;
    text-shadow: 0 0 0 gray;
    width: 100%;
    height: 100%;
    text-align: center;
    cursor: default;
  }

  .el-input__inner:focus {
    background-color: #42b983;
  }

  .el-input__inner::selection {
    color: gray;
    background-color: transparent;
  }
</style>
