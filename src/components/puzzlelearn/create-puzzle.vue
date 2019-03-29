<template>
  <div class="m-container">
    <div class="puzzle-container">
      <div class="cells-container" :style="{'--row':Math.sqrt(size),'--column':Math.sqrt(size)}">
        <div style="position: absolute;width: 2rem;height: 2rem;background-color: #42b983;right: 5px;top: -3rem"></div>
        <div class="cell" v-for="cell in cells" :class="{'is-active':cell.isActive}" @click="cellClick(cell)">
          <el-input maxlength="1" style="width: 100%;height: 100%" v-on:focus="inputFocus($event,cell)" v-model="cell.c" @input="inputChange(cell)" ref="cells" v-on:blur="inputBlur"></el-input>
        </div>
      </div>
    </div>
    <div class="list-container">
      <el-scrollbar style="width: 90%;height: 90%;">
        <el-row justify="center" type="flex" :gutter="20" style="width: 100%">
          <el-col v-for="cards in groupedCards" :span="Math.floor(24/listCol)" style="display: flex;flex-direction: column">
            <div v-for="card in cards" style="width: 100%;min-height: 20rem;margin-bottom: 20px;">
              <div style="width: 100%;height: 100%;background-color: white;padding:2rem;border-radius: 10px;box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.11);color: gray">
                <div style="width: 100%;height: fit-content;text-align: center;padding-bottom: 2rem;font-size: 2rem">{{card.term}}</div>
                <div style="display: flex;justify-content: center;align-items: center;font-size: 1.5rem">{{card.definition}}</div>
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
        vocabularies:[],
        cards:[],
        size:169,
        lastCellClick:{},
        groupedCards:[],
        listCol:2
      }
    },
    created() {
      this.init();
      this.fetchData();
      this.onBindKey();
    },
    methods: {
      onBindKey(){
        document.onkeyup=(ev)=>{
          let cell=this.getFocusCell();
          console.log(cell);
          if(ev.key=='ArrowUp'){
          }
        }
      },
      getFocusCell(){
        return this.cells.filter((cell)=>cell.focused)[0];
      },
      groupCards(cards,groupCount){
        let groupedCards=[];
        if(cards.length<=groupCount){
          cards.forEach((card)=>{
            groupedCards.push([card]);
          });
          return;
        }
        for(let i=0;i<groupCount;i++){
          let subArr=[];
          for(let j=i;j<cards.length;j+=groupCount){
            subArr.push(cards[j]);
          }
          groupedCards.push(subArr);
        }
        return groupedCards;
      },
      init() {
        let cells = [];
        while (cells.length < this.size) {
          cells.push({
            c: "",     //char
            h: 0,     //horizontal mark,mark 对应card的Id,0代表没有
            v: 0,     //vertical mark
            p: cells.length,
            isActive:false,
            focused:false
          });
        }
        this.cells = cells;
        this.lastCellClick={
          p:-1,
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
          this.cards=res.data.vocabularies;
          this.groupedCards=this.groupCards(this.cards,this.listCol);
        });
      },
      inputFocus(event,cell) {
        event.target.setSelectionRange(0,1);
        cell.focused=true;
      },
      inputBlur(){
        this.cells.forEach((cell)=>{
          cell.isActive=false;
          cell.focused=false;
        })
      },
      inputChange(cell){
        cell.c=cell.c.trim();     //输入空格就清空
        this.$refs.cells[cell.p].select();
        this.cellClick(cell);
      },
      cellClick(cell){
        if(cell.c==""){
          this.lastCellClick.p=-1;           //从没有填充到有填充规定为重新点击
          this.cells.forEach((cell)=>{cell.isActive=false});
          return;
        }
        let rowSize=Math.sqrt(this.size);
        let farthestPos=this.getFarthestPos(cell);
        let isVerticalFill=(farthestPos.bottom-farthestPos.top>rowSize*2);
        let isHorizontalFill=(farthestPos.right-farthestPos.left>2);
        let activeCells=[];
        if(this.lastCellClick.p==cell.p&&isHorizontalFill&&isVerticalFill) {       //上下左右都有填充才能交换
          let isHorizontalActive=(this.cells[farthestPos.left+1].isActive&&this.cells[farthestPos.right-1].isActive);
          if (isHorizontalActive) {
            for(let i=farthestPos.top+rowSize;i<farthestPos.bottom;i+=rowSize){
              activeCells.push(i);
            }
          }else {
            for(let i=farthestPos.left+1;i<farthestPos.right;i++){
              activeCells.push(i);
            }
          }
        }else {
          if(isHorizontalFill){
            for(let i=farthestPos.left+1;i<farthestPos.right;i++){
              activeCells.push(i);
            }
          }else if(isVerticalFill){
            for(let i=farthestPos.top+rowSize;i<farthestPos.bottom;i+=rowSize){
              activeCells.push(i);
            }
          }
        }
        if(activeCells.length!=0){       //状态变化了
          this.cells.forEach((cell)=>{cell.isActive=false});
          activeCells.forEach((pos)=>{this.cells[pos].isActive=true});
        }
        this.lastCellClick.p=cell.p;
      },
      getFarthestPos(cell){             //get the cell's farthest left, right, top, bottom
        let rowSize=Math.sqrt(this.size);
        let pos_of_row=Math.floor(cell.p/rowSize);
        let pos_of_col=cell.p%rowSize;
        let left,right,top,bottom;
        left=right=top=bottom=cell.p;
        let fl=pos_of_row*rowSize,fr=rowSize*(pos_of_row+1),ft=pos_of_col,fb=(rowSize*rowSize-1)+pos_of_col;
        while (left>=fl&&this.cells[left].c!=""){
          left--;
        }
        while (right<fr&&this.cells[right].c!=""){
          right++;
        }
        while (top>=ft&&this.cells[top].c!=""){
          top-=rowSize;
        }
        while (bottom<=fb&&this.cells[bottom].c!=""){
          bottom+=rowSize;
        }
        return {top,bottom,left,right};
      }
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
    width: 30%;
  }

  .cells-container {
    --size: 4.8rem;
    width: fit-content;
    height: fit-content;
    display: grid;
    grid-template-columns: repeat(var(--row), var(--size));
    grid-template-rows: repeat(var(--column), var(--size));
    position: relative;
  }

  .cell {
    background-color: white;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.11);
    border-radius: 5px;
    margin: 5px;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    color: gray;
  }

  .is-active{
    background-color: lightgrey;
    transition: background-color ease-in-out .3s;
  }

  .col-box{

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
    transition: background-color ease-in-out .3s;
  }

  .el-input__inner::selection{
    color: gray;
    background-color: transparent;
  }
</style>
