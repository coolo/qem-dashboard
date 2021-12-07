<template>
  <li v-bind:data-group-id="groupId">
    <result-summary v-bind:result="result"></result-summary>
  </li>
</template>

<script>
import ResultSummaryComponent from './ResultSummary.vue';
export default {
  name: 'BlockedIncidentIncResultComponent',
  components: {'result-summary': ResultSummaryComponent},
  props: ['result', 'groupId']
};
</script>
