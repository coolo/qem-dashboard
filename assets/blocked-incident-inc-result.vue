<template>
  <li v-bind:data-group-id="groupId">
    <result-summary v-bind:result="result"></result-summary>
  </li>
</template>

<script>
module.exports = {
  props: ['result', 'groupId']
};
</script>
