<template>
 <div class="row">
   <div class="col-md-12">
     <blocked-component ref="blocked"></blocked-component>
   </div>
  </div>
</template>

<script>
import BlockedComponent from './Blocked.vue'

export default {
 components: { BlockedComponent },
 mounted: function() {
    this.getBlocked();
    this.timer = setInterval(this.getBlocked, 10 * 60000);
  },
  methods: {
    getBlocked: function() {
      this.$refs.blocked.loadData();
    },
    cancelAutoUpdate () {
      clearInterval(this.timer);
    }
  },
  beforeDestroy () {
    this.cancelAutoUpdate();
  }
}
</script>
