<template>
  <div class="anim-list">
    <div class="wrap" ref="wrap" :style="{marginRight:-wrapStyle.moveX+'px'}" style="padding-top: 1rem">
      <slot></slot>
    </div>
    <div class="scrollbar"></div>
  </div>
</template>

<script>
  export default {
    name: "AnimList",
    data() {
      return {
        wrapStyle: {},
        tweenData: {},
        tweenX: {},
        tweenY: {},
        isTransiting:false
      }
    },
    mounted() {
      this.init();
    },
    computed: {
      wrap() {
        return this.$refs.wrap;
      }
    },
    watch: {},
    props: {
      items: {
        type: Array,
        required: true
      },
    },
    methods: {
      init() {
        this.wrapStyle = {
          width: this.wrap.clientWidth,
          moveX: this.wrap.offsetWidth - this.wrap.clientWidth
        };
      },
      addItem: function (index, item) {
        if(this.isTransiting){
          return;
        }
        this.isTransiting=true;
        this.items.splice(index, 0, item);
        this.$nextTick(() => {
          let e = this.$slots.default[index].elm;
          let o = e.getBoundingClientRect();
          let invertY = o.top - o.bottom;
          let invertX = o.left - o.right;
          e.style.transform = 'translateX(-100%)';
          this.tweenData = {
            x: -100,
            y: invertY,
            requestID: ""
          }
          this.tweenY = new TWEEN.Tween(this.tweenData).to({y: 0}, 300).easing(TWEEN.Easing.Linear.None).onUpdate(() => {
            let items = this.$slots.default;
            for (let i = index + 1; i < items.length; i++) {
              items[i].elm.style.transform = 'translateY(' + this.tweenData.y + 'px)';
            }
          }).onComplete(() => {
            this.tweenX = new TWEEN.Tween(this.tweenData).to({x: 0}, 1200).easing(TWEEN.Easing.Elastic.Out).onUpdate(() => {
              e.style.transform = 'translateX(' + this.tweenData.x + '%)';
            }).onComplete(() => {
              window.cancelAnimationFrame(this.tweenData.requestID);
              this.isTransiting=false;
            }).start();
          }).start();
          this.tweenAnimate();
        });
      },
      tweenAnimate() {
        this.tweenData.requestID = window.requestAnimationFrame(this.tweenAnimate);
        TWEEN.update();
      },
      delItem(index) {
        if(this.isTransiting){
          return;
        }
        let e = this.$slots.default[index].elm;
        let o = e.getBoundingClientRect();
        let invertY = o.top - o.bottom;
        let invertX = o.left - o.right;
        this.tweenData = {
          x: 0,
          y: -invertY,
          requestID: ""
        }
        this.tweenX = new TWEEN.Tween(this.tweenData).to({x: -invertX}, 500).easing(TWEEN.Easing.Back.In).onUpdate(() => {
          e.style.transform = 'translateX(' + this.tweenData.x + 'px)';
        }).onComplete(() => {
          this.items.splice(index,1);
          this.$nextTick(()=>{
            let items = this.$slots.default;
            for (let i = index; i < items.length; i++) {
              items[i].elm.style.transform = 'translateY(' + this.tweenData.y + 'px)';
            }
            this.tweenY = new TWEEN.Tween(this.tweenData).to({y: 0}, 300).onUpdate(() => {
              console.log(this.tweenData.y);
              for (let i = index; i < items.length; i++) {
                items[i].elm.style.transform = 'translateY(' + this.tweenData.y + 'px)';
              }
            }).onComplete(() => {
              window.cancelAnimationFrame(this.tweenData.requestID);
              this.isTransiting=false;
            }).start();
          })
        }).start();
        this.tweenAnimate();
      }
    }
  }
</script>

<style scoped>
  .anim-list {
    position: relative;
    overflow: hidden;
  }

  .wrap {
    height: 100%;
    overflow-y: scroll;
    overflow-x: hidden;
  }
</style>
