<template>
  <div class="createPuzzle">
    <div class="sk-three-bounce" v-if="dataLoading">
      <div class="sk-child sk-bounce1 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce2 matrix-learn__loading"></div>
      <div class="sk-child sk-bounce3 matrix-learn__loading"></div>
    </div>
    <div style="height: 100%;display: flex;align-items: center;" v-if="!dataLoading" class="animated fadeIn">
      <div class="createPuzzle__cells" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
        <div class="cp-cell" v-for="cell in cells" :class="{'is-active':cell.isActive}" @click="cellClick(cell)">
          <el-input maxlength="1" class="cp-cell__input" v-on:focus="inputFocus($event,cell)" v-model="cell.c"
                    ref="cells" @input="inputChange(cell)"></el-input>
          <div class="cp-cell__h">{{cell.h!=0?cell.h:""}}</div>
          <div class="cp-cell__v">{{cell.v!=0?cell.v:""}}</div>
        </div>
      </div>
    </div>
    <div class="createPuzzle__setList animated fadeIn" v-if="!dataLoading">
      <el-scrollbar>
        <el-row justify="center" type="flex" :gutter="20">
          <el-col v-for="cards in groupedCards" :span="Math.floor(24/listCol)"
                  style="display: flex;flex-direction: column">
            <div v-for="card in cards"
                 class="cp-card"
                 @click="markCells(card.index)">
              <div class="cp-card__inner">
                <div class="cp-card__term">
                  {{card.term}}
                </div>
                <div class="cp-card__definition">
                  {{card.definition}}
                </div>
                <div :class="{'is-selected':card.selected}" class="cp-card__index">
                  {{card.index}}
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </el-scrollbar>
    </div>
    <span class="l-create-set__confirm-fab animated fadeIn" @mouseover="confirmHovered=true" @mouseleave="confirmHovered=false"
          :class="[{'animated tada':confirmHovered}]" @click="openDialog" v-if="!dataLoading">
        <i class="ef-icon-tick"></i>
      </span>
    <el-dialog
      :title="$t('createDialog.header')"
      :center="true"
      :visible.sync="dialogVisible"
      :modal-append-to-body="false"
      :custom-class="'cs-dialog'"
      width="20%">
      <el-form :rules="rules" :model="puzzleInfo" ref="createSetForm">
        <el-form-item prop="name">
          <el-input :placeholder="$t('createDialog.name')" style="font-size: 1.5rem" v-model="puzzleInfo.name" maxlength="32"></el-input>
        </el-form-item>
        <el-form-item prop="intro">
          <el-input type="textarea" min-row resize="none" :autosize="{ minRows: 8, maxRows: 8 }" :placeholder="$t('createDialog.introduction')"
                    style="font-size: 1.2rem;margin-top: 1rem" v-model="puzzleInfo.intro"  maxlength="200"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button style="width: 100%;margin-top: 2rem;" type="primary" @click="submitForm('createSetForm')">{{$t('createDialog.submit')}}</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
    <i class="createPuzzle__return ef-icon-return" @click="compReturn"></i>
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
        curCell: {},             //for Arrow move
        confirmHovered:false,
        dialogVisible:false,
        puzzleInfo:{},
        dataLoading:true
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
            h: 0,     //horizontal mark,mark 对应card的Id,0代表没有
            v: 0,     //vertical mark
            p: cells.length,
            isActive: false,
          });
        }
        this.cells = cells;
        this.curCell = this.cells[Math.floor(Math.random() * this.size)];
        this.lastCellClick = {
          p: -1,
        }
        let sid = this.$route.params.sid;
        this.puzzleInfo={
          name:"",
          intro:"",
          chvps:"",
          puzzle_progress:"",
          sid:sid
        }
        this.rules={
          name:[
            { required: true, message: this.$t('createDialog.nameEmpty'), trigger: 'blur' },
          ]
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
          setTimeout(()=>{
            this.dataLoading=false;
          },200);
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
          cell.h !== 0 ? markedIndexes.push(cell.h) : null;
          cell.v !== 0 ? markedIndexes.push(cell.v) : null;
        });
        this.cards.forEach((card) => {
          markedIndexes.find((markIndex) => markIndex == card.index) != undefined ? card.selected = true : card.selected = false;
        });
      },
      updateRowMarks(row) {
        let rowSize = Math.sqrt(this.size);
        let cells = this.cells;
        for (let i = rowSize * row; i < rowSize * (row + 1); i++) {     //remove
          if (cells[i].c == "") {                  //如果没有填充，就清除标记
            cells[i].h = 0;
            cells[i].v = 0;
          } else {
            let leftCell = (i == rowSize * row) ? null : cells[i - 1];
            if (leftCell != null && leftCell.h != 0 && leftCell.c != "") {
              cells[i].h = leftCell.h;
            } else {
              let j = i + 1;
              while (j < rowSize * (row + 1) && cells[j].c != "") {
                if (cells[j].h != 0) {
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
            markedIndexes.find((mIndex) => mIndex == cells[i].h) != undefined ? cells[i].h = 0 : null;
          } else {
            (i != rowSize * row && cells[i - 1].h != 0) ? markedIndexes.push(cells[i - 1].h) : null;
          }
        }

        for (let i = rowSize * row; i < rowSize * (row + 1); i++) {                 //处理孤立的又标注了的cell
          let isLeftEmpty = (i == rowSize * row || cells[i - 1].c == "");
          let isRightEmpty = (i == rowSize * (row + 1) - 1 || cells[i + 1].c == "");
          (isLeftEmpty && isRightEmpty) ? cells[i].h = 0 : null;
        }
      },
      updateColMarks(col) {
        let rowSize = Math.sqrt(this.size);
        let cells = this.cells;
        for (let i = col; i <= rowSize * (rowSize - 1) + col; i += rowSize) {
          console.log(i);
          if (cells[i].c == "") {                  //如果没有填充，就清除标记
            cells[i].h = 0;
            cells[i].v = 0;
          } else {
            let topCell = (i == col) ? null : cells[i - rowSize];
            if (topCell != null && topCell.v != 0 && topCell.c != "") {
              cells[i].v = topCell.v;
            } else {
              let j = i + rowSize;
              while (j <= rowSize * (rowSize - 1) + col && cells[j].c != "") {
                if (cells[j].v != 0) {
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
            markedIndexes.find((mIndex) => mIndex == cells[i].v) != undefined ? cells[i].v = 0 : null;
          } else {
            (i != col && cells[i - rowSize].v != 0) ? markedIndexes.push(cells[i - rowSize].v) : null;
          }
        }

        for (let i = col; i <= rowSize * (rowSize - 1) + col; i += rowSize) {            //处理孤立的又标注了的cell
          let isTopCellEmpty = (i == col || cells[i - rowSize].c == "") ? true : false;        //临界的top只判断bottom
          let isBottomCellEmpty = (i == rowSize * (rowSize - 1) + col || cells[i + rowSize].c == "") ? true : false;     //临界的bottom只判断top
          if (isTopCellEmpty && isBottomCellEmpty) {
            cells[i].v = 0;
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
          cell.h == markIndex ? cell.h = 0 : null;  //之前有cell标记为该index的就清除它的index
          cell.v == markIndex ? cell.v = 0 : null;
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
      openDialog(){
        let markedCards=this.cards.filter((card)=>card.selected==true);
        if(markedCards.length<=2){
          this.$message({
            message: '请标记至少3个卡片',
            type: 'warning'
          });
          return;
        }
        for(let cell of this.cells){
          if(cell.h==""&&cell.v==""&&cell.c!=""){
            this.$message({
              message: '请将所有字符标号',
              type: 'warning'
            });
            return;
          }
        }
        let chvps="";
        let puzzle_progress="";
        for(let cell of this.cells){
          if(cell.h==""&&cell.v==""&&cell.c!=""){
            this.$message({
              message: '请将所有字符标号',
              type: 'warning'
            });
            return;
          }else if(cell.c!=""){
            let h=cell.h>16?cell.h.toString(16):0+cell.h.toString(16);
            let v=cell.v>16?cell.v.toString(16):0+cell.v.toString(16);
            let p=cell.p>16?cell.p.toString(16):0+cell.p.toString(16);
            let chvp=cell.c+h+v+p;
            chvps+=chvp+",";
            puzzle_progress+="?"+h+v+p+",";          //progress中的字符用“？”表示
          }
        }
        this.puzzleInfo.chvps=chvps.substring(0,puzzle_progress.length-1);
        this.puzzleInfo.puzzle_progress=puzzle_progress.substring(0,puzzle_progress.length-1);
        this.dialogVisible=true;
      },
      submitForm(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.axios.post("/api/puzzle/create",{puzzle:JSON.stringify(this.puzzleInfo)});
            this.$message({
              message: '创建成功',
              type: 'success'
            });
            this.$router.go(-1);
          } else {
            return false;
          }
        });
      },
      compReturn(){
        this.$router.go(-1);
        //this.saveTempData();
      },
    }
  }
</script>
