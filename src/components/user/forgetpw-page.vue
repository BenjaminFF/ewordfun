<template>
  <div class="forgetpw-page">
    <canvas class="m-canvas" width="100%" height="100%" id="canvas"></canvas>
  </div>
</template>

<script>
  export default {
    name: "",
    data() {
      return {}
    },
    created() {
      this.initCanvas();
    },
    methods: {
      init() {

      },
      initCanvas() {
        this.$nextTick(() => {
          let canvas = document.getElementById("canvas");
          canvas.width = canvas.offsetWidth;
          canvas.height = canvas.offsetHeight;
          let ctx = canvas.getContext("2d");
          ctx.lineWidth = 0.04;
          ctx.clearRect(0, 0, canvas.width, canvas.height);
          let grid_cols = 60;
          let grid_rows = 60;
          let cell_width = canvas.width / grid_cols;
          ctx.beginPath();
          for (let row = 0; row <= grid_rows; row++) {
            let y = row * cell_width;
            ctx.moveTo(0, y);
            ctx.lineTo(canvas.width, y);
          }
          for (let col = 0; col <= grid_cols; col++) {
            let x = col * cell_width;
            ctx.moveTo(x, 0);
            ctx.lineTo(x, canvas.height);
          }
          ctx.stroke();
        })
      },
      fetchData() {

      }
    }
  }
</script>

<style scoped>
  .forgetpw-page {
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .m-canvas {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: white;
    z-index: -1;
  }
</style>
