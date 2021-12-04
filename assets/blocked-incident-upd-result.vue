<template>
  <li v-bind:group-id="group_id"
    data-toggle="tooltip"
    data-placement="left"
    v-bind:title="title">
    <result-summary v-bind:result="result"></result-summary>
  </li>
</template>

<script>
module.exports = {
  props: ['result', 'group_id'],
  computed: {
    title: function() {
      return "Aggregate: " + this.result.linkinfo.flavor + "-" + this.result.linkinfo.version;
    },
  }
};
</script>
