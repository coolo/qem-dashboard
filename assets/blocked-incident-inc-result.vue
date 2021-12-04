<template>
  <li v-bind:data-group-id="group_id">
    <result-summary v-bind:result="result"></result-summary>
  </li>
</template>

<script>
module.exports = {
  props: ['result', 'group_id']
};
</script>
